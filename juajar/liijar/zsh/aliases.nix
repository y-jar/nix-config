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
  zd = "zeditor";
  code = "codium";
  brw = "browsh"; # TUI based browser
  b = "browsh"; # browser
  # ========[util]
  #[jar]
  jars = "git pull --rebase origin main";
  jnconf = "cd ~/nix-config"; # nix config jar [move over into nix config]
  jkconf = "cd ~/kilnjar"; # kiln jar [my dev / project folder]
  jkrconf = "cd ~/kilnjar/reposjar"; # kiln jar [my dev / project folder]
  # [hyprland]
  hle = "hyprctl configerrors";
  hlr = "hyprland reload";
  # [Management for Packages]
  rpw = "systemctl --user restart pipewire pipewire-pulse wireplumber"; # restart pipewire
  clfont = "fc-cache -f -v"; # clear font cache
  rfc5 = "fcitx5 -r -d"; # restart fcitx5
  frfc5 = "fcitx5-remote -r"; # force reload fcitx5
  rz = "exec zsh"; # reload zsh
  ksj = "pkill -f 'shelljar/qml'"; # restart quickshell shell jar
  rsj = "pkill -f 'quickshell -n -p .*shelljar' && shelljar &"; # restart quickshell shell jar
  # [Tools]
  jip = "ip -4 addr show | grep inet"; # show ip info
  ckhrd = "lsblk && fdisk -l";
  grep = "grep --color=auto";
  cl = "clear";
  c = "clear";
  ga = "git add .";
  gc = "git clone";
  s = "setsid";
  pk = "pkill";
  rniri = "niri msg action reload-config";
  dl = "ytdl"; # youtube downloader
  shlvl = "echo $SHLVL";
  # [AI]
  # [t480 related commands]
  cbat = "acpi -b"; # check battery status combined
  # [fleet ssh (see hstjar/*/net.nix + sysjar/networking)]
  fkey = "ssh-keyscan -t ed25519"; # scan a host's fleet key: fkey <hostname>.local

  # =========[Extra]
  mcube = "mangohud vkcube --present_mode 1"; # needs mangohud+vulkan-tools
  cs = "cowsay";
  csj = "cowsay IM JAR";
  ff = "fastfetch";
} # end of aliases
