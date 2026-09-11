# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: zsh shell + aliases + plugins.
# -=-=-=-=-=-=-=-=-=-=-=
# Aliases + shell functions are single-sourced in juajar/liijar/shell/
# and shared with the hjem backend (liijar/zsh/hjem.nix).
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  hostnm,
  osConfig,
  ...
}:
let
  cfg = config.usrset.shell;
  # Whether this host allows unfree packages (drives the modern `,` temp-install).
  uf = osConfig.sysset.unfree.enable or false;
  aliases = import ../shell/aliases.nix { inherit hostnm; };
  functions = import ../shell/functions.nix {
    inherit lib hostnm;
    inherit uf;
  };
in
{
  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true; # enable zsh shell
      # [addings]
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      # [functions + prompt]
      # Shared function block comes from liijar/shell/functions.nix.
      initContent = ''
        ${functions}

        # [prompt]
        PROMPT='%F{#5F7CB8}%n|%f'
        RPROMPT='%F{#5F7CB8}%~ %F{#5F7CB8}%m%f %F{cyan}%*%f'
      '';

      # [aliases]
      # Single-sourced in liijar/shell/aliases.nix (shared with hjem hosts).
      shellAliases = aliases;
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
