# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host ziiemar: user toggle sheet (usrset).
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
      shelljar.enable = false; # my quickshell island shell
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
      enable = true; # sets firefox and librewolf [work and personal]
      firefox.enable = true; # firefox [work]
      librewolf.enable = false; # librewolf [personal]
      chromium.enable = true; # enables chromium [personal]
      default = "firefox"; # preferred browser: WM Super+B + default mime browser
    };
    terminal = {
      enable = true;
      font = "IntoneMono Nerd Font"; # options: "IntoneMono Nerd Font" "Monocraft" "Miracode"
      fontSize = 14; # font size (default: 14)
    };
    syncthing.enable = false; # file sync (web UI at localhost:8384)
    editors = {
      enable = true; # sets all editors
      vscodium.enable = true; # sets vscodium
      zed.enable = true; # sets zed
      obsidian.enable = true; # sets obsidian
      nvf.enable = true; # sets nvf config for neovim [~2G]
      helix.enable = true; # sets helix
      cherrytree.enable = false; # sets cherrytree
      pycharm.enable = false; # sets pycharm
    }; # end of editors
    chatApps = {
      enable = false;
      discord.enable = true;
      halloy.enable = false;
    };
    espanso = import ../../juajar/data/espansoconf.nix { enable = false; }; # espanso text expander
    flatpak.enable = false; # sets flatpak and adds bazaar
    # [file explorers]
    nautilus.enable = true; # sets nautilus
    yazi.enable = true; # sets yazi
    ranger.enable = false; # sets ranger
    # [media]
    media = {
      enable = true; # media master toggle
      mpv.enable = true; # mpv video player + yt-dlp
      downloaders.enable = true; # ffmpeg + yt-dlp
      musicApps.enable = false; # quodlibet, gapless, blanket
      audioEditor.enable = false; # audacity
      viewers.enable = true; # yacreader, constrict, anki
      defaultApps.enable = true; # default mime apps + loupe/showtime/file-roller
    };
    keepass.enable = true; # sets keepassxc
    gaming = {
      prism.enable = false; # sets prismlauncher [minecraft]
      heroic.enable = false; # sets heroic [gog, epic.. other]
    }; # end of gaming
    # =========[appstream]^^^

    # =========[creative tools]
    art = {
      enable = false; # art master toggle
      imageTools.enable = false; # krita, gimp, inkscape, ...
      threeD.enable = false; # blender, blockbench
      astronomy.enable = false; # stellarium, celestia
    };
    office.enable = true; # sets libreoffice and other apps
    obs.enable = false; # sets up obs studio
    kdenlive.enable = false; # sets kdenlive
    # =========[creative tools]^^^

    # =========[management]
    inputMethods.japanese.enable = true; # sets japanese input
    inputMethods.korean.enable = false; # sets korean input
    ai = {
      enable = aiEnable; # sets AI tools like opencode, llama.cpp
      opencode.enable = true; # opencode CLI + GUI (keep even if local llama is off)
      lmstudio.enable = false; # LM Studio (~2.3GiB) set false to save space
    };
    dictation.enable = false; # voxtype push-to-talk dictation + meeting/VTT transcript (F9)
    git.enable = true; # sets git
    tuneshon.enable = false; # NixOS update tool (gui + cli)
    nueon.enable = true; # conlang editor/creation app
    nueon.binary = true; # use the prebuilt release .deb
    bluetooth.enable = true; # sets blueman in home packages
    dev = {
      enable = false; # dev master toggle
      dotnet.enable = false; # dotnet SDK
      node.enable = false; # nodejs
      cc.enable = false; # gcc
      go.enable = false; # go
      nixTools.enable = false; # nix language servers + formatters
      sqlTools.enable = false; # dbeaver
    };
    fastfetch.enable = true; # sets fastfetch
    # =========[management]^^^
  }; # end of usrset
}
