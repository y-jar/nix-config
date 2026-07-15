**Links:**
- [Back Home](../../README.md)
- [Self-Hosting Hub](./netkey.md)

---

# Webjar

Self-hosted link page for all your services. Served by nginx on port 80.

## Accessing

**On the same machine:**
```bash
http://localhost
```

From another device on your network:
```bash
http://<hostname>
```
Avahi resolves hostnames automatically (e.g. `http://whale`, `http://calender`).

Or find the IP with `ip a` and use:
```bash
http://192.168.1.42
```

### jsearch shortcut

Type `webjar` in the fuzzel launcher (`SUPER+Shift+B`) to open the page directly. The `jsearch` script detects the keyword and opens `http://$(hostname)` instead of searching the web.

## Configuration

Enabled per-host in `system.nix`:

```nix
sysSettings.server.webjar = {
  enable = true;
  port = 80; # default
};
```

## Files

| File | Purpose |
|---|---|
| `modjar/sysbin/server/webjar/index.html` | Page structure — service cards |
| `modjar/sysbin/server/webjar/style.css` | Dark theme, responsive grid |
| `modjar/sysbin/server/webjar/script.js` | Floating particles background (canvas) |
| `modjar/sysbin/server/webjar/default.nix` | NixOS module — nginx + activation script |

## Adding a service

Edit `index.html` and add a card block:
```html
<a class="card" href="http://host:port">
    <div class="card-icon">&#128EncodingException;</div>
    <div class="card-name">Service Name</div>
    <div class="card-desc">Short description.</div>
    <div class="card-host">hostname</div>
</a>
```

Then rebuild. The activation script copies files to `/var/lib/webjar/` on the next switch.
