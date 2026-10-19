**Links:**
- [Back Home](../../README.md)
- [Documentation Key](./key-key.md)

---

# Desktops & Shells

The config can run a full desktop environment, a bare compositor, or a
compositor plus a shell. They're independent pieces, wired per host.

## The three layers

- **Desktop environment (DE)**: a full stack: compositor + panels + apps +
  greeter. Picked with `sysset.<de>.enable`. In this repo: `gnome`, `cinnamon`,
  `cosmic`.
- **Compositor / window manager (WM)**: just the Wayland compositor and its
  keybinds. One dir per WM under [WMs/](../../juajar/WMs), with a system half and
  a hjem half. In this repo: `hyprland`, `niri`, `mango`.
- **Shell**: a bar/panel/launcher that draws on top of a compositor
  (lastwallpaper, workspaces, tray). In this repo: `noctalia`, `wayle`, both
  built on Quickshell and spawned by the WM that enables them.

A DE usually brings its own shell, so you rarely pair a DE with one of these.
Check the host's `system.nix` (system side) and `user.nix` (user side) to see
what's on.

## Where to look

- compositor + keybinds: [WMs/](../../juajar/WMs), see [Niri](./niri.md) and
  [Hyprland](./hyprland.md)
- desktop environment: `juajar/sysjar/<de>/` (`gnome`, `cinnamon`, `cosmic`)
- shell toggles: `usrset.<wm>.noctalia.enable` / `usrset.<wm>.wayle.enable`

Keybinds are defined in each WM's config files. Read them there, don't trust a
copy in a doc.
