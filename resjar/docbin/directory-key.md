**Links:**
- [Back Home](../../README.md)
- [Documentation Key](./key-key.md)

---

# Directory Key

```bash
.
├── hstjar/                     # Per-host configurations (one dir per machine)
│   ├── 0_TEMPLATE/             # Template for new hosts [system.nix + user.nix + hw config]
│   ├── calender/               # Main desktop PC
│   ├── candle/                 # Gaming mini build
│   ├── loom/                   # Silly PC
│   ├── vmjar/                  # Virtual machine config
│   ├── whale/                  # Server system
│   ├── yilyonix/               # Test bench (laptop/tablet)
│   └── ziiemar/                # Personal laptop (HP)
│
├── modjar/                     # Shared NixOS modules
│   ├── homekey.nix             # Home-manager entry point
│   ├── sysbin/                 # System-level modules (NixOS options under sysSettings.*)
│   │   ├── base.nix            # Always-active: core system, CLI tools, Wayland basics
│   │   ├── ai[cringe]/         # llama.cpp + Open WebUI (rocm/cuda/cpu)
│   │   ├── audio/              # PipeWire stack + audio tools
│   │   ├── bluetooth/          # Bluetooth hardware + Blueman
│   │   ├── cinnamon/           # Cinnamon desktop environment
│   │   ├── flatpak/            # Flatpak service
│   │   ├── fonts/              # System fonts (Nerd, Japanese, etc.)
│   │   ├── gamingSlashHardware/# Steam, gaming drivers, Vulkan, GStreamer
│   │   ├── gdm/                # GDM display manager
│   │   ├── gnome/              # GNOME desktop + companion apps
│   │   ├── hyprland/           # Hyprland compositor + companion apps
│   │   ├── localsend/          # LocalSend file sharing
│   │   ├── networking/         # OpenSSH, NetworkManager, firewall, Avahi
│   │   ├── niri/               # Niri compositor
│   │   ├── nix/                # Nix settings (nh, nix-ld, experimental features)
│   │   ├── portal/             # XDG portals (per-DE backend selection)
│   │   ├── ppd/                # Power Profiles Daemon
│   │   ├── security/           # Polkit, rtkit, udisks2
│   │   ├── server/             # Server modules (Jellyfin, sleepyjar, nixdraw)
│   │   ├── system[scripts]/    # System-level shell scripts (nhu, nru)
│   │   ├── tlp/                # TLP laptop power management + battery thresholds
│   │   ├── users/              # User account creation + groups
│   │   ├── v412/               # v4l2loopback kernel module (OBS virtual cam)
│   │   └── virt/               # libvirtd, QEMU, virt-manager
│   │
│   └── usrbin/                 # User-level modules (Home Manager options under usrSettings.*)
│       ├── ai[cringe]/         # LM Studio, opencode-desktop, AI scripts
│       ├── art/                # Blender, Krita, GIMP, Inkscape, Stellarium
│       ├── Bar[noctalia]/      # Noctalia shell (Wayland bar)
│       ├── bluetooth/          # Blueman GUI package
│       ├── browsers/           # Firefox / LibreWolf + browsh
│       ├── desktop-tweaks/     # Wayland session variables
│       ├── dev/                # Dev tools (dotnet, python, node, gcc, go, nix tools)
│       ├── discord/            # Discord client
│       ├── editors/            # VSCodium, Zed, Obsidian, Helix, NVF neovim
│       ├── fastfetch/          # Fastfetch system info
│       ├── file-explorers/     # Nautilus, Yazi, Ranger
│       ├── flatpak/            # Flatpak CLI + Bazaar
│       ├── gaming/             # Heroic launcher, Prism Launcher
│       ├── git/                # Git + gh + lazygit
│       ├── japanese/           # fcitx5 + Mozc input method
│       ├── keepass/            # KeePassXC password manager
│       ├── launcher[fuzzel]/   # Fuzzel launcher + custom scripts
│       ├── media/              # MPV, blanket, quodlibet, ffmpeg, yt-dlp
│       ├── obs/                # OBS Studio + plugins
│       ├── office/             # LibreOffice + Pandoc
│       ├── polkit/             # Polkit agent systemd service
│       ├── resYoink/           # Resource symlinks (wallpapers, icons, pfps → ~/resjar/)
│       ├── terminal/           # Foot + Kitty + Alacritty
│       ├── theming/            # GTK/Qt Catppuccin theming
│       ├── user[directories]/  # XDG dirs + custom jar-directories
│       ├── user[info]/         # Username + email options (used by git)
│       ├── user[packages]/     # General packages (bat, fzf, fd, btop, etc.)
│       ├── user[scripts]/      # User-level scripts (bldjar, fixzsh)
│       ├── video-editors/      # Kdenlive
│       ├── WindowManager[hyprland]/ # Hyprland config files (Lua, per-host inputs)
│       ├── WindowManager[niri]/     # Niri config files (KDL, per-host inputs)
│       └── zsh/                # Zsh config + aliases + fzf integration
│
└── resjar/                     # Resources (docs, nix templates, images)
    ├── docbin/                 # Documentation (this file lives here)
    ├── imagebin/               # Images (logos, screenshots)
    └── nixbin/                 # Nix templates and reference code
```
