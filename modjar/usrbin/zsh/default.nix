{
  config,
  lib,
  hostnm,
  ...
}:
let
  cfg = config.usrSettings.shell;
in
{
  # declare options for the zsh shell [good to keep this on]
  options = {
    usrSettings.shell.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable zsh shell";
    }; # end of enable option
  }; # end of options

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true; # enable zsh shell
      # [addings]
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      # [prompt]
      # guide: https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
      initContent = ''
        # quick nix-shell: , git curl  or  , git curl -- ls
        ,() {
          local pkgs cmd
          if [[ " $* " == *" -- "* ]]; then
            pkgs="''${1%% -- *}"
            cmd="''${1#* -- }"
            nix-shell -p $pkgs --run "$cmd"
          else
            nix-shell -p "$@"
          fi
        }

        # [nh shortcuts with host args for if i want to mannually switch]
        nhtm() {
          local target="''${1:-${hostnm}}"
          nh os test --accept-flake-config ~/nix-config#"$target"
        }
        nhsm() {
          local target="''${1:-${hostnm}}"
          nh os switch --accept-flake-config ~/nix-config#"$target"
        }
        nrtm() {
          local target="''${1:-${hostnm}}"
          nixos-rebuild test --sudo --flake ~/nix-config#"$target"
        }
        nrsm() {
          local target="''${1:-${hostnm}}"
          nixos-rebuild switch --sudo --flake ~/nix-config#"$target"
        }

        # [prompt]
        PROMPT='%F{#5F7CB8}%n|%f'
        RPROMPT='%F{#5F7CB8}%~ %F{#5F7CB8}%m%f %F{cyan}%*%f'
      '';

      # [aliases]
      shellAliases = {
        # ========[sys nix]
        nht = "nh os test --accept-flake-config ~/nix-config#${hostnm}"; # base test
        nhs = "nh os switch --accept-flake-config ~/nix-config#${hostnm}"; # base switch
        nhc = "nh clean all --keep 7"; # base cleanup
        nsr = "sudo nix-store --verify --check-contents --repair";
        nrs = "nixos-rebuild switch --sudo --flake ~/nix-config#${hostnm}"; # hard building
        nrt = "nixos-rebuild test --sudo --flake ~/nix-config#${hostnm}"; # testing
        buildiso = "sh ~/nix-config/resjar/nixbin/buildiso.sh"; # build recovery ISO
        ns = "nix-shell"; # load dev enviroment
        nsp = "nix search nixpkgs";
        # ========[app aliases]
        nv = "nvim";
        zd = "zeditor";
        code = "codium";
        brw = "browsh"; # TUI based browser
        oc = "opencode"; # Ai thing
        b = "browsh"; # browser
        # ========[util]
        #[jar]
        jars = "git pull --rebase origin main";
        jnconf = "cd ~/nix-config"; # nix config jar [move over into nix config]
        neconf = "cd /etc/nixos"; # nix config (system-installed mirror)
        jkconf = "cd ~/kilnjar"; # kiln jar [my dev / project folder]
        jkrconf = "cd ~/kilnjar/reposjar"; # kiln jar [my dev / project folder]
        # [hyprland]
        hle = "hyprctl configerrors";
        hlr = "hyprland reload";
        # [Tools]
        clfont = "fc-cache -f -v"; # clear font cache
        rfc5 = "fcitx5 -r -d"; # restart fcitx5
        frfc5 = "fcitx5-remote -r"; # force reload fcitx5
        rz = "exec zsh"; # reload zsh
        ckhrd = "lsblk && fdisk -l";
        # ls = "ls";
        grep = "grep --color=auto";
        cl = "clear";
        ga = "git add .";
        gc = "git clone";
        rniri = "niri msg action reload-config";
        dl = "ytdl"; # youtube downloader
        shlvl = "echo $SHLVL";
        # [AI]
        rllms = "sudo systemctl restart llama-cpp";
        sllms = "sudo systemctl restart llama-cpp";
        stllms = "sudo systemctl start llama-cpp";
        # ========[util]

        # =========[Extra]
        mcube = "mangohud vkcube --present_mode 1"; # needs mangohud+vulkan-tools
        cs = "cowsay";
        csj = "cowsay IM JAR";
        ff = "fastfetch";
      }; # end of aliases
    }; # end of zsh config

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    # [fzf]
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f --hidden --follow --exclude .git";
      fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
      changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
      historyWidgetOptions = [
        "--preview"
        "echo {} | bat --color=always -l= -"
      ];
      colors = {
        "bg" = "#2b2622";
        "bg+" = "#45403d";
        "fg" = "#e6dfd3";
        "fg+" = "#ebdbb2";
        "hl" = "#d79921";
        "hl+" = "#d79921";
        "info" = "#d79921";
        "border" = "#d79921";
        "prompt" = "#d79921";
        "pointer" = "#e6dfd3";
        "marker" = "#e6dfd3";
        "spinner" = "#d79921";
      }; # end of colors
    }; # end of fzf
  }; # end of shell config
}
