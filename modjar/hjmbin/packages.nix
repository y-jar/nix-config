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
    ++ lib.optionals hjm.discord.enable [
      discord
    ]
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
    ++ lib.optionals hjm.media.enable [
      constrict # shrinks files
      mpv
      ffmpeg
      blanket
      quodlibet
      gapless
      audacity
      yt-dlp
      loupe # image viewer
      showtime # video player (GNOME)
      file-roller # archive manager (GNOME)
    ]
    ++ lib.optionals hjm.keepass.enable [
      keepassxc
    ]
    ++ lib.optionals hjm.gaming.prism.enable [
      prismlauncher
    ]
    ++ lib.optionals hjm.gaming.heroic.enable [
      heroic
    ]
    ++ lib.optionals hjm.art.enable [
      blender
      krita
      gimp
      inkscape
    ]
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
    ++ lib.optionals hjm.niri.enable [
      # niri packages
      fuzzel
      awww
      wayshot
      wl-clipboard
      wlr-randr
      playerctl
      brightnessctl
      libnotify
      dunst
      grim
      slurp
      wf-recorder
    ];
}
