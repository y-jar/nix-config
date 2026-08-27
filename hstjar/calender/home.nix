# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host calender: user-level toggle sheet (usrSettings) for home-manager.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  pkgs,
  gnomeEnable,
  hyprlandEnable,
  niriEnable,
  aiEnable,
  ...
}:

{
  config = {
    home.stateVersion = "26.05"; # [CHANGE THIS]

    # Fill this out!
    usrSettings = {
      name = "y-jar"; # [CHANGE THIS] for git
      email = "park.7qs@gmail.com"; # [CHANGE THIS] for git

      # core [users, shell, basic things]
      # enables zsh shell with aliases [should be on by default]
      shell = {
        enable = true;
      };

      # =========[experience] [pick one or more if you know what you're doing]
      # gnome.enable = gnomeEnable;
      hyprland.enable = hyprlandEnable;
      niri.enable = niriEnable;
      # [desktop shell] pick one: noctalia (default) or shelljar (my quickshell island shell)
      shelljar.enable = true; # my quickshell island shell
      noctalia.enable = false; # disable noctalia on calender (shelljar replaces it)
      # [epr plus]
      launcher.enable = true; # sets launcher fuzzel
      resYoink = {
        enable = true;
        wallpapers = true;
        icons = true;
        profilePictures = true;
      };
      # =========[experience]^^^

      # =========[appstream]
      browsers = {
        enable = true; # sets firefox and librewolf [work and personal]
        firefox = true; # disables firefox [work]
        librewolf = true; # enables librewolf [personal] [the default is `true`]
        chromium = true; # enables chromium [personal] [the default is `true`]
      }; # end of browsers
      terminal.enable = true; # sets terminal as foot
      terminal.font = "Monocraft"; # options: "IntoneMono Nerd Font" "Monocraft" "Miracode"
      terminal.fontSize = 12; # font size (default: 14)
      syncthing.enable = true; # file sync (web UI at localhost:8384)
      editors = {
        enable = true; # sets editors
        vscodium.enable = true; # sets vscodium
        zed.enable = true; # sets zed
        obsidian.enable = true; # sets obsidian
        helix.enable = true; # sets helix
        nvf.enable = true; # sets nvf config for neovim
      }; # end of editors
      chatApps = {
        enable = true;
        discord.enable = true;
        halloy.enable = true;
      };
      espanso = (import ../espansoconf.nix { enable = true; }); # espanso text expander
      flatpak.enable = true; # sets flatpak and adds bazaar
      # [file explorers]
      nautilus.enable = true; # sets nautilus
      yazi.enable = true; # sets yazi
      ranger.enable = true; # sets ranger
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
        prism.enable = true; # sets prismlauncher [minecraft]
        heroic.enable = true; # sets heroic [gog, epic.. other]
      }; # end of gaming
      # =========[appstream]^^^

      # =========[creative tools]
      art = {
        enable = true; # art master toggle
        imageTools = true; # krita, gimp, inkscape, ...
        threeD = true; # blender, blockbench
        astronomy = true; # stellarium, celestia
      };
      # godot.enable = true; # sets godot
      office.enable = true; # sets libreoffice and other apps
      obs.enable = true; # sets up obs studio
      videoEditors = {
        enable = false; # video editors master toggle
        kdenlive.enable = false; # Kdenlive
      };
      # =========[creative tools]^^^

      # =========[management]
      inputmethods.japanese.enable = true; # sets japanese input
      inputmethods.korean.enable = false; # sets korean input
      ai.enable = aiEnable; # sets AI tools like opencode, llama.cpp
      dictation.enable = true; # push-to-talk dictation + meeting/VTT transcript (voxtype, F9)
      git.enable = true; # sets git
      bluetooth.enable = false; # sets blueman in home packages
      dev = {
        enable = true; # dev master toggle
        dotnet = true; # dotnet SDK
        node = true; # nodejs
        cc = true; # gcc
        go = true; # go
        nixTools = true; # nix language servers + formatters
        sqlTools = true; # dbeaver
      };
      # =========[management]^^^
      theming = {
        enable = true; # sets theme for gtk/qt
        flavor = "mocha"; # catppuccin flavor (latte|frappe|macchiato|mocha)
        accent = "blue"; # catppuccin accent color
        cursorSize = 48; # cursor size in pixels (default: 36)
      };
      fastfetch.enable = true; # sets fastfetch
    }; # end of usrSettings

  }; # end of config
}
