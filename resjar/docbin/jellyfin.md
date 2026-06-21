# Jellyfin

**Links:**
- [Back Home](../../README.md)
- [back to documentation key](./key-key.md)

### Easiest options i found that sets up Jellyfin!
**If you're setting it up on the same machine that runs the Jellyfin server:**
```bash
http://localhost:8096
```
Type that exactly, no brackets.
If you're connecting from a different device (phone, another PC) on the same network, you need the server machine's actual IP address. On the server machine, run:
```bash
ip a
```
and look for something like 192.168.1.42 under your network interface (usually wlan0 or eno1/enp...). Then use:
```bash
http://192.168.1.42:8096 # (with your real IP swapped in).
```

So to be clear:
```bash
http:// # type exactly
<server-ip-or-localhost> # replace entirely with either localhost or your real IP
:8096 # type exactly, this is the port for the server [also 8096 is open i think]
```

Try `http://localhost:8096` first in a regular browser on the server machine — that's the simplest path to the setup wizard.
