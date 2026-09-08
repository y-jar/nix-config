# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem: zsh fzfrc generation.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  hostnm,
  osConfig,
  ...
}:
let
  hjm = config.hjmSettings;

  zshSyntax = pkgs.zsh-syntax-highlighting;
  zshAutosuggestions = pkgs.zsh-autosuggestions;

  # Whether this host allows unfree packages (drives the modern `,` temp-install).
  uf = osConfig.sysSettings.unfree.enable or false;

  zshrc = pkgs.writeText "zshrc" ''
    # completions
    autoload -Uz compinit
    compinit

    # autosuggestions
    source ${zshAutosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

    # syntax highlighting
    source ${zshSyntax}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    # user-local binaries (webapp launchers, user scripts)
    export PATH="$HOME/.local/bin:$PATH"

    # zoxide (smart cd)
    eval "$(zoxide init zsh)"

    # prompt
    PROMPT='%F{#5F7CB8}%n|%f'
    RPROMPT='%F{#5F7CB8}%~ %F{#5F7CB8}%m%f %F{cyan}%*%f'

    # quick nix shell: , git curl   or   , git curl -- ls   (modern, flake-based)
    # Boots an interactive shell (no `-- <cmd>`) or runs a one-off command (`-- <cmd>`).
    # Unfree temp installs are allowed only on hosts where sysSettings.unfree.enable is true.
    ,() {
      local -a pref=() pkgs=() args=()
      local sep=0 p
      ${lib.optionalString uf "pref=(env NIXPKGS_ALLOW_UNFREE=1)"}
      for p in "$@"; do
        if [[ "$p" == "--" ]]; then sep=1; continue; fi
        if (( sep )); then args+=("$p"); else pkgs+=("nixpkgs#$p"); fi
      done
      if [[ ''${#args[@]} -gt 0 ]]; then
        "''$pref[@]" nix shell ${lib.optionalString uf "--impure"} "''${pkgs[@]}" -c "''${args[@]}"
      else
        "''$pref[@]" nix shell ${lib.optionalString uf "--impure"} "''${pkgs[@]}"
      fi
    }

    # host-target rebuild/test (mirrors home-manager zsh: default to current host)
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

    # aliases
    # ==[syst]
    alias nht="nh os test --accept-flake-config ~/nix-config#${hostnm}"
    alias nhs="nh os switch --accept-flake-config ~/nix-config#${hostnm}"
    alias nhc="nh clean all --keep 7"
    alias nsr="sudo nix-store --verify --check-contents --repair"
    alias nrs="nixos-rebuild switch --sudo --flake ~/nix-config#${hostnm}"
    alias nrt="nixos-rebuild test --sudo --flake ~/nix-config#${hostnm}"
    alias buildiso="sh ~/nix-config/resjar/nixbin/buildiso.sh"
    alias ns="nix-shell"
    alias nsp="nix search nixpkgs"

    # update the lock, or only specific inputs (nfu shelljar ; nfu shelljar nvf)
    nfu() { nix flake update "$@"; }

    # ==[app aliases]
    alias nv="nvim"
    alias zd="zeditor"
    alias code="codium"
    alias yy="yazi"
    alias brw="browsh"
    alias b="browsh"
    alias oc="opencode"

    # ==[util]
    alias jars="git pull --rebase origin main"
    alias jnconf="cd ~/nix-config"
    alias neconf="cd /etc/nixos"
    alias jkconf="cd ~/kilnjar"
    alias jkrconf="cd ~/kilnjar/reposjar"
    alias hle="hyprctl configerrors"
    alias hlr="hyprland reload"
    alias rpw="systemctl --user restart pipewire pipewire-pulse wireplumber"
    alias clfont="fc-cache -f -v"
    alias rfc5="fcitx5 -r -d"
    alias frfc5="fcitx5-remote -r"
    alias rz="exec zsh"
    alias ksj="pkill -f 'shelljar/qml'"
    alias rsj="pkill -f 'quickshell -n -p .*shelljar' && shelljar &"
    alias jip="ip -4 addr show | grep inet"
    alias ckhrd="lsblk && fdisk -l"
    alias grep="grep --color=auto"
    alias cl="clear"
    alias c="clear"
    alias ga="git add ."
    alias gc="git clone"
    alias s="setsid"
    alias pk="pkill"
    alias rniri="niri msg action reload-config"
    alias dl="ytdl"
    alias shlvl="echo $SHLVL"
    # ==[AI]
    alias rllm="sudo systemctl restart llama-cpp"
    alias sllm="sudo systemctl restart llama-cpp"
    alias stllm="sudo systemctl start llama-cpp"
    alias cbat="acpi -b"
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
