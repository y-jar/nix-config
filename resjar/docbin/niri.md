**Links:**
- [Back Home](../../README.md)
- [Documentation Key](./key-key.md)

---

# Niri

Scrollable-tiling Wayland compositor. Config lives in
[juajar/WMs/niri/](../../juajar/WMs/niri) as KDL files.

- **System side:** `sysset.niri.enable`.
- **User side:** `usrset.niri.enable` (deploys the config, picks host inputs).

## How it's wired

Same shape as the other WMs: a system half, a user half, and raw config data.
Per-machine monitor layouts live in `host-inputs/<host>.kdl`, with a
`0-unknown.kdl` fallback selected by hostname. See
[Desktops & Shells](./desktops-shells.md) for the general pattern.

## Validate config

```bash
niri validate -c ~/.config/niri/config.kdl
```

## Columns (the niri idea)

Niri lays windows out in columns instead of a grid. Windows stack vertically
inside a column; you move columns and windows around them.

- **Consume:** pull a window from the right into your column
- **Expel:** push the bottom window out into its own column
- **Tabbed:** toggle stacked vs tabbed within a column
- **Width:** cycle preset column widths

Workspaces are dynamic, created as needed, no fixed names like Hyprland.

Keybinds are defined in the WM's config files; read them there.
