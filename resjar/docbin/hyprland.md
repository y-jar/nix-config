**Links:**
- [Back Home](../../README.md)
- [Documentation Key](./key-key.md)

---

# Hyprland

Dynamic tiling Wayland compositor. Config lives in
[juajar/WMs/hyprland/](../../juajar/WMs/hyprland) as Lua files, symlinked into
`~/.config/hypr/`.

- **System side:** `sysset.hyprland.enable` (installs the package).
- **User side:** `usrset.hyprland.enable` (deploys the config, picks host inputs).

## How it's wired

The WM dir has two halves: its system module and its user module, plus the raw
config data. Per-machine monitor layouts live in `host-inputs/<host>.lua`, with a
`0-unknown.lua` fallback selected by hostname. See
[Desktops & Shells](./desktops-shells.md) for the general pattern.

## Per-monitor workspaces

Each monitor gets a range of 10 workspaces, ordered by position (x, then y):
1st → 1–10, 2nd → 11–20, 3rd → 21–30. `SUPER+1` targets workspace 1 on the
focused monitor. Single-monitor hosts just get 1–10, no config needed.

## Adding a host

Create `host-inputs/<hostname>.lua`:

```lua
hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "0x0",
    scale    = "auto",
    defaultWorkspace = "1",
})
```

If no host file matches, `0-unknown.lua` is used.

Keybinds are defined in the WM's config files — read them there.
