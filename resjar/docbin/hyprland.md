**Links:**
- [Back Home](../../README.md)
- [Documentation Key](./key-key.md)

---

# Hyprland

Configured via `modjar/usrbin/WindowManager[hyprland]/`. Symlinks Lua config files into `~/.config/hypr/` with per-host inputs for different machines.

System-level: enabled in `sysSettings.hyprland.enable` (~19MiB).
User-level: enabled in `usrSettings.hyprland.enable`.

## Config structure

```
WindowManager[hyprland]/
├── base.lua              # entry point — requires all hl/*.lua files
├── default.nix           # NixOS module — deploys config, selects host-inputs
├── hl/
│   ├── animations.lua    # animation curves
│   ├── autostart.lua     # startup apps (noctalia, easyeffects, etc.)
│   ├── colors.lua        # color definitions
│   ├── genr.lua          # general settings — layout, gaps, blur, input, cursor
│   ├── keybinds.lua      # all keybindings
│   ├── rules.lua         # window, workspace, and layer rules
│   ├── shell-rules.lua   # noctalia/wayle layer rules
│   ├── vars.lua          # variables — app names, modifiers
│   └── scripts-bin/
│       ├── hypr-workspace.sh   # per-monitor workspace dispatcher
│       └── launch_first_available.sh
└── host-inputs/
    ├── calender.lua      # triple-monitor config (DP-3, HDMI-A-1, DP-2)
    ├── ziiemar.lua       # laptop config
    ├── yilyonix.lua      # test bench
    └── 0-unknown.lua     # fallback
```

## Per-monitor workspaces

Each monitor gets its own range of 10 workspaces. Monitors are ordered by position (x, then y), and each gets an offset:

| Position order | Workspace range |
|---|---|
| 1st monitor | 1–10 |
| 2nd monitor | 11–20 |
| 3rd monitor | 21–30 |

`SUPER+1` switches to workspace 1 on whichever monitor you're focused on. Focus stays on the current monitor.

Implemented by `hl/scripts-bin/hypr-workspace.sh` — detects the current monitor via `hyprctl activeworkspace`, calculates the absolute workspace number, and dispatches.

Single-monitor hosts automatically get workspaces 1–10 (no config needed).

## Keybinds

### Launchers
| Key | Action |
|---|---|
| `SUPER+Return` | Terminal (foot) |
| `SUPER+Space` / `SUPER+Shift+D` | Launcher (fuzzel) |
| `SUPER+E` | File manager (nautilus) |
| `SUPER+Shift+E` | Text editor (neovim) |
| `SUPER+A` | App store (bazaar) |
| `SUPER+B` | Browser (librewolf) |
| `SUPER+Shift+B` | Browser search (jsearch) |
| `SUPER+Shift+V` | Volume mixer (pavucontrol) |
| `SUPER+G` | Gapless (g4music) |
| `SUPER+C` | Color picker (hyprpicker) |
| `SUPER+Period` | Emoji picker (jemoji) |

### Noctalia shell
| Key | Action |
|---|---|
| `SUPER+D` | Launcher toggle |
| `SUPER+S` | Panel toggle |
| `SUPER+comma` | Settings toggle |

### Core
| Key | Action |
|---|---|
| `SUPER+Q` | Close window |
| `SUPER+Shift+Q` | Shutdown/exit |
| `SUPER+Shift+Alt+Q` | Force kill |
| `SUPER+Alt+L` | Lock screen (swaylock) |

### Screenshot
| Key | Action |
|---|---|
| `SUPER+Shift+S` | Screenshot: region (hyprshot) |
| `SUPER+Ctrl+Shift+S` | Screenshot: screen |
| `SUPER+Alt+S` | Screenshot: window |

### Window manipulation
| Key | Action |
|---|---|
| `SUPER+V` | Toggle float |
| `SUPER+F` | Fullscreen |
| `SUPER+Shift+F` | Maximize |
| `SUPER+grave` | Scratchpad toggle |
| `SUPER+M` | Move to scratchpad |
| `SUPER+J` | Toggle split layout |

### Focus navigation
| Key | Action |
|---|---|
| `SUPER+arrows` | Focus direction |
| `SUPER+brackets` | Focus left/right |
| `SUPER+Shift+arrows` | Move window direction |

### Workspaces
| Key | Action |
|---|---|
| `SUPER+[1-0]` | Switch workspace (on current monitor) |
| `SUPER+Shift+[1-0]` | Move window to workspace |
| `SUPER+Shift+Page_Up/Down` | Move window left/right |
| `SUPER+scroll` | Cycle workspaces |

### Media keys
| Key | Action |
|---|---|
| `XF86Audio*` | Volume, mute, mic mute |
| `XF86MonBrightness*` | Screen brightness |
| `XF86Audio{Next,Prev,Play,Pause}` | Playerctl |

## Adding a new host

Create `host-inputs/<hostname>.lua` with monitor definitions:

```lua
hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "0x0",
    scale    = "auto",
    defaultWorkspace = "1",
})
```

The `default.nix` module auto-selects the host file by hostname. If no match is found, `0-unknown.lua` is used.
