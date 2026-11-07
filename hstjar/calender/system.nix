# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host calender: system-level toggle sheet (sysset).
# -=-=-=-=-=-=-=-=-=-=-=
{...}: {
  config = {
    system.stateVersion = "26.05"; # [first-install marker: do NOT bump]
    #            [system state version from first install]

    # Fill this out!
    sysset = {
      # =============[users]
      mainUser = "jar";
      users = ["jar"];
      adminUsers = ["jar"];
      userDescriptions = {
        jar = "jar";
      };
      # =============[users]^^^

      # =============[base / core packages]
      base = {
        coreTools.enable = true;
        netArchives.enable = true;
        fsTools.enable = true;
        imaging.enable = false;
      };
      # =============[base / core packages]^^^

      # =============[experience install]
      # [pick one or more if you know what you're doing]
      cinnamon.enable = false; # sets cinnamon
      gnome.enable = false; # sets gnome [on by default]
      gdm.enable = true; # sets GDM login manager
      lidm.enable = false; # lidm TUI display manager: parked, auth works but session launch fails (bare `Exec=mango` + no PAM env in child)
      hyprland.enable = false; # sets hyprland
      niri.enable = false; # sets niri
      mango.enable = true; # sets mango (mangowm)
      cosmic = {
        enable = false; # sets cosmic desktop environment
        greeter = false; # sets cosmic login manager (disables GDM if enabled)
      };
      # =============[experience install]^^^

      # =============[hardware]
      nvidia = {
        enable = false; # NVIDIA GPU drivers and CUDA support
        open = false; # open-source NVIDIA kernel module (Turing/RTX 2000+ only)
      };
      # [kernel] pick one: "default", "latest", "cachyos-latest", "cachyos-bore", "cachyos-lts"
      kernel.variant = "cachyos-latest";

      # [TTY console font] bitmap fonts (set null for kernel default):
      #   "ter-116n"    - Terminus 16px (default-size, crisp)
      #   "ter-124n"    - Terminus 24px (medium, good for HiDPI)
      #   "ter-132n"    - Terminus 32px (large, very readable)
      #   "sun12x22"    - Sun Solaris style (classic server look)
      #   "latarcyrheb-sun32" - Large 32px with Cyrillic/Hebrew
      console = {
        font = "ter-132n";
      };
      boot.quiet = false; # silence kernel/udev/systemd startup logs
      boot.fastMenu = false; # set boot loader timeout to 1 second
      plymouth.enable = false; # custom boot splash logo

      bluetooth.enable = false; # sets blueman in home packages
      neverSleep.enable = false; # disable system idle sleep
      automount.enable = true; # auto-mount removable media (udisks2)
      # [power management]
      tlp.enable = false; # NOTE: mutually exclusive with powerProfiles, pick one
      tlp.startChargeThreshold = 0;
      tlp.stopChargeThreshold = 100;
      tlp.cpuEppOnBattery = "balance_power"; # (default|performance|balance_performance|balance_power|power)
      tlp.platformProfileOnBattery = "balanced"; # (cool|quiet|balanced|performance)
      tlp.pcieAspmOnBattery = "default"; # (default|performance|powersave|powersupersave)
      powerProfiles.enable = true;
      audio = {
        enable = true; # sets audio and adds some apps
        addon.enable = true; # adds my audio setup
      };
      # =============[hardware]^^^

      # =============[software]
      nix.unfree.enable = true; # allow unfree packages (spotify, chromium, vscodium, steam, ...)
      nix.nixpkgsYoinks.enable = true;
      ai = {
        enable = true; # sets AI tools (opencode, llama.cpp, ollama)
        llama = {
          enable = false; # local llama.cpp (kept available but disabled on this host)
          gpu = "rocm"; # llama.cpp backend: rocm (AMD) | cuda (NVIDIA) | cpu
        };
        ollama = {
          enable = false; # Ollama backend (multi-GPU)
          gpu = "rocm"; # Ollama backend: rocm (AMD) | cuda (NVIDIA) | vulkan | cpu
          modelSet = "custom"; # small | medium | large | custom
          # Global default only; each models entry bakes its own num_ctx
          # into a `FROM <source> + PARAMETER num_ctx` wrapper.  32768 is the
          # safe default for models without an alias.
          contextLength = 32768;
          keepAlive = "30m"; # keep the main model resident between agent turns
          maxLoadedModels = 1; # never let a second model evict the main one
          numParallel = 1; # each extra slot doubles KV-cache VRAM
          flashAttention = true; # required for quantized KV cache
          kvCache = "q4_0"; # ~4x smaller KV cache; q8_0@64k is an A/B candidate
          # Prefer UUIDs from `rocminfo`; currently only the 9070 XT is installed.
          # Append the 9060 XT UUID here after it is moved into this machine.
          devices = "GPU-6a91c53ed47a63c3"; # exclude Granite Ridge iGPU
          syncModels = false; # one-time prune already done; aliases must survive
          autoPrune = false; # remove sources/aliases not declared in `models`

          # Per-model context wrappers.  The nickname is the Ollama tag and the
          # opencode model id (`<nickname>:latest`); display defaults to it.
          models = {
            gem4-26b = {
              source = "hf.co/unsloth/gemma-4-26B-A4B-it-GGUF:UD-IQ4_XS";
              num_ctx = 131072; # 13.6GB + ~0.8GB KV @128k: main model
              weightsMB = 13600;
              kvFixedMB = 56;
              kvMBPer1k = 5.76;
            };
            qwen3-27b = {
              source = "hf.co/byteshape/Qwen3.8-27B-GGUF:IQ3_S";
              num_ctx = 128000;
              weightsMB = 9000;
              kvFixedMB = 0;
              kvMBPer1k = 46.08; # 9000MB weights + (131 * 46.08)MB KV ≈ 15036MB total VRAM... UHG
            };
            qwen35-9b = {
              source = "qwen3.5:9b";
              num_ctx = 32768;
              weightsMB = 6600;
              kvFixedMB = 0;
              kvMBPer1k = 36.86;
            };
            gem4e2b = {
              source = "hf.co/unsloth/gemma-4-E2B-it-GGUF:Q4_K_M";
              num_ctx = 32768;
              target = "cpu"; # sidecar; keeps the 26B resident on the GPU
            };
          };
          mainModel = "gem4-26b";
          smallModel = "gem4e2b"; # opencode small_model + explore subagent

          vramBudgetMB = 15000; # 16GB card minus compositor/compute headroom

          # CPU sidecar for the small model (separate store, separate port).
          cpu = {
            enable = true;
          };
        };

        host = "127.0.0.1"; # keep local backend private to this machine
        port = 11434;
        webui = {
          enable = false; # Open WebUI chat interface
          port = 8080;
        };
      };
      localsend.enable = true;
      # syncthing: toggled in user.nix (usrset.syncthing), bridged here by hjemkey
      espanso.enable = true; # espanso daemon + Wayland security wrapper
      flatpak.enable = false; # sets flatpak in the system [still needs to be enabled in user.nix]
      gaming = {
        drivers = {
          enable = true; # sets gaming drivers
          amd.enable = true; # sets amd drivers
          intel.enable = false; # sets intel drivers
          nvidia.enable = false; # sets nvidia drivers [NOT IMPLEMENTED]
        }; # end of drivers
        steam.enable = true; # sets steam and associated libraries for gaming, but not more important drivers
      }; # end of gaming
      virtCam.enable = true; # sets virtual camera for things like OBS
      virt = {
        role = "host"; # libvirtd/QEMU on this host
        gui = true; # virt-manager + gnome-boxes
      }; # end of virt
      portal.enable = true; # XDG portal file pickers
      polkit.enable = true; # polkit authentication agent (gnome polkit)
      networking.mullvad.enable = true; # mullvad vpn ~43Mib
      # =============[software]^^^

      # =============[Server]
      server = {
        komga.enable = false; # manga/comic server (port 25600)
        jellyfin = {
          enable = false; # sets jellyfin server
          juser = "jar"; # sets jellyfin user for perms for file access
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
          enable = true; # self-hosted link page (nginx)
          port = 80;
        };
        outline = {
          enable = false; # sets outline wiki server (local postgres+redis)
          port = 3000; # note: use 3001+ if nixdraw is on (it owns 3000)
        }; # end of outline
        authentik = {
          enable = false; # sets authentik SSO IdP (login provider for outline)
          port = 9000; # web UI/API port
        }; # end of authentik
        mysql = {
          enable = true;
          flavor = "mysql"; # Oracle MySQL 8.x (pkgs.mysql84); switch to "mariadb" anytime
          databases = ["bank"]; # CIT 244 banking project
          users = [
            {
              name = "jar"; # unix-socket auth (no password) for the local Python app
              ensurePermissions = {
                "bank.*" = "ALL PRIVILEGES";
              };
            }
          ];
          workbench = true; # mysql-workbench GUI (docs/screenshots)
          backup = {
            enable = true;
            databases = ["bank"];
          }; # end of backup
        }; # end of mysql
      }; # end of server
      # =============[Server]^^^
    }; # end of sysset
  }; # end of config
}
