# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Shared zsh alias set (single source of truth).
# -=-=-=-=-=-=-=-=-=-=-=
# Consumed by the zsh module so every host gets the exact same aliases:
#   - juajar/liijar/zsh/default.nix (generated `alias k=v` lines)
# Takes `hostnm` so per-host rebuild aliases target the right system.
# -=-=-=-=-=-=-=-=-=-=-=
{ hostnm }:
{
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
  repl = "nix repl --file ~/nix-config/juajar/liijar/shell/repl.nix"; # poke the flake
  # ========[app aliases]
  nv = "nvim";
  zd = "zeditor";
  code = "codium";
  yy = "yazi";
  brw = "browsh"; # TUI based browser
  b = "browsh"; # browser
  oc = "opencode"; # Ai thing
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
  rllm = "sudo systemctl restart llama-cpp";
  sllm = "sudo systemctl restart llama-cpp";
  stllm = "sudo systemctl start llama-cpp";
  # [t480 related commands]
  cbat = "acpi -b"; # check battery status combined

  # =========[Extra]
  mcube = "mangohud vkcube --present_mode 1"; # needs mangohud+vulkan-tools
  cs = "cowsay";
  csj = "cowsay IM JAR";
  ff = "fastfetch";
} # end of aliases
