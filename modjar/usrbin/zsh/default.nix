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
        "," = "nix-shell -p";
        ols = "ollama list";
        olrs = "sudo systemctl restart ollama-model-loader.service";
        # ========[util]

        # =========[Extra]
        cs = "cowsay";
        csj = "cowsay IM JAR";
        ff = "fastfetch";
        # =========[Extra]
      }; # end of aliases
    }; # end of zsh config
  }; # end of shell config
}
