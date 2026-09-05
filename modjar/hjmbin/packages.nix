# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem user packages bucket.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  hjm = config.hjmSettings;
in
{
  packages =
    with pkgs;
    [
      # core
      zsh

      # cli tools
      ripgrep
      fd
      bat
      fzf
      zoxide
      noogle-search # search Nix functions from CLI

      # editors (base)
    ]
    ++ lib.optionals hjm.browsers.enable [
      firefox
      librewolf
      chromium
    ]
    ++ lib.optionals hjm.terminal.enable [
      foot
      kitty
      alacritty
    ]
    ++ lib.optionals hjm.editors.enable [
      vscodium
      zed
    ]
    ++ lib.optionals hjm.editors.obsidian.enable [
      obsidian
    ]
    ++ lib.optionals hjm.editors.helix.enable [
      helix
    ]
    ++ lib.optionals hjm.chatApps.enable (
      (lib.optionals hjm.chatApps.discord.enable [ discord ])
      ++ (lib.optionals hjm.chatApps.halloy.enable [ halloy ])
    )
    ++ lib.optionals hjm.flatpak.enable [
      bazaar
    ]
    ++ lib.optionals hjm.nautilus.enable [
      nautilus
    ]
    ++ lib.optionals hjm.yazi.enable [
      yazi
    ]
    ++ lib.optionals hjm.ranger.enable [
      ranger
    ]
    ++ lib.optionals hjm.niri.enable [
      nwg-drawer # full-screen app drawer launcher (Mod+D)
    ]
    ++ lib.optionals hjm.media.enable (
      (lib.optionals hjm.media.mpv [ mpv ])
      ++ (lib.optionals hjm.media.musicApps [
        blanket
        quodlibet
        gapless
        spotify # music streaming (unfree)
      ])
      ++ (lib.optionals hjm.media.audioEditor [
        audacity
      ])
      ++ (lib.optionals hjm.media.viewers [
        yacreader
        constrict
        anki
      ])
      ++ (lib.optionals hjm.media.downloaders [
        ffmpeg
        yt-dlp
      ])
      ++ (lib.optionals hjm.media.defaultApps [
        loupe # image viewer
        showtime # video player (GNOME)
        file-roller # archive manager (GNOME)
      ])
    )
    ++ lib.optionals hjm.keepass.enable [
      keepassxc
    ]
    ++ lib.optionals hjm.gaming.prism.enable [
      prismlauncher
    ]
    ++ lib.optionals hjm.gaming.heroic.enable [
      heroic
    ]
    ++ lib.optionals hjm.art.enable (
      (lib.optionals hjm.art.imageTools [
        drawio # desktop diagram editor
        upscayl # AI image upscaler
        converseen # batch image converter/resizer
        fontforge # font editor
        digikam # photo manager
        coulr # color picker
        halftone # halftone effect generator
        krita # digital painting
        gimp # image manipulation
        inkscape # vector graphics
        mypaint # digital painting
        drawpile # collaborative drawing
      ])
      ++ (lib.optionals hjm.art.threeD [
        blender # 3D modeling/animation
        blockbench # 3D model editor (minecraft)
      ])
      ++ (lib.optionals hjm.art.astronomy [
        stellarium # planetarium
        celestia # 3D space simulation
      ])
    )
    ++ lib.optionals hjm.office.enable [
      libreoffice
      pandoc
    ]
    ++ lib.optionals hjm.obs.enable [
      obs-studio
    ]
    ++ lib.optionals hjm.kdenlive.enable [
      kdenlive
    ]
    ++ lib.optionals hjm.git.enable [
      gh
      lazygit
    ]
    ++ lib.optionals hjm.bluetooth.enable [
      blueman
    ]
    ++ lib.optionals hjm.dev.enable (
      (lib.optionals hjm.dev.dotnet [
        dotnet-sdk_8
      ])
      ++ lib.optionals hjm.dev.node [
        nodejs
      ]
      ++ lib.optionals hjm.dev.cc [
        gcc
      ]
      ++ lib.optionals hjm.dev.go [
        go
      ]
      ++ lib.optionals hjm.dev.nixTools [
        nixd # Nix language server
        nixfmt # Nix formatter
        nil # Nix language server
        alejandra # alternate Nix formatter
      ]
      ++ lib.optionals hjm.dev.sqlTools [
        dbeaver-bin # universal SQL client
      ]
    )
    ++ lib.optionals hjm.niri.enable [
      # niri packages
      fuzzel
      wayshot
      wl-clipboard
      wlr-randr
      playerctl
      brightnessctl
      ddcutil # desktop monitor brightness via DDC/CI (shelljar BrightnessService)
      libnotify
      dunst
      grim
      slurp
      wf-recorder
    ];
}
