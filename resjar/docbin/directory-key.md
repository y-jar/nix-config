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
│   ├── vmjar/                  # Virtual machine config
│   ├── whale/                  # Server system
│   ├── yilyonix/               # Test bench (laptop/tablet)
│   └── ziiemar/                # Personal laptop (HP)
│
├── juajar/                     # Shared NixOS modules
│   ├── homekey.nix             # Home-manager entry point
│   ├── hjemkey.nix             # Hjem entry point (alternative to home-manager)
│   ├── liijar/                 # User-level apps — shared by BOTH backends
│   │   ├── options.nix         # The usrset.* option declarations (single source)
│   │   ├── hm.nix              # HM entry: auto-imports every <app>/hm.nix
│   │   ├── hjem.nix            # hjem entry: auto-imports every <app>/hjem.nix
│   │   ├── profile-bus.nix     # .profile dirSetup lines bus (hjem backend)
│   │   ├── shell/              # Shared zsh aliases + functions + repl (both backends)
│   │   ├── wmconfigs/          # Raw niri/mango KDL/conf + j* wm tool scripts
│   │   └── <app>/              # One dir per app:
│   │       ├── shared.nix      #   single-sourced packages + generated files
│   │       ├── hm.nix          #   home-manager adapter (programs.*/home.file)
│   │       └── hjem.nix        #   hjem adapter (files/packages, direct writes)
│   ├── sysjar/                 # System-level modules (NixOS options under sysset.*)
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
│
└── resjar/                     # Resources (docs, nix templates, images)
    ├── docbin/                 # Documentation (this file lives here)
    ├── imagebin/               # Images (logos, screenshots)
    └── nixbin/                 # Nix templates and reference code
```
