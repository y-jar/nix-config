**Links:**
- [Back Home](../../README.md)
- [Documentation Key](./key-key.md)

---

# Directory Key

```bash
.
├── hstjar/                     # Per-host configurations (one dir per machine)
│   ├── 0_TEMPLATE/             # Template for new hosts [system.nix + user.nix + hw config]
│   ├── 0_MINIMAL/              # Lean template (bare essentials only)
│   ├── calender/               # Main desktop PC [runs hjem]
│   ├── candle/                 # Gaming mini build
│   ├── petrichor/              # kwaytea's Pewta
│   ├── vmjar/                  # Virtual machine config
│   ├── whale/                  # Server system
│   ├── yil01/                  # Thinkpad laptop [also live as yil02 on hjem]
│   ├── yilyonix/               # Test bench (laptop/tablet)
│   └── ziiemar/                # Personal laptop (HP)
│
├── juajar/                     # Shared NixOS modules
│   ├── hjemkey.nix             # Hjem entry point (THE user backend)
│   └── liijar/                 # User-level apps (hjem scope)
│       ├── default.nix         # Auto-importer (same as sysjar) every app dir
│       ├── options.nix         # The usrset.* option declarations (single source)
│       ├── profile-bus.nix     # .profile dirSetup lines bus
│       ├── shell/              # Shared zsh aliases + functions + repl
│       ├── wmconfigs/          # Raw niri/mango KDL/conf + j* wm tool scripts
│       └── <app>/              # One dir per app: default.nix (+ asset siblings)
│   ├── sysjar/                 # System-level modules (NixOS options under sysset.*)
│   │   ├── base.nix            # Always-active: core system, CLI tools, Wayland basics
│   │   ├── kernelPicker.nix    # Kernel variant picker (default/cachyos-latest/...)
│   │   ├── ai[cringe]/         # llama.cpp + Open WebUI (rocm/cuda/cpu)
│   │   ├── audio/              # PipeWire stack + audio tools (+ jar-audio addon)
│   │   ├── automount/          # Auto-mount removable media (udisks2)
│   │   ├── autostart/          # WM session autostart commands (sysset.autostart)
│   │   ├── bluetooth/          # Bluetooth hardware
│   │   ├── cinnamon/           # Cinnamon desktop environment
│   │   ├── console/            # TTY console font
│   │   ├── cosmic/             # COSMIC desktop environment + greeter
│   │   ├── espanso/            # Espanso daemon + Wayland security wrapper
│   │   ├── flatpak/            # Flatpak service
│   │   ├── fonts&emoji/        # System fonts + emoji (Nerd, Japanese, tape font)
│   │   ├── gamingSlashHardware/# Steam, gaming drivers, Vulkan, GStreamer
│   │   ├── gdm/                # GDM display manager
│   │   ├── gnome/              # GNOME desktop + companion apps
│   │   ├── localsend/          # LocalSend file sharing
│   │   ├── networking/         # OpenSSH, NetworkManager, firewall, Avahi
│   │   ├── neverSleep/         # Disable system idle sleep
│   │   ├── nix/                # Nix settings (nh, nix-ld, experimental features)
│   │   ├── nvf/                # System-level nvf neovim config (bridged from usrset)
│   │   ├── nvidia/             # NVIDIA GPU drivers
│   │   ├── plymouth/           # Boot splash logo
│   │   ├── polkit/             # Polkit auth agent (gnome)
│   │   ├── portal/             # XDG portals (per-DE backend selection)
│   │   ├── ppd/                # Power Profiles Daemon
│   │   ├── security/           # Polkit rules, rtkit, udisks2
│   │   ├── server/             # Server modules (Jellyfin, sleepyjar, nixdraw, webjar, vpn)
│   │   ├── syncthing/          # System syncthing service
│   │   ├── system[scripts]/    # System-level shell scripts (nhu, nru)
│   │   ├── tlp/                # TLP laptop power management + battery thresholds
│   │   ├── users/              # User account creation + groups
│   │   ├── v412/               # v4l2loopback kernel module (OBS virtual cam)
│   │   ├── virt/               # libvirtd, QEMU, virt-manager
│   │   ├── webapps/            # Web-apps-as-desktop-apps definitions (sysset.webapps)
│   │   ├── WM-hyprland/        # Hyprland compositor enable + companion apps
│   │   ├── WM-mango/           # Mango compositor enable
│   │   └── WM-niri/            # Niri compositor enable
│
└── resjar/                     # Resources (docs, nix templates, images)
    ├── asciiartbin/            # ASCII art banners (the jar sig, jn banner)
    ├── docbin/                 # Documentation (this file lives here)
    ├── fontbin/                # Custom fonts (x5y8pxNegaTape)
    ├── imagebin/               # Images (logos, screenshots)
    ├── nixbin/                 # Installer + test scripts (jarhelp, install.sh)
    └── shotbin/                # Screenshots
```
