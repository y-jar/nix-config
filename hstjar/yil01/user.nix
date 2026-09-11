# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host yil01: user toggle sheet (usrset).
# (live as yil01 / yil02 both read this sheet)
# -=-=-=-=-=-=-=-=-=-=-=
{
  hyprlandEnable,
  niriEnable,
  mangoEnable,
  aiEnable,
  ...
}:

{
  usrset = {
    name = "y-jar"; # [CHANGE THIS] for git
    email = "park.7qs@gmail.com"; # [CHANGE THIS] for git

    # core [users, shell, basic things]
    shell.enable = true;
    wine.enable = true; # ~500mib - windows compatibility layer (opt-in)

    # =========[experience]
    hyprland.enable = hyprlandEnable;
    niri = {
      enable = niriEnable;
      shelljar.enable = false; # my quickshell island shell
      noctalia.enable = true; # noctalia desktop shell
    };
    mango = {
      enable = mangoEnable;
      shelljar.enable = false; # my quickshell island shell
    };
    launcher.enable = true; # sets launcher fuzzel
    theming = {
      enable = true;
      flavor = "mocha";
      accent = "blue";
      cursorSize = 36;
    };
    resYoink = {
      enable = true;
      wallpapers = true;
      icons = true;
      profilePictures = true;
      minecraftSkins = false;
    };
    # =========[experience]^^^

    # =========[appstream]
    browsers = {
      enable = true;
      firefox = true; # firefox [work]
      librewolf = false; # librewolf [personal]
      chromium = false;
      default = "firefox"; # preferred browser: WM Mod+B + default mime browser
    };
    terminal = {
      enable = true;
      font = "monocraft"; # options: "IntoneMono Nerd Font" "Monocraft" "Miracode"
      fontSize = 16;
    };
    syncthing.enable = false; # file sync (web UI at localhost:8384)
    editors = {
      enable = true;
      vscodium.enable = true;
      zed.enable = false;
      obsidian.enable = false;
      nvf.enable = true;
      helix.enable = false;
    };
    chatApps = {
      enable = true;
      discord.enable = true;
      halloy.enable = true;
    };
    espanso = (import ../espansoconf.nix { enable = false; }); # espanso text expander
    flatpak.enable = false;
    nautilus.enable = true;
    yazi.enable = true;
    ranger.enable = false;
    media = {
      enable = true;
      mpv = true;
      downloaders = false;
      musicApps = false;
      audioEditor = false;
      viewers = false;
      defaultApps = true;
    };
    keepass.enable = true;
    gaming = {
      prism.enable = false;
      heroic.enable = false;
    };
    # =========[appstream]^^^

    # =========[creative tools]
    art = {
      enable = false;
      imageTools = false;
      threeD = false;
      astronomy = false;
    };
    office.enable = false;
    obs.enable = false;
    kdenlive.enable = false;
    # =========[creative tools]^^^

    # =========[management]
    inputmethods.japanese.enable = true;
    inputmethods.korean.enable = false;
    ai = {
      enable = aiEnable; # sets AI tools like opencode, llama.cpp
      opencode.enable = true; # opencode CLI + GUI (keep even if local llama is off)
      lmstudio.enable = true; # LM Studio (~2.3GiB) set false to save space
    };
    dictation.enable = false;
    git.enable = true;
    bluetooth.enable = false;
    fastfetch.enable = true;
    dev = {
      enable = false; # dev master toggle
      dotnet = true; # dotnet SDK
      node = true; # nodejs
      cc = false; # gcc
      go = false; # go
      nixTools = true; # nix language servers + formatters
      sqlTools = false; # dbeaver
    };
    # =========[management]^^^
  }; # end of usrset
}
