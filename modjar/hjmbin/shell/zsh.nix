{
  config,
  lib,
  pkgs,
  hostnm,
  ...
}:
let
  hjm = config.hjmSettings;

  zshSyntax = pkgs.zsh-syntax-highlighting;
  zshAutosuggestions = pkgs.zsh-autosuggestions;

  zshrc = pkgs.writeText "zshrc" ''
    # completions
    autoload -Uz compinit
    compinit

    # autosuggestions
    source ${zshAutosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

    # syntax highlighting
    source ${zshSyntax}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    # zoxide (smart cd)
    eval "$(zoxide init zsh)"

    # prompt
    PROMPT='%F{#5F7CB8}%n|%f'
    RPROMPT='%F{#5F7CB8}%~ %F{#5F7CB8}%m%f %F{cyan}%*%f'

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

    # aliases
    # ==[syst]
    alias nht="nh os test --accept-flake-config ~/nix-config#${hostnm}"
    alias nhs="nh os switch --accept-flake-config ~/nix-config#${hostnm}"
    alias nhc="nh clean all --keep 7"
    alias nrs="nixos-rebuild switch --sudo --flake ~/nix-config#${hostnm}"
    alias nrt="nixos-rebuild test --sudo --flake ~/nix-config#${hostnm}"
    alias buildiso="sh ~/nix-config/resjar/nixbin/buildiso.sh"

    # ==[app aliases]
    alias nv="nvim"
    alias zd="zeditor"
    alias code="codium"
    alias yy="yazi"
    alias brw="browsh"
    alias oc="opencode"

    # ==[util]
    alias jars="git pull --rebase origin main"
    alias jnconf="cd ~/nix-config"
    alias jkconf="cd ~/kilnjar"
    alias jkrconf="cd ~/kilnjar/reposjar"
    alias hle="hyprctl configerrors"
    alias hlr="hyprland reload"
    alias ckhrd="lsblk && fdisk -l"
    alias grep="grep --color=auto"
    alias cl="clear"
    alias ga="git add ."
    alias gc="git clone"
    alias fcir="fcitx5-remote -r"
    alias rz="exec zsh"
    alias ns="nix-shell"
    alias nsp="nix search nixpkgs"
    alias ols="ollama list"
    alias olrs="sudo systemctl restart ollama-model-loader.service"
    alias olpm="pull-models"
    alias olrm="remove-models"

    # ==[extra]
    alias mcube="mangohud vkcube --present_mode 1"
    alias cs="cowsay"
    alias csj="cowsay IM JAR"
    alias ff="fastfetch"
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
    hjemDotfiles = {
      zshrc = zshrc;
      fzfrc = fzfrc;
    };
  };
}
