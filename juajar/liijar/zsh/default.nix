# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: zsh: zshenv + zshrc + fzfrc generation.
# -=-=-=-=-=-=-=-=-=-=-=
# Aliases + shell functions are single-sourced in juajar/liijar/shell/.
{
  config,
  lib,
  pkgs,
  hostnm,
  osConfig,
  ...
}:
let
  hjm = config.usrset;

  zshSyntax = pkgs.zsh-syntax-highlighting;
  zshAutosuggestions = pkgs.zsh-autosuggestions;

  # Whether this host allows unfree packages (drives the modern `,` temp-install).
  uf = osConfig.sysset.unfree.enable or false;

  aliases = import ../shell/aliases.nix { inherit hostnm; };
  functions = import ../shell/functions.nix {
    inherit lib hostnm;
    inherit uf;
  };

  # attrset of aliases -> `alias k=v` lines. Bodies are single-quoted
  # (with ' escaped as '\'') so $/$(...) stay literal until invocation;
  # double quotes made wdry run `nix build` at every shell startup and
  # froze shlvl's $SHLVL at definition time.
  sq = lib.replaceStrings [ "'" ] [ "'\\''" ];
  aliasLines = lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "alias ${k}='${sq v}'") aliases);

  # yazi cd-on-quit wrapper (ported from the old programs.yazi zsh
  # integration): launch with `y`, quit with q -> shell cds into the dir
  # yazi was in. Gated on the yazi toggle so hosts without yazi skip it.
  yaziWrapper = lib.optionalString hjm.yazi.enable ''
    # yazi cd-on-quit wrapper
    function y() {
      local tmp="$(mktemp -t "yazi-cwdXXXXXX")" cwd
      yazi "$@" --cwd-file="$tmp"
      if cwd="$(command cat -- "$tmp")"; then
        builtin cd -- "$cwd"
      fi
      rm -f -- "$tmp"
    }
  '';

  # session vars (hjem loadEnv) for every zsh invocation: foot opens
  # non-login shells so .zprofile never runs. The once-guard keeps
  # nested shells from re-sourcing the env script.
  zshenv = pkgs.writeText "zshenv" ''
    if [[ -z "''${__HJEM_SESS_VARS_SOURCED-}" ]]; then
      export __HJEM_SESS_VARS_SOURCED=1
      . ${config.environment.loadEnv}
    fi
  '';

  zshrc = pkgs.writeText "zshrc" ''
    # completions
    autoload -Uz compinit
    compinit

    # autosuggestions
    source ${zshAutosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

    # fzf (env vars single-sourced with ~/.fzfrc)
    source ${fzfrc}
    # fzf keybindings: alt-c dirs, ctrl-t files, ctrl-r history
    source ${pkgs.fzf}/share/fzf/key-bindings.zsh
    # fzf tab-completion (compinit ran above)
    source ${pkgs.fzf}/share/fzf/completion.zsh

    # user-local binaries (webapp launchers, user scripts)
    export PATH="$HOME/.local/bin:$PATH"

    # zoxide (smart cd)
    eval "$(zoxide init zsh)"

    # prompt
    PROMPT='%F{#5F7CB8}%n|%f'
    RPROMPT='%F{#5F7CB8}%~ %F{#5F7CB8}%m%f %F{cyan}%*%f'

    # functions (single-sourced in liijar/shell)
    ${functions}

    # aliases (single-sourced in liijar/shell)
    ${aliasLines}

    ${yaziWrapper}

    # syntax highlighting (must stay last so it wraps every widget defined
    # above, incl. the fzf alt-c/ctrl-t/ctrl-r widgets and zoxide's z)
    source ${zshSyntax}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  '';

  fzfrc = pkgs.writeText "fzfrc" ''
    export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
    export FZF_DEFAULT_OPTS="--color=bg:#2b2622,bg+:#45403d,fg:#e6dfd3,fg+:#ebdbb2 --color=hl:#d79921,hl+:#d79921,info:#d79921,border:#d79921 --color=prompt:#d79921,pointer:#e6dfd3,marker:#e6dfd3,spinner:#d79921 --preview-window=right:50% --bind ctrl-/:toggle-preview"
    export FZF_CTRL_T_OPTS="--preview 'echo {} | bat --color=always -l= -'"
    export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -20'"
  '';
in
{
  config = lib.mkIf hjm.shell.enable {
    files = {
      ".zshenv".source = zshenv;
      ".zshrc".source = zshrc;
      ".fzfrc".source = fzfrc;
    };
  };
}
