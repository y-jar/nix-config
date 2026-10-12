**Links:**
- [Back Home](../../README.md)
- [Documentation Key](./key-key.md)

---

# Directory Key

```bash
.
├── flake.nix                   # Inputs + hosts (mkJar) + recovery ISOs (mkIso); installer marker for new hosts
├── shell.nix                   # Installer shell (hardto, nhs, nht, jc, ...)
│
├── hstjar/                     # Per-host configurations (one dir per machine)
│   ├── 0_TEMPLATE/             # Template for new hosts (every file a host can have)
│   ├── 0_MINIMAL/              # Lean template (bare essentials only; not in the flake)
│   ├── calender/               # Main desktop PC
│   ├── candle/                 # Gaming mini build
│   ├── fearra/                 # Personal theater pc
│   ├── petrichor/              # kwaytea's Pewta
│   ├── vmjar/                  # Virtual machine config
│   ├── whale/                  # Server system
│   ├── yil01/                  # Thinkpad laptop
│   ├── yilyonix/               # Test bench (laptop/tablet)
│   ├── ziiemar/                # Personal laptop (HP) (+ hardware-fix.nix, firmware/)
│   └── <host>/                 # Every host dir holds:
│       ├── default.nix         #   imports the files below (NixOS side)
│       ├── system.nix          #   sysset.* toggle sheet
│       ├── user.nix            #   usrset.* toggle sheet (loaded by hjem, NOT imported by default.nix)
│       ├── hardware-configuration.nix  # nixos-generate-config output
│       ├── boot.nix            #   bootloader
│       ├── autostart.nix       #   sysset.autostart.commands
│       ├── webapps.nix         #   sysset.webapps (browser apps as desktop apps)
│       ├── net.nix             #   (optional) fleet identity: ip + ssh host key. Pure data, read via import
│       └── mnt.nix             #   (optional) extra mounts
│
├── juajar/                     # Shared modules
│   ├── hjemkey.nix             # Hjem entry point (THE user backend): hjem wiring only
│   ├── bridge.nix              # The ONLY place sysset <-> usrset meet (usrset.system facts, user -> system toggles)
│   ├── data/                   # Shared data (slug.nix, espansoconf.nix, tabletconf.nix)
│   ├── liijar/                 # User-level apps (hjem scope, options under usrset.*)
│   │   ├── default.nix         # Auto-importer: every root .nix + every dir with a default.nix
│   │   ├── options.nix         # The usrset.* option declarations (single source)
│   │   ├── platform.nix        # usrset.packages.install switch
│   │   ├── profile-bus.nix     # writes ~/.profile (POSIX sh) + the dirSetup lines bus
│   │   ├── zsh/                # zsh module + shared aliases/functions (+ nixos-only variants) + repl
│   │   └── <app>/              # One dir per app: default.nix (+ asset siblings). cowsay/ is the reference
│   ├── WMs/                    # Window managers, one dir each
│   │   ├── default.nix         # Router, NixOS side: imports every <wm>/system.nix
│   │   ├── hjem.nix            # Router, hjem side: imports every <wm>/user.nix
│   │   ├── lib.nix             # Shared helpers (host-inputs lookup w/ 0-unknown fallback)
│   │   ├── shelljar-config.kdl # Shared shelljar config
│   │   └── <wm>/               # hyprland | niri | mango: system.nix + user.nix + raw config data + host-inputs/
│   └── sysjar/                 # System-level modules (NixOS options under sysset.*)
│       ├── default.nix         # Auto-importer: every root .nix + every dir
│       ├── base.nix            # Core: boot opts, hasDesktop, base package groups, zsh, timezone
│       ├── checks.nix          # Cross-module assertions (one DE, port clashes, ...)
│       ├── ai/                 # llama.cpp + Open WebUI (rocm/cuda/cpu)
│       ├── audio/              # PipeWire stack + audio tools (+ jar-audio addon)
│       ├── automount/          # Auto-mount removable media (udisks2)
│       ├── autostart/          # WM session autostart commands (sysset.autostart)
│       ├── bluetooth/          # Bluetooth hardware
│       ├── cinnamon/           # Cinnamon desktop environment
│       ├── console/            # TTY console font
│       ├── cosmic/             # COSMIC desktop environment + greeter
│       ├── espanso/            # Espanso daemon + Wayland security wrapper
│       ├── flatpak/            # Flatpak service
│       ├── fonts/              # System fonts + emoji (Nerd, Japanese, tape font)
│       ├── gaming/             # Steam, gaming drivers, Vulkan, GStreamer
│       ├── gdm/                # GDM display manager
│       ├── gnome/              # GNOME desktop + companion apps
│       ├── kernel/             # Kernel variant picker (default/latest/cachyos-*)
│       ├── localsend/          # LocalSend file sharing
│       ├── networking/         # Base (NetworkManager, ssh, avahi, dns, bbr, mullvad) + fleet.nix (pins)
│       ├── neverSleep/         # Disable system idle sleep
│       ├── nix/                # Nix settings (flakes, unfree, nh, nix-ld, store clean) + overlays
│       ├── nvf/                # System-level nvf neovim config (bridged from usrset)
│       ├── nvidia/             # NVIDIA GPU drivers
│       ├── plymouth/           # Boot splash logo
│       ├── polkit/             # Polkit auth AGENT (gnome); the daemon is in security/
│       ├── portal/             # XDG portals (per-DE backend selection)
│       ├── powerProfiles/      # Power Profiles Daemon
│       ├── security/           # Polkit daemon + rtkit toggles
│       ├── server/             # Jellyfin, komga, sleepyjar, nixdraw, webjar, outline, authentik, mysql, cockpit
│       ├── syncthing/          # System syncthing service
│       ├── systemScripts/      # System-level shell scripts (nru, updatejar)
│       ├── theming/            # System theming facts (dconf/flatpak), bridged from usrset
│       ├── tlp/                # TLP laptop power management + battery thresholds
│       ├── users/              # User accounts, groups, sanity assertions
│       ├── virt/               # virt role: none | host (libvirtd/QEMU) | guest (qemu-guest)
│       ├── virtCam/            # v4l2loopback kernel module (OBS virtual cam)
│       └── webapps/            # Web-apps-as-desktop-apps definitions (sysset.webapps)
│
└── resjar/                     # Resources (docs, nix templates, images)
    ├── asciiartbin/            # ASCII art banners (the jar sig, jn banner)
    ├── docbin/                 # Documentation (this file lives here)
    ├── fontbin/                # Custom fonts (x5y8pxNegaTape)
    ├── imagebin/               # Images (logos, screenshots)
    ├── nixbin/                 # Installer + test scripts (jarhelp, nixinstall)
    ├── scriptdepbin/           # Script dependencies (watermark)
    └── shotbin/                # Screenshots
```
