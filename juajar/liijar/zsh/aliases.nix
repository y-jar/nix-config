# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Portable zsh alias set (works on any host; NixOS-only ones are in aliases-nixos.nix).
# -=-=-=-=-=-=-=-=-=-=-=
# Consumed by the zsh module so every host gets the exact same aliases:
#   - juajar/liijar/zsh/default.nix (generated `alias k=v` lines)
# Nothing here may assume NixOS (no nh / nixos-rebuild / /etc/nixos / system units).
# -=-=-=-=-=-=-=-=-=-=-=
{
  # ========[sys nix]
  nsc = "sudo nix-collect-garbage -d"; # dense clean: drop all old generations (vs nhc --keep 7 on NixOS)
  nsr = "sudo nix-store --verify --check-contents --repair";
  ns = "nix-shell"; # load dev enviroment
  nsp = "nix search nixpkgs";
  # ========[app aliases]
  nv = "nvim";
  v = "vis"; # lightweight vi-style editor
  zd = "zeditor";
  code = "codium";
  brw = "browsh"; # TUI based browser
  # ========[util]
  #[jar]
  jars = "git pull --rebase origin main";
  # [Management for Packages]
  rpw = "systemctl --user restart pipewire pipewire-pulse wireplumber"; # restart pipewire
  clfont = "fc-cache -f -v"; # clear font cache
  rfc5 = "fcitx5 -r -d"; # restart fcitx5
  frfc5 = "fcitx5-remote -r"; # force reload fcitx5
  rz = "exec zsh"; # reload zsh
  ksj = "pkill -f 'shelljar/qml'"; # restart quickshell shell jar
  rsj = "pkill -f 'quickshell -n -p .*shelljar' || true; shelljar &"; # restart quickshell shell jar
  # [Tools]
  jip = "ip -4 addr show | grep inet"; # show ip info
  chkhrd = "lsblk && fdisk -l";
  grep = "grep --color=auto";
  cl = "clear";
  ga = "git add .";
  gc = "git clone";
  rniri = "niri msg action reload-config";
  dl = "ytdl"; # youtube downloader
  # [AI]
  # [fleet ssh (see hstjar/*/net.nix + sysjar/networking)]
  fkey = "ssh-keyscan -t ed25519"; # scan a host's fleet key: fkey <hostname>.local

  # =========[Extra]
  mcube = "mangohud vkcube --present_mode 1"; # needs mangohud+vulkan-tools
  cs = "cowsay";
  ff = "fastfetch";
} # end of aliases
