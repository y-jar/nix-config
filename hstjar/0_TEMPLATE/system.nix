# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host 0_TEMPLATE: system-level toggle sheet (sysset).
# -=-=-=-=-=-=-=-=-=-=-=
# This is the SYSTEM configuration file for this host (the `sysset` sheet).
#
# HOW TO USE THIS TEMPLATE
#   - It's a checklist: enable what you need, leave the rest off (every option
#     is opt-in; most default to false).
#   - Replace every `PLEASECHANGEME_*` with real values.
#   - `system.stateVersion` is a first-install marker: set it once and never bump.
#   - Pair options here with the matching user toggles in ./user.nix.
#   - Copy this whole directory to hstjar/<name>/ and add `mkJar "<name>"` in flake.nix.
#
# WHERE THE OPTIONS LIVE
#   - Every `sysset.*` option is declared by a module under juajar/sysjar/<name>/.
#     Read that module (or its `description`) for the full option surface, e.g.
#     juajar/sysjar/server/mysql.nix for `sysset.server.mysql`.
#   - Hardware/disk config is per-machine in ./hardware-configuration.nix and is
#     generated with `hardto <host>`; do not hand-edit it.
{ ... }: {
  config = {
    system.stateVersion = "VersionNumber"; # [first-install marker: do NOT bump]

    # Fill this out!
    sysset = {
      # =============[users]
      mainUser = "PLEASECHANGEME_USERNAME"; # primary user (gets hjem)
      users = [ "PLEASECHANGEME_USERNAME" ]; # all users (main + any guests)
      adminUsers = [ "PLEASECHANGEME_USERNAME" ]; # users with sudo access
      userDescriptions = {
        PLEASECHANGEME_USERNAME = "NAME";
        # add more users as needed
      };
      # NOTE: computed, do NOT set by hand:
      #   hasDesktop        (base.nix derives it from the WM toggles below)
      #   usesElectronEditor (bridge.nix mirrors it from usrset.editors, see bridge.nix)
      # =============[users]^^^

      # =============[base / core packages]
      # Always-on package groups. Default true keeps a useful baseline; disable
      # groups you don't need to shrink the system/download.
      base = {
        coreTools.enable = true; # neovim + nh + git
        netArchives.enable = true; # wget + curl + zip + rar + rsync
        fsTools.enable = true; # psmisc + pciutils + usbutils + ntfs3g
        imaging.enable = true; # image/video codec + thumbnail support
      };
      # =============[base / core packages]^^^

      # =============[experience install]
      # [pick one or more if you know what you're doing] [sizes approximate]
      cinnamon.enable = false; # ~800mib - full Cinnamon desktop
      gnome.enable = true; # ~800mib - full GNOME desktop
      gdm.enable = true; # sets GDM login manager
      hyprland.enable = false; # ~19mib - compositor only
      niri.enable = true; # ~20mib - compositor only
      mango.enable = false; # ~5mib sets mango (mangowm)
      cosmic = {
        enable = false; # COSMIC desktop environment
        greeter = false; # COSMIC login manager (disables GDM if enabled)
      };
      # =============[experience install]^^^

      # =============[hardware]
      nvidia = {
        enable = false; # NVIDIA GPU drivers and CUDA support
        open = false; # open-source NVIDIA kernel module (Turing/RTX 2000+ only)
      };
      # [kernel] pick one: "default", "latest", "cachyos-latest", "cachyos-bore", "cachyos-lts"
      kernel.variant = "default";

      # [TTY console font] bitmap fonts (set null for kernel default):
      #   "ter-116n"    - Terminus 16px (default-size, crisp)
      #   "ter-124n"    - Terminus 24px (medium, good for HiDPI)
      #   "ter-132n"    - Terminus 32px (large, very readable)
      #   "sun12x22"    - Sun Solaris style (classic server look)
      #   "latarcyrheb-sun32" - Large 32px with Cyrillic/Hebrew
      console = {
        font = "ter-132n";
      };
      # [fonts] system font set, declared in juajar/sysjar/fonts/
      fonts = {
        enable = true; # master toggle (default true)
        minimal = false; # true = terminal font + essentials only (drops JP/emoji packs)
      };
      boot.quiet = false;
      boot.fastMenu = false;
      # GRUB install target; only needed on hosts booting via GRUB,
      # leave null on systemd-boot hosts. e.g. "/dev/sda" or "/dev/disk/by-id/..."
      boot.grubDevice = null;
      plymouth.enable = false; # custom logo boot splash via plymouth

      neverSleep.enable = false; # disable system idle sleep
      bluetooth.enable = true; # ~10mib - sets blueman in home packages
      automount.enable = true; # auto-mount removable media (udisks2)
      # [power management]
      # NOTE: tlp and powerProfiles are mutually exclusive, pick one
      # tlp is better for battery capping (laptops), powerProfiles gives a tray selector
      tlp.enable = false;
      tlp.startChargeThreshold = 0; # 0 = always charge, 75 = resume charging at 75%
      tlp.stopChargeThreshold = 100; # 100 = no cap, 80 = stop charging at 80%
      tlp.cpuEppOnBattery = "balance_power"; # (default|performance|balance_performance|balance_power|power)
      tlp.platformProfileOnBattery = "balanced"; # (cool|quiet|balanced|performance)
      tlp.pcieAspmOnBattery = "default"; # (default|performance|powersave|powersupersave)
      powerProfiles.enable = true;
      audio = {
        enable = true; # ~100mib - PipeWire + audio tools
        addon.enable = false; # adds my audio setup
      };
      # =============[hardware]^^^

      # =============[software]
      # [nix] package policy + helper tools, declared in juajar/sysjar/nix/
      nix = {
        unfree.enable = true; # false = forbid unfree packages (spotify, chromium, vscodium, steam, ...)
        nh.enable = true; # nh (nix helper) + NH_OS_FLAKE; nh's own weekly clean runs unless storeClean is on
        nixLd.enable = true; # run unpatched binaries (editor plugins, downloaded tools)
        storeClean = {
          enable = false; # automatic Nix store GC (nix-collect-garbage timer)
          dates = "weekly"; # systemd calendar spec for cleanup runs
          options = "--delete-older-than 14d"; # gc flags
          persistent = true; # catch up a missed cleanup after downtime
        };
        nixpkgsYoinks.enable = false; # overlay package yoinks from nixpkgs
      };
      ai = {
        enable = false; # ~2gib - llama.cpp + models (auto-downloaded via models-preset)
        host = "0.0.0.0"; # bind address of the local backend; use "127.0.0.1" to keep it private
        llama = {
          enable = true; # local llama.cpp (set false to use opencode/non-local only)
          gpu = "rocm"; # llama.cpp backend: rocm (AMD) | cuda (NVIDIA) | cpu
        };
        ollama = {
          enable = false; # Ollama backend (multi-GPU)
          gpu = "rocm"; # Ollama backend: rocm (AMD) | cuda (NVIDIA) | vulkan | cpu
          modelSet = "medium"; # small | medium | large | custom (custom uses `models`)
          # NOTE: ai.ollama.activeModels is computed from modelSet (read-only)

          # Global context default. Long-context models should use a `models`
          # entry below instead of raising this for every model.
          contextLength = 8192;
          keepAlive = "5m"; # OLLAMA_KEEP_ALIVE; raise (e.g. "30m") for agent workflows
          # OLLAMA_MAX_LOADED_MODELS: 1 stops a second model evicting the main one.
          maxLoadedModels = 1;
          # OLLAMA_NUM_PARALLEL: each extra slot multiplies KV-cache VRAM.
          numParallel = 1;

          # Prefer UUIDs from `rocminfo`; empty = all detected GPUs.
          devices = ""; # e.g. "GPU-6a91c53ed47a63c3"
          # true once to prune models outside the active set; keep false when
          # using aliases, otherwise the prune deletes the generated aliases.
          syncModels = false;
          flashAttention = true; # required for a quantized KV cache
          # kvCache: f16 | q8_0 | q4_0; q4_0 shrinks KV ~4x and enables long
          # context on 16GB. Needs flashAttention = true.
          kvCache = "q4_0";

          # =============[per-model definitions]
          # nickname -> { source, num_ctx, display?, target? }.
          # The alias service creates `<nickname>:latest` with
          #   FROM <source>
          #   PARAMETER num_ctx <num_ctx>
          # so the SAME weights can be served at different context lengths.
          # opencode uses the nickname as the model id and display (unless
          # `display` overrides it). Nicknames must match
          # [a-z0-9][a-z0-9._-]* and must not collide with another nickname
          # or a source tag.
          #
          # With modelSet = "custom", the unique sources (split by target)
          # become the GPU/CPU pull lists. Duplicate sources are allowed: the
          # same weights at two num_ctx values, or once gpu and once cpu.
          #
          # Example (left disabled on purpose): a small model on the CPU
          # sidecar. CPU models skip the VRAM check; GPU footprints are
          # optional (see below).
          #   gem4e2b = {
          #     source = "hf.co/unsloth/gemma-4-E2B-it-GGUF:Q4_K_M";
          #     num_ctx = 32768;      # generous context; CPU has RAM to spare
          #     target = "cpu";       # create it on the sidecar, not the GPU
          #     # display = "gem4e2b"; # optional; defaults to the nickname
          #   };
          models = { };

          # Nickname (preferred) or source tag for opencode's small_model and
          # the lightweight explore subagent. A source tag resolves to its
          # nickname automatically.
          smallModel = null;
          # Primary chat model nickname/source (used by the Hermes seed).
          mainModel = null;
          # Eval-time guard: weights + KV at num_ctx must stay under this MB.
          # Keep below the card total to leave room for the compositor and
          # compute buffers (16GB card: ~15000 is realistic).
          vramBudgetMB = 15000;
          # Optional per-GPU-model footprint. When both weightsMB and
          # kvMBPer1k are set, the eval check verifies
          #   weights + KV(num_ctx) <= vramBudgetMB
          # for that model. Omit them and Ollama offloads at runtime instead.
          # weightsMB = GGUF size; kvFixedMB = sliding-window term (0 for
          # dense); kvMBPer1k = full-attention growth per 1000 tokens.
          #   gem4-26b = {
          #     source = "<source tag>";
          #     num_ctx = 131072;
          #     weightsMB = 0;
          #     kvFixedMB = 0;
          #     kvMBPer1k = 0.0;
          #   };

          # =============[CPU sidecar]
          # A second, CPU-only Ollama instance for small models so they do not
          # compete with the main model for VRAM. It uses its own model store:
          # the server writes locks/temp files during load, so sharing the GPU
          # store is unsafe. The gem4e2b example above targets this instance.
          cpu = {
            enable = false;
            port = 11435; # GPU instance stays on ai.port
            modelsDir = "/var/lib/ollama-cpu/models";
            keepAlive = "1h"; # RAM is cheap; keep small models hot
            contextLength = 32768;
          };
        };
        port = 11434;
        webui = {
          enable = false; # Open WebUI chat interface (~2gib)
          port = 8080;
        };
      };
      localsend.enable = true; # ~30mib - local file sharing
      espanso.enable = false; # ~30mib - espanso daemon + Wayland security wrapper
      flatpak.enable = false; # ~10mib - flatpak support [still needs to be enabled in user.nix]
      gaming = {
        drivers = {
          enable = true; # ~1.5gib - Vulkan + Mesa
          amd.enable = false; # AMD specific drivers
          intel.enable = false; # Intel specific drivers
          nvidia.enable = false; # NVIDIA drivers (Vulkan + 32-bit)
        }; # end of drivers
        codecs.enable = true; # ~codecs - GStreamer + VA-API/Vulkan debug tools
        steam.enable = false; # ~2gib - Steam client + 32-bit libs
      }; # end of gaming
      virtCam.enable = false; # ~5mib - virtual camera for OBS
      virt = {
        role = "none"; # "none" | "host" (libvirtd/QEMU) | "guest" (tuned as a VM)
        gui = false; # host only: virt-manager + gnome-boxes
      }; # end of virt
      portal.enable = false; # XDG portal file pickers
      polkit.enable = false; # polkit authentication agent (gnome polkit)
      # [security] daemons, declared in juajar/sysjar/security/ (both default true)
      security = {
        polkit.enable = true; # run the polkit daemon (many services and desktop apps need it)
        rtkit.enable = true; # realtime CPU priority for audio and games
      };
      systemScripts.enable = true; # jar system helper scripts (nru, updatejar)
      # =============[software]^^^

      # =============[networking]
      networking = {
        networkManager.enable = true; # NetworkManager + adds users to the networkmanager group
        ssh.enable = true; # run the OpenSSH daemon
        avahi.enable = true; # mDNS (host.local names, publishing; opens UDP 5353)
        bbr.enable = true; # TCP BBR congestion control + cake qdisc
        nameservers = [
          "8.8.8.8" # google
          "1.1.1.1" # cloudflare
        ]; # set [ ] to use whatever DHCP hands out
        fleet = {
          enable = true; # pin the fleet: /etc/hosts + known_hosts + per-host ssh blocks from hstjar/*/net.nix
          defaultUser = "jar"; # ssh login user for fleet hosts whose net.nix has no `user`
        };
        mullvad.enable = false; # mullvad vpn
      };
      # =============[networking]^^^

      # [bridged toggles] computed from user.nix (bridge.nix) - do NOT set here:
      #   syncthing.enable  <- usrset.syncthing.enable (runs as mainUser)
      #   nvf.enable        <- usrset.editors.nvf.enable
      #   theming.{enable,accent,variant,gtkThemeName,iconThemeName} <- usrset.theming
      # =============[Server]
      server = {
        komga.enable = false; # manga/comic server (port 25600)
        jellyfin = {
          enable = false; # sets jellyfin server.  note: the default port is 8096.
          juser = "PLEASECHANGEME_USERNAME"; # sets jellyfin user for perms for file access
        }; # end of jellyfin
        sleepyjar = {
          enable = false; # sets sleepy service
          interval = "weekly"; # sets interval for sleepy service
          # some* options for sleepy service:
          # daily: reboots every midnight
          # weekly: reboots every Sunday at midnight
          # "Fri 03:00:00": reboots every Friday at 3am
          # "*-*-1,15 02:00:00": reboots on the 1st and 15th of every month at 2am
        }; # end of sleepyjar
        nixdraw = {
          enable = false; # sets up a self-hosted excalidraw Server.
          port = 3000; # sets the port for the excalidraw server
          # =-=-=-=Usage:
          # LOCAL: http://localhost:3000
          # REMOTE: http://PH_Hostname:3000 or http://PH_IP_address:3000
        }; # end of nixdraw
        webjar = {
          enable = true; # ~5mib - self-hosted link page (nginx)
          port = 80;
        }; # end of webjar
        cockpit = {
          enable = false; # Cockpit web management UI (listens on port, default 9090)
          port = 9090;
          openFirewall = false; # open the port for non-localhost access
          allowUnencrypted = false; # on a trusted LAN: allow http (warn logging)
          machines.enable = false; # cockpit-machines (manage KVM/QEMU VMs via libvirt)
          podman.enable = false; # cockpit-podman (manage containers)
          files.enable = false; # cockpit-files (file browser)
          extraOrigins = [ ]; # extra CSP origins to allow, e.g. [ "https://docs.example.com" ]
          extraPlugins = [ ]; # extra cockpit plugin package paths
        }; # end of cockpit
        outline = {
          enable = false; # sets outline wiki server (local postgres+redis)
          port = 3000; # note: use 3001+ if nixdraw is on (it owns 3000)
          publicUrl = "http://localhost:3000"; # URL users browse from (SSO redirects must match)
          # extraConfig goes straight to services.outline; needs https? set
          # sslCertFile/sslKeyFile + forceHttps, and SSO extras live under
          # extraConfig.oidcAuthentication:
          # extraConfig.oidcAuthentication = {
          #   clientId = "outline"; clientSecretFile = "/path/to/secret";
          #   authUrl = "..."; tokenUrl = "..."; userinfoUrl = "...";
          #   displayName = "authentik";
          # };
          # extraConfig.forceHttps = true;
          # extraConfig.sslCertFile = "/path/to/cert.pem";
          # extraConfig.sslKeyFile = "/path/to/key.pem";
        }; # end of outline
        authentik = {
          enable = false; # sets authentik SSO IdP (login provider for outline)
          port = 9000; # web UI/API port
          adminEmail = "akadmin@PLEASECHANGEME_HOSTNAME.local"; # default: akadmin@<hostname>.local
          environmentFile = "/var/lib/authentik/env"; # file with secret key etc.
          # extraConfig goes straight to services.authentik.environmentVariables
          # extraConfig = { };
        }; # end of authentik
        # --------------------[MySQL / MariaDB  (module: juajar/sysjar/server/mysql.nix)]
        # A local relational database. Safe default: localhost-only
        # (bindAddress 127.0.0.1 + openFirewall false), so it can be enabled on
        # any host without exposing it to the LAN.
        #
        #   flavor        "mariadb" (default) or "mysql" (Oracle MySQL 8.x)
        #   port          3306 by default
        #   bindAddress   "127.0.0.1" = localhost only. Use "0.0.0.0" ONLY with
        #                 openFirewall = true and a passworded TCP user.
        #   openFirewall  false (open the port for non-localhost access)
        #   dataDir       /var/lib/mysql
        #   databases     list of database names to CREATE if missing
        #   users         local users using unix-SOCKET auth (NO password). They
        #                 only work for a process running as that unix user on
        #                 THIS host. For TCP/password logins create the user
        #                 yourself once (docs) or via `initialScript`.
        #   settings      extra my.cnf options, merged under settings.mysqld
        #   initialScript SQL file run once on first start (e.g. a passworded user)
        #   workbench     install the mysql-workbench GUI client (desktop hosts)
        #   backup        nightly mysqldump of backup.databases -> backup.location
        #                 on the backup.calendar schedule
        # Docs / usage: see the host notes and `resjar/docbin/` server docs.
        mysql = {
          enable = false; # flip to true to run a local DB on this host
          flavor = "mariadb"; # "mariadb" (default) | "mysql" (Oracle MySQL 8.x)
          # port = 3306;
          # bindAddress = "127.0.0.1"; # keep localhost unless you must expose it
          # openFirewall = false;
          # dataDir = "/var/lib/mysql";
          # databases = [ "mydb" ];
          # users = [
          #   {
          #     name = "PLEASECHANGEME_USERNAME"; # unix-socket auth, no password
          #     ensurePermissions = { "mydb.*" = "ALL PRIVILEGES"; };
          #   }
          # ];
          # settings = { }; # extra my.cnf, e.g. { max_connections = 200; }
          # initialScript = null; # path to a .sql run once on first start
          # workbench = false; # GUI client (desktop hosts only)
          # backup = {
          #   enable = false;
          #   databases = [ "mydb" ]; # empty = nothing dumped
          #   location = "/var/backup/mysql";
          #   calendar = "01:15:00"; # systemd OnCalendar
          # };
        }; # end of mysql
      }; # end of server
      # =============[Server]^^^
    }; # end of sysset

    # [jellyfin hardware acceleration] optional; needs a GPU + matching drivers
    # find the render node: ls -l /dev/dri/by-path/
    # services.jellyfin.hardwareAcceleration = {
    #   enable = true;
    #   type = "vaapi";              # nvenc (NVIDIA) | vaapi (AMD/Intel) | amf (AMD)
    #   device = "/dev/dri/renderD128";
    # };
  }; # end of config
}
