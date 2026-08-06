**Links:**
- [Back Home](../../README.md)
- [Documentation Key](./key-key.md)

---

# Niri

Scrollable tiling Wayland compositor. Configured via `modjar/usrbin/WindowManager[niri]/` with KDL config files and per-host inputs.

System-level: enabled in `sysSettings.niri.enable`.
User-level: enabled in `usrSettings.niri.enable`.

## Config structure

```
WindowManager[niri]/
├── config.kdl        # entry point — includes all other files
├── base.kdl          # layout, gaps, animations, cursor, misc
├── bindings.kdl      # all keybindings
├── rules.kdl         # window and layer rules
├── startups.kdl      # startup apps, environment
├── default.nix       # NixOS module — deploys config
└── host-inputs/
    ├── calender.kdl  # triple-monitor config
    ├── ziiemar.kdl   # laptop config
    ├── yilyonix.kdl  # test bench
    └── 0-unknown.kdl # fallback
```

## Validate config

```bash
niri validate -c ~/.config/niri/config.kdl
```

## Keybinds

`Mod` = `Super` on TTY, `Alt` when nested.

### Launchers
| Key | Action |
|---|---|
| `Mod+Return` | Terminal (foot) |
| `Mod+Shift+D` | Launcher (fuzzel) |
| `Mod+D` | Noctalia launcher |
| `Mod+E` | File manager (nautilus) |
| `Mod+A` | App store (bazaar) |
| `Mod+B` | Browser (librewolf) |
| `Mod+Shift+B` | Browser search (jsearch) |
| `Mod+S` | Noctalia settings |
| `Mod+G` | Gapless (g4music) |
| `Mod+C` | Color picker (hyprpicker) |
| `Mod+Alt+Space` | Emoji picker (jemoji) |
| `Mod+P` | Power menu (jpower) |
| `Mod+Z` | Zoom (woomer) |

### Core
| Key | Action |
|---|---|
| `Super+Q` | Close window |
| `Mod+Tab` | Toggle overview |
| `Mod+Shift+E` / `Ctrl+Alt+Delete` | Quit (with confirmation) |
| `Mod+Alt+L` | Lock screen (swaylock) |
| `Mod+Escape` | Toggle keyboard shortcuts inhibitor |

### Screenshot
| Key | Action |
|---|---|
| `Mod+Shift+S` | Screenshot (interactive) |
| `Mod+Ctrl+Shift+S` | Screenshot: full screen |
| `Mod+Alt+S` | Screenshot: focused window |

### Focus navigation (arrows or vim HJKL)
| Key | Action |
|---|---|
| `Mod+Left/Right` or `Mod+H/L` | Focus column left/right |
| `Mod+Up/Down` or `Mod+J/K` | Focus window up/down |

### Moving windows
| Key | Action |
|---|---|
| `Mod+Ctrl+arrows` or `Mod+Ctrl+HJKL` | Move column/window in direction |
| `Mod+Ctrl+Home/End` | Move column to first/last |
| `Mod+Home/End` | Focus first/last column |

### Monitor navigation
| Key | Action |
|---|---|
| `Mod+Shift+arrows` or `Mod+Shift+HJKL` | Focus monitor in direction |
| `Mod+Shift+Ctrl+arrows` or `Mod+Shift+Ctrl+HJKL` | Move column to monitor |

### Workspaces
| Key | Action |
|---|---|
| `Mod+Page_Up/Down` or `Mod+U/I` | Focus workspace up/down |
| `Mod+Ctrl+Page_Up/Down` or `Mod+Ctrl+U/I` | Move column to workspace |
| `Mod+Shift+Page_Up/Down` or `Mod+Shift+U/I` | Move workspace up/down |
| `Mod+1-9` | Focus workspace by index |
| `Mod+Ctrl+1-9` | Move column to workspace by index |
| `Mod+scroll` | Cycle workspaces |

### Column management (niri-specific)
| Key | Action |
|---|---|
| `Mod+Comma` | Consume window into column |
| `Mod+Ctrl+Period` | Expel window from column |
| `Mod+BracketLeft/Right` | Consume-or-expel window left/right |
| `Mod+W` | Toggle column tabbed display |

### Sizing
| Key | Action |
|---|---|
| `Mod+R` | Switch preset column width |
| `Mod+Shift+R` | Switch preset window height |
| `Mod+Ctrl+R` | Reset window height |
| `Mod+F` | Maximize column |
| `Mod+Shift+F` | Fullscreen window |
| `Mod+Ctrl+F` | Expand column to available width |
| `Mod+Minus/Equal` | Adjust column width -/+10% |
| `Mod+Shift+Minus/Equal` | Adjust window height -/+10% |
| `Mod+Shift+C` | Center column |
| `Mod+Ctrl+C` | Center all visible columns |

### Floating
| Key | Action |
|---|---|
| `Mod+V` | Toggle window floating |
| `Mod+Shift+V` | Switch focus between floating/tiling |

### Media keys
| Key | Action |
|---|---|
| `XF86Audio*` | Volume, mute, mic mute |
| `XF86MonBrightness*` | Screen brightness |
| `XF86Audio{Next,Prev,Play,Stop}` | Playerctl |

## Column-based layout

Niri uses columns instead of traditional tiling. Windows stack vertically within a column. Key concepts:

- **Consume** (`Mod+Comma`): pull a window from the right into your column
- **Expel** (`Mod+Ctrl+Period`): push the bottom window out to its own column
- **Tabbed** (`Mod+W`): toggle between stacked and tabbed display within a column
- **Width** (`Mod+R`): cycle through preset widths (1/3, 1/2, 2/3)

Workspaces are dynamic — they're created as needed and don't have fixed names like Hyprland.
