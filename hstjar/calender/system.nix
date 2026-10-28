# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host calender: system-level toggle sheet (sysset).
# -=-=-=-=-=-=-=-=-=-=-=
{ ... }:

{
  config = {
    system.stateVersion = "26.05"; # [first-install marker: do NOT bump]
    #            [system state version from first install]

    # Fill this out!
    sysset = {
      # =============[users]
      mainUser = "jar";
      users = [ "jar" ];
      adminUsers = [ "jar" ];
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
          enable = true; # Ollama backend (multi-GPU)
          gpu = "rocm"; # Ollama backend: rocm (AMD) | cuda (NVIDIA) | vulkan | cpu
          modelSet = "custom"; # small | medium | large | custom
          customModels = [
            # "qwen3.6:35b-a3b" # MoE 35B / 3B active: agentic coding, vision + thinking (hybrid GPU/CPU by design)
            "qwen3.5:9b" # dense 9B: fits fully in VRAM incl. KV cache, fast light tier(my current fav)
            "hf.co/unsloth/Qwen3-14B-GGUF:Q4_K_M"
            "hf.co/JonathanColetti/Qwen3.8-27B-Uncensored-GGUF:IQ2_M"
            "hf.co/unsloth/gemma-4-26B-A4B-it-GGUF:UD-Q3_K_M"
            # these models dont seem to work for tool calling./
            # "hf.co/bartowski/Qwen2.5-Coder-14B-Instruct-GGUF:Q4_K_M"
            # "qwen2.5-coder:14b"
          ];
          contextLength = 128000; # KV cache spills to RAM; avoids constant compaction
          keepAlive = "1m"; # keep models resident between calls (agent workflows)
          flashAttention = true; # required for quantized KV cache
          kvCache = "q4_0"; # shrink KV cache ~4x (8GB -> 2GB at 32k on 27B)
          # Prefer UUIDs from `rocminfo`; currently only the 9070 XT is installed.
          # Append the 9060 XT UUID here after it is moved into this machine.
          devices = "GPU-6a91c53ed47a63c3"; # exclude Granite Ridge iGPU
          syncModels = true; # set true once to prune models outside the active set
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
      # =============[software]^^^

      networking.mullvad.enable = true; # mullvad vpn ~43Mib

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
          databases = [ "bank" ]; # CIT 244 banking project
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
            databases = [ "bank" ];
          }; # end of backup
        }; # end of mysql
      }; # end of server
      # =============[Server]^^^
    }; # end of sysset
  }; # end of config
}
