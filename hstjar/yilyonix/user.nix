# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host yilyonix: user toggle sheet (usrset).
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
      noctalia.enable = false; # noctalia desktop shell
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
      enable = true; # sets firefox and librewolf [work and personal]
      firefox = false; # firefox [work]
      librewolf = true; # librewolf [personal]
      chromium = true; # enables chromium [personal]
      default = "librewolf"; # preferred browser: WM Super+B + default mime browser
    };
    terminal = {
      enable = true;
      font = "IntoneMono Nerd Font"; # options: "IntoneMono Nerd Font" "Monocraft" "Miracode"
      fontSize = 14; # font size (default: 14)
    };
    syncthing.enable = true; # file sync (web UI at localhost:8384)
    editors = {
      enable = false; # sets all editors
      vscodium.enable = false; # sets vscodium
      zed.enable = true; # sets zed
      obsidian.enable = false; # sets obsidian
      nvf.enable = true; # sets nvf config for neovim [~2G]
      helix.enable = false; # sets helix
    }; # end of editors
    chatApps = {
      enable = true;
      discord.enable = true;
      halloy.enable = false;
    };
    espanso = (import ../espansoconf.nix { enable = false; }); # espanso text expander
    flatpak.enable = false; # sets flatpak and adds bazaar
    # [file explorers]
    nautilus.enable = true; # sets nautilus
    yazi.enable = true; # sets yazi
    ranger.enable = false; # sets ranger
    # [media]
    media = {
      enable = true; # media master toggle
      mpv = true; # mpv video player + yt-dlp
      downloaders = true; # ffmpeg + yt-dlp
      musicApps = true; # quodlibet, gapless, blanket
      audioEditor = true; # audacity
      viewers = true; # yacreader, constrict, anki
      defaultApps = true; # default mime apps + loupe/showtime/file-roller
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
      imageTools = false; # krita, gimp, inkscape, ...
      threeD = false; # blender, blockbench
      astronomy = false; # stellarium, celestia
    };
    office.enable = false; # sets libreoffice and other apps
    obs.enable = false; # sets up obs studio
    kdenlive.enable = false; # sets kdenlive
    # =========[creative tools]^^^

    # =========[management]
    inputmethods.japanese.enable = true; # sets japanese input
    inputmethods.korean.enable = false; # sets korean input
    ai = {
      enable = aiEnable; # sets AI tools like opencode, llama.cpp
      opencode.enable = true; # opencode CLI + GUI (keep even if local llama is off)
      lmstudio.enable = true; # LM Studio (~2.3GiB) set false to save space
    };
    dictation.enable = false; # voxtype push-to-talk dictation + meeting/VTT transcript (F9)
    git.enable = true; # sets git
    bluetooth.enable = true; # sets blueman in home packages
    dev = {
      enable = false; # dev master toggle
      dotnet = false; # dotnet SDK
      node = false; # nodejs
      cc = false; # gcc
      go = false; # go
      nixTools = false; # nix language servers + formatters
      sqlTools = false; # dbeaver
    };
    fastfetch.enable = true; # sets fastfetch
    # =========[management]^^^
  }; # end of usrset
}
