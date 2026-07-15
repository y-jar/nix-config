**Links:**
- [Back Home](../../README.md)
- [Documentation Key](./key-key.md)

---

# Self-Hosting Hub

Self-hosted services and server configuration.

## Services

- [Jellyfin](./jellyfin.md) — Media server for movies, TV, music, and books
- [nixdraw](./nixdraw.md) — Self-hosted Excalidraw whiteboard via Docker

## Other

- **sleepyjar** — Scheduled server reboots. Enabled via `sysSettings.server.sleepyjar.enable`. Interval is configurable with `sysSettings.server.sleepyjar.interval` using systemd calendar expressions (e.g. `"daily"`, `"weekly"`, `"*-*-* 04:00:00"`). Defaults to `"weekly"`.
