**Links:**
- [Back Home](../../README.md)
- [Self-Hosting Hub](./netkey.md)

---

# nixdraw

Self-hosted Excalidraw — a virtual whiteboard for sketching and hand-drawn diagrams. Runs as a Docker container.

## Accessing

**On the same machine as the server:**
```bash
http://localhost:3000
```
Type that exactly, no brackets. The default port is `3000`.

If you're connecting from a different device (phone, another PC) on the same network, you need the server machine's actual IP address. On the server machine, run:
```bash
ip a
```
and look for something like `192.168.1.42` under your network interface (usually `wlan0` or `eno1`/`enp...`). Then use:
```bash
http://192.168.1.42:3000 # (with your real IP swapped in)
```

So to be clear:
```bash
http://              # type exactly
<server-ip-or-localhost>  # replace entirely with either localhost or your real IP
:3000                # type exactly, this is the port for the server
```

Try `http://localhost:3000` first in a regular browser on the server machine — that's the simplest path to get started.

## Configuration

The port is configurable in your host's `system.nix`:

```nix
sysSettings.server.nixdraw = {
  enable = true;
  port = 3000; # default, change to any available port
};
```

> **Note:** nixdraw requires Docker. The module enables Docker automatically when `nixdraw.enable = true`.
