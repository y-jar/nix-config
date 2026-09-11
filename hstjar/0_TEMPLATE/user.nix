# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host 0_TEMPLATE: user toggle sheet (usrset) shared by home-manager and hjem.
# -=-=-=-=-=-=-=-=-=-=-=
# This is the USER configuration file for this host (one sheet, both backends).
# - Each option below is a toggle: enable only what you need (sizes are rough).
# - Keep `shell.enable` true it's the default shell for most systems.
# - WM toggles mirror the system sheet (./system.nix) via the *Enable args.
# - Pair options here with the matching system toggles in ./system.nix.
# - For extra Hyprland/Niri per-host config see juajar/liijar/wmconfigs (host-inputs).
{
  hyprlandEnable,
  niriEnable,
  mangoEnable,
  aiEnable,
  ...
}:

{
  usrset = {
    stateVersion = "HomeManagerVersionNumber"; # [CHANGE THIS]
    name = "PLEASECHANGEME_NAME"; # [CHANGE THIS] for git
    email = "PLEASECHANGEME_EMAIL"; # [CHANGE THIS] for git

    # core [users, shell, basic things]
    # enables zsh shell with aliases [should be on by default]
    shell.enable = true;
    wine.enable = false; # ~500mib - windows compatibility layer (opt-in)
    # cowsay.enable = true; # reference example module copy juajar/liijar/cowsay for new apps

    # =========[experience] [pick one or more if you know what you're doing] [sizes approximate]
    hyprland.enable = hyprlandEnable;
    niri = {
      enable = niriEnable;
      shelljar.enable = false; # my quickshell island shell
      noctalia.enable = false; # noctalia desktop shell
    };
    mango = {
      enable = mangoEnable; # mango (mangowm)
      shelljar.enable = false; # my quickshell island shell
    };
    launcher.enable = true; # ~10mib - sets launcher fuzzel
    resYoink = {
      enable = false; # symlinks resources into ~/resjar/ [~300+mib for wallpapers]
      wallpapers = false;
      icons = false;
      profilePictures = false;
      minecraftSkins = false;
    };
    # =========[experience]^^^

    # =========[appstream]
    browsers = {
      enable = true; # ~500mib - librewolf + firefox
      firefox = false; # firefox [work]
      librewolf = false; # librewolf [personal]
      chromium = false; # enables chromium [personal]
      default = "firefox"; # preferred browser: pick one that's enabled (firefox|librewolf|chromium). WM Super+B + default mime browser.
    };
    terminal = {
      enable = true; # ~30mib - sets terminal as foot + kitty + alacritty
      font = "IntoneMono Nerd Font"; # options: "IntoneMono Nerd Font" "Monocraft" "Miracode"
      fontSize = 14; # font size (default: 14)
    };
    syncthing.enable = false; # file sync (web UI at localhost:8384)
    editors = {
      enable = true; # ~600mib - VSCodium + Zed + Obsidian + Helix + NVF
      vscodium.enable = true; # ~300mib
      zed.enable = false; # ~200mib
      obsidian.enable = false; # ~200mib
      nvf.enable = true; # ~200mib - neovim config
      helix.enable = false; # ~20mib
    }; # end of editors
    chatApps = {
      enable = true;
      discord.enable = true; # ~300mib
      halloy.enable = true; # ~69mib nice
    };
    espanso = (import ../espansoconf.nix { enable = false; }); # ~30mib - espanso text expander
    flatpak.enable = false; # ~10mib - flatpak + bazaar
    # [file explorers]
    nautilus.enable = true; # ~50mib
    yazi.enable = true; # ~10mib
    ranger.enable = false; # ~20mib
    # [media]
    media = {
      enable = true; # media master toggle
      mpv = true; # mpv video player + yt-dlp
      downloaders = false; # ffmpeg + yt-dlp
      musicApps = false; # quodlibet, gapless, blanket
      audioEditor = false; # audacity
      viewers = false; # yacreader, constrict, anki
      defaultApps = true; # default mime apps + loupe/showtime/file-roller
    };
    keepass.enable = true; # ~100mib
    gaming = {
      prism.enable = false; # ~200mib - Prism Launcher [minecraft]
      heroic.enable = false; # ~300mib - Heroic [gog, epic.. other]
    }; # end of gaming
    # =========[appstream]^^^

    # =========[creative tools]
    art = {
      enable = false; # art master toggle
      imageTools = false; # krita, gimp, inkscape, ...
      threeD = false; # blender, blockbench
      astronomy = false; # stellarium, celestia
    };
    office.enable = false; # ~800mib - LibreOffice + Pandoc
    obs.enable = false; # ~400mib - OBS Studio + plugins
    kdenlive.enable = false; # sets kdenlive
    # =========[creative tools]^^^

    # =========[management]
    inputmethods.japanese.enable = false; # ~100mib - fcitx5 + Mozc
    inputmethods.korean.enable = false; # ~100mib - fcitx5 + Hangul
    ai = {
      enable = aiEnable; # sets AI tools like opencode, llama.cpp
      opencode.enable = true; # opencode CLI + GUI (keep even if local llama is off)
      lmstudio.enable = true; # LM Studio (~2.3GiB) set false to save space
    };
    dictation.enable = false; # voxtype push-to-talk dictation + meeting/VTT transcript (F9)
    git.enable = true; # ~10mib - git + gh + lazygit
    bluetooth.enable = false; # ~5mib - blueman
    dev = {
      enable = false; # dev master toggle
      python = false; # python (pyenv + pip)
      dotnet = true; # dotnet SDK
      node = true; # nodejs
      cc = true; # gcc
      go = true; # go
      nixTools = true; # nix language servers + formatters
      sqlTools = true; # dbeaver
    };
    fastfetch.enable = true; # sets fastfetch
    # =========[management]^^^
    theming = {
      enable = true; # sets theme for gtk/qt
      flavor = "mocha"; # catppuccin flavor (latte|frappe|macchiato|mocha)
      accent = "blue"; # catppuccin accent color
      cursorSize = 36; # cursor size in pixels (default: 36)
    };
  }; # end of usrset
}
