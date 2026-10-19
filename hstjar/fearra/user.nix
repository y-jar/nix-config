# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host fearra: user toggle sheet (usrset).
# -=-=-=-=-=-=-=-=-=-=-=
# This is the USER configuration file for this host (one sheet).
# - Each option below is a toggle: enable only what you need (sizes are rough).
# - Keep `zsh.enable` true it's the default shell for most systems.
# - WM toggles mirror the system sheet (./system.nix) via the *Enable args.
# - Pair options here with the matching system toggles in ./system.nix.
# - For extra Hyprland/Niri per-host config see juajar/WMs/<wm>/host-inputs.
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
      shelljar.enable = true; # my quickshell island shell
    };
    fuzzel.enable = true; # ~10mib - sets launcher fuzzel
    resYoink = {
      enable = false; # symlinks resources into ~/resjar/ [~300+mib for wallpapers]
      wallpapers.enable = true;
      icons.enable = false;
      profilePictures.enable = false;
      minecraftSkins.enable = false;
    };
    # =========[experience]^^^

    # =========[appstream]
    browsers = {
      enable = true; # ~500mib - librewolf + firefox
      firefox.enable = false; # firefox [work]
      librewolf.enable = false; # librewolf [personal]
      chromium.enable = true; # enables chromium [personal]
      default = "firefox"; # preferred browser: pick one that's enabled (firefox|librewolf|chromium). WM Super+B + default mime browser.
    };
    terminal = {
      enable = true; # ~30mib - sets terminal as foot + kitty + alacritty
      font = "monocraft"; # options: "IntoneMono Nerd Font" "Monocraft" "Miracode"
      fontSize = 18; # font size (default: 14)
    };
    syncthing.enable = false; # file sync (web UI at localhost:8384)
    editors = {
      enable = true; # ~600mib - VSCodium + Zed + Obsidian + Helix + NVF
      vscodium.enable = true; # ~300mib
      zed.enable = false; # ~200mib
      obsidian.enable = false; # ~200mib
      nvf.enable = true; # ~200mib - neovim config
      helix.enable = false; # ~20mib
      cherrytree.enable = false; # ~150mib - hierarchical note-taking editor
      pycharm.enable = false; # ~2.5gib - JetBrains PyCharm Professional (unfree)
    }; # end of editors
    chatApps = {
      enable = false;
      discord.enable = true; # ~300mib
      halloy.enable = true; # ~69mib nice
    };
    espanso = import ../../juajar/data/espansoconf.nix { enable = false; }; # ~30mib - espanso text expander
    flatpak.enable = false; # ~10mib - flatpak + bazaar
    # [file explorers]
    nautilus.enable = true; # ~50mib
    yazi.enable = true; # ~10mib
    ranger.enable = false; # ~20mib
    # [media]
    media = {
      enable = true; # media master toggle
      mpv.enable = true; # mpv video player + yt-dlp
      downloaders.enable = false; # ffmpeg + yt-dlp
      musicApps.enable = true; # quodlibet, gapless, blanket
      audioEditor.enable = false; # audacity
      viewers.enable = false; # constrict, anki
      defaultApps.enable = true; # default mime apps + loupe/showtime/file-roller
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
      imageTools.enable = false; # krita, gimp, inkscape, ...
      threeD.enable = false; # blender, blockbench
      astronomy.enable = false; # stellarium, celestia
    };
    office.enable = false; # ~800mib - LibreOffice + Pandoc
    obs.enable = false; # ~400mib - OBS Studio + plugins
    kdenlive.enable = false; # sets kdenlive
    # =========[creative tools]^^^

    # =========[management]
    inputMethods.japanese.enable = false; # ~100mib - fcitx5 + Mozc
    inputMethods.korean.enable = false; # ~100mib - fcitx5 + Hangul
    ai = {
      enable = aiEnable; # sets AI tools like opencode, llama.cpp
      opencode.enable = false; # opencode CLI + GUI (keep even if local llama is off)
      lmstudio.enable = false; # LM Studio (~2.3GiB) set false to save space
    };
    dictation.enable = false; # voxtype push-to-talk dictation + meeting/VTT transcript (F9)
    git.enable = true; # ~10mib - git + gh + lazygit
    tuneshon.enable = true; # NixOS update tool (gui + cli)
    nueon.enable = true; # conlang editor/creation app
    nueon.binary = true; # use the prebuilt release .deb
    bluetooth.enable = false; # ~5mib - blueman
    dev = {
      enable = false; # dev master toggle
      python.enable = false; # python (pyenv + pip)
      dotnet.enable = true; # dotnet SDK
      node.enable = true; # nodejs
      cc.enable = true; # gcc
      go.enable = true; # go
      nixTools.enable = true; # nix language servers + formatters
      sqlTools.enable = true; # dbeaver
    };
    fastfetch.enable = true; # sets fastfetch
    # =========[management]^^^
    theming = {
      enable = true; # sets theme for gtk/qt
      variant = "dark"; # gruvbox variant (dark|light)
      accent = "orange"; # gruvbox accent (orange is the warm star)
      blackness = true; # darker backgrounds
      cursorSize = 36; # cursor size in pixels (default: 36)
    };
  }; # end of usrset
}
