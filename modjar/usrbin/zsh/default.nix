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
    };
  };

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
        PROMPT='%F{#5F7CB8}%n|%f'
        RPROMPT='%F{#5F7CB8}%~ %F{#5F7CB8}%m%f %F{cyan}%*%f'
      '';

      # [aliases]
      shellAliases = {
        # ========[syst]
        nht = "nh os test ~/nix-config#${hostnm}"; # base test
        nhs = "nh os switch ~/nix-config#${hostnm}"; # base switch
        nhc = "nh clean all --keep 7"; # base cleanup
        nrs = "nixos-rebuild switch --sudo --flake ~/nix-config#${hostnm}"; # hard building
        nrt = "nixos-rebuild test --sudo --flake ~/nix-config#${hostnm}"; # testing
        # ========[syst]

        # ========[app aliases]
        nv = "nvim";
        zd = "zeditor";
        code = "codium";
        yy = "yazi";
        brw = "browsh"; # TUI based browser
        oc = "opencode"; # Ai thing
        # ========[app aliases]

        # ========[util]
        #[jar]
        jars = "git pull --rebase origin main";
        jnconf = "cd ~/nix-config"; # nix config jar [move over into nix config]
        jkconf = "cd ~/kilnjar"; # kiln jar [my dev / project folder]
        jkrconf = "cd ~/kilnjar/reposjar"; # kiln jar [my dev / project folder]
        # hyprland
        hle = "hyprctl configerrors";
        hlr = "hyprland reload";
        #
        ckhrd = "lsblk && fdisk -l";
        # ls = "ls";
        grep = "grep --color=auto";
        cl = "clear";
        ga = "git add .";
        gc = "git clone";
        fcir = "fcitx5-remote -r"; # force reload fcitx5
        rz = "exec zsh"; # reload zsh
        ns = "nix-shell"; # load dev enviroment
        nsp = "nix-shell -p";
        # ai... ew
        ols = "ollama list";
        olrs = "sudo systemctl restart ollama-model-loader.service";
        olpm = "pull-models";
        olrm = "remove-models";
        # ========[util]

        # =========[Extra]
        mcube = "mangohud vkcube --present_mode 1"; # needs mangohud+vulkan-tools
        cs = "cowsay";
        csj = "cowsay IM JAR";
        ff = "fastfetch";
        # =========[Extra]
      }; # end of aliases
      }; # end of zsh config

      # [fzf]
      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
        defaultCommand = "fd --type f --hidden --follow --exclude .git";
        fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
        changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
        historyWidgetOptions = [ "--preview" "echo {} | bat --color=always -l= -" ];
        colors = {
          "bg"      = "#2b2622";
          "bg+"     = "#45403d";
          "fg"      = "#e6dfd3";
          "fg+"     = "#ebdbb2";
          "hl"      = "#d79921";
          "hl+"     = "#d79921";
          "info"    = "#d79921";
          "border"  = "#d79921";
          "prompt"  = "#d79921";
          "pointer" = "#e6dfd3";
          "marker"  = "#e6dfd3";
          "spinner" = "#d79921";
        }; # end of colors
      }; # end of fzf
  }; # end of shell config
}
