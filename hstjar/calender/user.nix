# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host calender: user toggle sheet (usrset).
# -=-=-=-=-=-=-=-=-=-=-=
# This is the USER configuration file for this host (one sheet).
# - Each option below is a toggle: enable only what you need.
# - Keep `zsh.enable` true it's the default shell for most systems.
# - WM toggles mirror the system sheet (./system.nix) via the *Enable args.
# - Pair options here with the matching system toggles in ./system.nix.
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
    # enables zsh shell with aliases [should be on by default]
    zsh.enable = true;
    wine.enable = true; # ~500mib - windows compatibility layer (opt-in)

    # =========[experience]
    hyprland.enable = hyprlandEnable;
    niri = {
      enable = niriEnable;
      shelljar.enable = false; # my quickshell island shell
      noctalia.enable = false; # noctalia desktop shell (shelljar replaces it)
    };
    mango = {
      enable = mangoEnable; # mango (mangowm) the compositor calender runs
      shelljar.enable = true; # my quickshell island shell (binds.conf is all shjctl)
    };
    fuzzel.enable = true; # sets launcher fuzzel
    tablets.xppen.enable = true; # map XP-Pen Artist 13.3 Pro pen to its display (juajar/data/tabletconf.nix)
    theming = {
      enable = true;
      variant = "dark"; # gruvbox variant (dark|light)
      accent = "orange"; # gruvbox accent (orange is the warm star)
      blackness = true; # darker backgrounds
      cursorSize = 48; # cursor size in pixels (default: 36)
    };
    resYoink = {
      enable = true; # symlinks resources into ~/resjar/
      wallpapers.enable = true;
      icons.enable = true;
      profilePictures.enable = true;
      minecraftSkins.enable = true;
    };
    # =========[experience]^^^

    # =========[appstream]
    browsers = {
      enable = true; # sets firefox and librewolf [work and personal]
      firefox.enable = true; # firefox [work]
      librewolf.enable = true; # librewolf [personal]
      chromium.enable = true; # needed for native webapps (`--app` mode)
      default = "firefox"; # preferred browser: WM Mod+B + default mime browser
    };
    terminal = {
      enable = true; # sets terminal as foot
      font = "Monocraft"; # options: "IntoneMono Nerd Font" "Monocraft" "Miracode"
      fontSize = 16; # font size (default: 14)
    };
    syncthing.enable = false; # file sync (web UI at localhost:8384)
    editors = {
      enable = true; # sets editors
      vscodium.enable = true; # sets vscodium
      zed.enable = true; # sets zed
      obsidian.enable = true; # sets obsidian
      nvf.enable = false; # sets nvf config for neovim
      helix.enable = false; # sets helix
      cherrytree.enable = true; # sets cherrytree
      pycharm.enable = true; # sets pycharm
    }; # end of editors
    chatApps = {
      enable = true;
      discord.enable = true;
      halloy.enable = false;
    };
    espanso = import ../../juajar/data/espansoconf.nix { }; # espanso text expander
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
      prism.enable = true; # sets prismlauncher [minecraft]
      heroic.enable = true; # sets heroic [gog, epic.. other]
    }; # end of gaming
    # =========[appstream]^^^

    # =========[creative tools]
    art = {
      enable = false; # art master toggle
      imageTools.enable = true; # krita, gimp, inkscape, ...
      threeD.enable = false; # blender, blockbench
      astronomy.enable = true; # stellarium, celestia
    };
    office.enable = true; # sets libreoffice and other apps
    obs.enable = true; # sets up obs studio
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
    dictation.enable = false; # push-to-talk dictation + meeting/VTT transcript (voxtype, F9)
    git.enable = true; # sets git
    tuneshon = {
      enable = true; # NixOS update tool (gui + cli)
      configDir = "/home/jar/nix-config"; # this repo
      bootLoader = "systemd-boot"; # see boot.nix
      logFile = "/home/jar/.config/tuneshon/tuneshon.log"; # default
      overwrite = true; # don't clobber GUI edits
    };
    nueon.enable = true; # conlang editor/creation app
    nueon.binary = false; # build from source (dev machine)
    bluetooth.enable = false; # sets blueman in home packages
    dev = {
      enable = true; # dev master toggle
      python.enable = true; # python (pyenv + pip)
      dotnet.enable = false; # dotnet SDK
      node.enable = false; # nodejs
      cc.enable = false; # gcc
      go.enable = false; # go
      nixTools.enable = true; # nix language servers + formatters
      sqlTools.enable = true; # dbeaver
    };
    fastfetch.enable = true; # sets fastfetch
    # =========[management]^^^
  }; # end of usrset
}
