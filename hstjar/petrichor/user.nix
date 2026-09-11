# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host petrichor: user toggle sheet (usrset).
# (kwaytea's Pewta)
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
    name = "kway"; # [CHANGE THIS] for git
    email = "kwayckyle@gmail.com"; # [CHANGE THIS] for git

    # core [users, shell, basic things]
    shell.enable = true;
    wine.enable = true; # ~500mib - windows compatibility layer (opt-in)

    # =========[experience]
    hyprland.enable = hyprlandEnable;
    niri = {
      enable = niriEnable;
      shelljar.enable = true; # my quickshell island shell
      noctalia.enable = false; # noctalia desktop shell
    };
    mango = {
      enable = mangoEnable;
      shelljar.enable = true; # my quickshell island shell
    };
    launcher.enable = true; # ~10mib - sets launcher fuzzel
    theming = {
      enable = true;
      flavor = "mocha";
      accent = "blue";
      cursorSize = 36;
    };
    resYoink = {
      enable = true; # symlinks resources into ~/resjar/ [~300+mib for wallpapers]
      wallpapers = true;
      icons = true;
      profilePictures = false;
      minecraftSkins = false;
    };
    # =========[experience]^^^

    # =========[appstream]
    browsers = {
      enable = true; # ~500mib - librewolf + firefox
      firefox = true; # firefox [work]
      librewolf = false; # librewolf [personal]
      chromium = false; # enables chromium [personal]
      default = "firefox"; # preferred browser: WM Super+B/Mod+B + default mime browser
    };
    terminal = {
      enable = true; # ~30mib - sets terminal as foot + kitty + alacritty
      font = "monocraft"; # options: "IntoneMono Nerd Font" "Monocraft" "Miracode"
      fontSize = 16; # font size (default: 14)
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
      halloy.enable = false; # ~69mib nice
    };
    espanso = (import ../espansoconf.nix { enable = false; }); # ~30mib - espanso text expander
    flatpak.enable = true; # ~10mib - flatpak + bazaar
    # [file explorers]
    nautilus.enable = true; # ~50mib
    yazi.enable = true; # ~10mib
    ranger.enable = false; # ~20mib
    # [media]
    media = {
      enable = true; # media master toggle
      mpv = true; # mpv video player + yt-dlp
      downloaders = false; # ffmpeg + yt-dlp
      musicApps = true; # quodlibet, gapless, blanket
      audioEditor = false; # audacity
      viewers = true; # yacreader, constrict, anki
      defaultApps = true; # default mime apps + loupe/showtime/file-roller
    };
    keepass.enable = true; # ~100mib
    gaming = {
      prism.enable = true; # ~200mib - Prism Launcher [minecraft]
      heroic.enable = true; # ~300mib - Heroic [gog, epic.. other]
    }; # end of gaming
    # =========[appstream]^^^

    # =========[creative tools]
    art = {
      enable = true; # art master toggle
      imageTools = true; # krita, gimp, inkscape, ...
      threeD = false; # blender, blockbench
      astronomy = true; # stellarium, celestia
    };
    office.enable = true; # ~800mib - LibreOffice + Pandoc
    obs.enable = true; # ~400mib - OBS Studio + plugins
    kdenlive.enable = false; # sets kdenlive
    # =========[creative tools]^^^

    # =========[management]
    inputmethods.japanese.enable = false; # ~100mib - fcitx5 + Mozc
    inputmethods.korean.enable = false; # ~100mib - fcitx5 + Hangul
    ai = {
      enable = aiEnable; # sets AI tools like opencode, llama.cpp
      opencode.enable = true; # opencode CLI + GUI (keep even if local llama is off)
      lmstudio.enable = false; # LM Studio (~2.3GiB) set false to save space
    };
    dictation.enable = false; # voxtype push-to-talk dictation + meeting/VTT transcript (F9)
    git.enable = true; # ~10mib - git + gh + lazygit
    bluetooth.enable = false; # ~5mib - blueman
    dev = {
      enable = false; # dev master toggle
      dotnet = true; # dotnet SDK
      node = true; # nodejs
      cc = true; # gcc
      go = true; # go
      nixTools = true; # nix language servers + formatters
      sqlTools = false; # dbeaver
    };
    fastfetch.enable = true; # sets fastfetch
    # =========[management]^^^
  }; # end of usrset
}
