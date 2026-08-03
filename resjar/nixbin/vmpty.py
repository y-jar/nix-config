#!/usr/bin/env python3
"""Drive a QEMU serial unix socket from a driver script.

Usage:
  vmpty.py --socket PATH --script FILE --log FILE \
      [--timeout SEC] [--panic REGEX [--panic REGEX ...]]

Script lines (one per line, # is a comment):
  wait <regex>          wait (up to --timeout) for regex in output
  send <text>           send text now; \r \n and \x1b[... escapes supported
  sleep <n>             sleep n seconds
  mark <name> <regex>   wait for regex; save the matched text as marker <name>
  barrier <n>           set per-wait timeout to n seconds (until next barrier)

Sends are flushed immediately after a wait/mark returns so prompt-answer
sequences are not collapsed.  Panic regexes abort immediately if matched
anywhere in the stream (e.g. an unexpected reboot).
"""

import argparse
import codecs
import re
import select
import socket
import sys
import time


def decode_send(text):
    return (text
            .replace("\\x1b[B", "\x1b[B").replace("\\x1b[C", "\x1b[C")
            .replace("\\x1b[A", "\x1b[A").replace("\\x1b[D", "\x1b[D")
            .replace("\\x1b[", "\x1b[").replace("\\r", "\r").replace("\\n", "\n"))


class Driver:
    def __init__(self, path, script_path, log_path, timeout, panics):
        self.path = path
        self.script_path = script_path
        self.log_path = log_path
        self.timeout = timeout
        self.panics = [re.compile(p) for p in panics]
        self.buf = ""
        self.pos = 0
        self.markers = {}
        self.sock = None
        self.log = None

    def connect(self):
        deadline = time.time() + self.timeout
        while True:
            try:
                self.sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
                self.sock.connect(self.path)
                return
            except (ConnectionRefusedError, FileNotFoundError):
                self.sock.close()
                self.sock = None
                if time.time() > deadline:
                    raise RuntimeError(
                        f"could not connect to serial socket {self.path} within {self.timeout}s")
                time.sleep(0.3)

    def read_more(self, secs):
        if self.sock is None:
            return b""
        r, _, _ = select.select([self.sock], [], [], secs)
        if not r:
            return b""
        data = self.sock.recv(65536)
        if not data:
            raise RuntimeError("serial socket closed")
        return data

    def feed(self, data):
        text = data.decode("utf-8", errors="replace")
        self.buf += text
        self.log.write(text)
        self.log.flush()
        for p in self.panics:
            if p.search(text):
                raise RuntimeError(
                    f"panic pattern matched: {p.pattern!r} (unexpected reboot/crash)")
        self._auto_reply(data)

    def _auto_reply(self, data):
        # Emulate a terminal: answer gum/fzf terminfo probes so they don't block.
        if b"\x1b[6n" in data:        # cursor position report
            self.sock.sendall(b"\x1b[1;1R")
        if b"\x1b[18t" in data:        # text-area size (rows;cols)
            self.sock.sendall(b"\x1b[8;50;160t")
        if b"\x1b]11;?" in data:        # OSC 11 background-color query
            self.sock.sendall(b"\x1b]11;rgb:0000/0000/0000\x1b\\")
        if b"\x1b[5n" in data:          # device status report
            self.sock.sendall(b"\x1b[0n")
        if b"\x1b[c" in data or b"\x1b[0c" in data:  # primary device attributes
            self.sock.sendall(b"\x1b[?6c")

    def wait_for(self, regex, timeout):
        rx = re.compile(regex)
        deadline = time.time() + timeout
        while True:
            m = rx.search(self.buf[self.pos:])
            if m:
                self.pos += m.end()
                return m
            remaining = deadline - time.time()
            if remaining <= 0:
                tail = self.buf[-1500:]
                raise RuntimeError(
                    f"timeout after {timeout}s waiting for {regex!r}; tail:\n{tail}")
            data = self.read_more(min(0.5, remaining))
            if data:
                self.feed(data)

    def run(self):
        self.connect()
        with open(self.log_path, "w") as self.log:
            timeout = self.timeout
            lines = [ln.strip() for ln in open(self.script_path)
                     if ln.strip() and not ln.strip().startswith("#")]
            for ln in lines:
                parts = ln.split(None, 1)
                cmd, arg = parts[0], (parts[1] if len(parts) > 1 else "")
                if cmd == "wait":
                    self.wait_for(arg, timeout)
                    print(f"  wait ok: {arg}", flush=True)
                elif cmd == "mark":
                    name, _, rx = arg.partition(" ")
                    m = self.wait_for(rx, timeout)
                    self.markers[name] = m.group(0)
                    print(f"  mark ok: {name} = {m.group(0)!r}", flush=True)
                elif cmd == "send":
                    payload = decode_send(arg).encode("utf-8")
                    self.sock.sendall(payload)
                    print(f"  sent: {arg!r}", flush=True)
                elif cmd == "sleep":
                    time.sleep(float(arg))
                    print(f"  slept {arg}s", flush=True)
                elif cmd == "barrier":
                    timeout = float(arg)
                    print(f"  barrier: wait timeout now {timeout}s", flush=True)
                elif cmd == "assert_marker":
                    name, _, pat = arg.partition(" ")
                    val = self.markers.get(name)
                    if val is None or not re.search(pat, val):
                        raise RuntimeError(
                            f"assert_marker failed: {name}={val!r} does not match {pat!r}")
                    print(f"  assert ok: {name} matches {pat}", flush=True)
                else:
                    raise RuntimeError(f"unknown script command: {cmd}")
        with open(self.log_path + ".markers", "w") as f:
            for k, v in self.markers.items():
                f.write(f"{k}={v}\n")
        print(f"markers: {self.markers}", flush=True)
        print("ALL DRIVER STEPS COMPLETE", flush=True)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--socket", required=True)
    ap.add_argument("--script", required=True)
    ap.add_argument("--log", required=True)
    ap.add_argument("--timeout", type=float, default=180.0)
    ap.add_argument("--panic", action="append", default=[], metavar="REGEX")
    args = ap.parse_args()

    panics = args.panic or [
        r"reboot: Restarting system",
        r"reboot: Power down",
        r"systemd-shutdown\[1\]: Rebooting",
        r"Kernel panic",
        r"BUG: unable to handle kernel",
    ]
    d = Driver(args.socket, args.script, args.log, args.timeout, panics)
    try:
        d.run()
    except RuntimeError as e:
        print(f"DRIVER FAILED: {e}", file=sys.stderr, flush=True)
        sys.exit(2)


if __name__ == "__main__":
    main()
