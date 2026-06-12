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
  # declare option
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
        RPROMPT='%F{#5F7CB8}%m%f %F{cyan}%*%f'
      '';

      # [aliases]
      shellAliases = {
        # ========[syst]
        nht = "nh os test ~/nix-config#${hostnm}"; # base test
        nhs = "nh os switch ~/nix-config#${hostnm}"; # base switch
        nhc = "nh clean all --keep 7"; # base cleanup
        nrs = "nixos-rebuild switch --sudo --flake ~/nix-jar#${hostnm}"; # hard building
        nrt = "nixos-rebuild test --sudo --flake ~/nix-jar#${hostnm}"; # testing
        # ========[syst]

        # ========[util]
        conf = "cd ~/nix-config && nvim";
        ls = "ls --color=auto";
        grep = "grep --color=auto";
        nv = "nvim";
        cl = "clear";
        ga = "git add .";
        # ========[util]

        # =========[Extra]
        ff = "fastfetch";
        # =========[Extra]
      }; # end of aliases
    }; # end of zsh config
  }; # end of shell config
}
