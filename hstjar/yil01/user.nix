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
    zsh.enable = true;
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
      shelljar.enable = true; # my quickshell island shell
    };
    fuzzel.enable = true; # sets launcher fuzzel
    theming = {
      enable = true;
      variant = "dark";
      accent = "orange";
      blackness = true;
      cursorSize = 36;
    };
    resYoink = {
      enable = true;
      wallpapers.enable = true;
      icons.enable = true;
      profilePictures.enable = true;
      minecraftSkins.enable = false;
    };
    # =========[experience]^^^

    # =========[appstream]
    browsers = {
      enable = true;
      firefox.enable = true; # firefox [work]
      librewolf.enable = false; # librewolf [personal]
      chromium.enable = false;
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
      cherrytree.enable = false;
      pycharm.enable = false;
    };
    chatApps = {
      enable = true;
      discord.enable = true;
      halloy.enable = true;
    };
    espanso = import ../../juajar/data/espansoconf.nix { enable = true; }; # espanso text expander
    flatpak.enable = false;
    nautilus.enable = true;
    yazi.enable = true;
    ranger.enable = false;
    media = {
      enable = false;
      mpv.enable = true;
      downloaders.enable = false;
      musicApps.enable = false;
      audioEditor.enable = false;
      viewers.enable = false;
      defaultApps.enable = true;
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
      imageTools.enable = false;
      threeD.enable = false;
      astronomy.enable = false;
    };
    office.enable = true;
    obs.enable = false;
    kdenlive.enable = false;
    # =========[creative tools]^^^

    # =========[management]
    inputMethods.japanese.enable = true;
    inputMethods.korean.enable = false;
    ai = {
      enable = aiEnable; # sets AI tools like opencode, llama.cpp
      opencode.enable = true; # opencode CLI + GUI (keep even if local llama is off)
      lmstudio.enable = false; # LM Studio (~2.3GiB) set false to save space
    };
    dictation.enable = false;
    git.enable = true;
    tuneshon.enable = false; # NixOS update tool (gui + cli)
    nueon.enable = true; # conlang editor/creation app
    nueon.binary = true; # use the prebuilt release .deb
    bluetooth.enable = true;
    fastfetch.enable = true;
    dev = {
      enable = false; # dev master toggle
      dotnet.enable = true; # dotnet SDK
      node.enable = true; # nodejs
      cc.enable = false; # gcc
      go.enable = false; # go
      nixTools.enable = true; # nix language servers + formatters
      sqlTools.enable = false; # dbeaver
    };
    # =========[management]^^^
  }; # end of usrset
}
