{ pkgs, ... }:
{
  # ==========================User Packages=============================
  # My PACKAGES, How epic, just be sure to add pkgs. before each package name <3
  # Note, check home-jar/app-bin/ for apps, there might be some that arnt showing up here
  home.packages = with pkgs; [
    # =======[Ness Jar] >>>>>>>>>>>>>>>>>>>>>>>
      # [Base]
      firefox
      librewolf # Prefered browser; Security focused
      bazaar # flatpack app store [software center is in display.nix]
      gearlever # Manages app images

      # [File Explorers]
      nautilus # gnome's file manager
      ranger # tui file explorer
      thunar # Xfce file manager

      # [management]
      easyeffects # audio mixer
      qpwgraph # Qt graph manager for PipeWire, similar to QjackCtls
      pavucontrol # PulseAudio Volume Control
    # =======[Ness Jar] >>>>>>>>>>>>>>>>>>>>>>>
		
    # =======[Folding Jar] |>|>|>|>|>|>|>
      # [Text Editors]
      vscodium # editor
      zed-editor # good text editor
      helix # Post-modern modal text editor
      qownnotes # markdown app editor
      libreoffice # documents writer
      onlyoffice-desktopeditors # Office suite that combines text, spreadsheet and presentation editors allowing to create, view and edit local documents
      buffer # Minimal editing space for all those things that don't need keeping

      # [graphics]
      obs-studio # good video software
      kdePackages.kdenlive # video editor
      halftone # Simple app for giving images that pixel-art style
      krita # Free and open source painting application
      converseen # Batch image converter and resizer
      fontforge # Font editor
      coulr # Color box to help developers and designers
      upscaler # Upscale and enhance images
      upscayl # Free and Open Source AI Image Upscaler
      digikam # Photo management application

      # [Other Folds]
      mediawriter # Tool to write images files to portable media
    # =======[Folding Jar] |>|>|>|>|>|>|>

    # =======[End Jar] |>|>|>|>|>|>|>
      # -[Gaming]
      # stuff like! heroic, steam, prismlauncher WOW how awesome me, such a gaymer
      protonplus # manager and installer for proton versions
      protontricks # adds tricks for proton for additional preformance [right now it doesnt work...]
      steam # gaming app
      #prismlauncher
      mangohud # for huds
      protonup-qt # installer for proton vers

      # -[Media]
      blanket # Background noises
      quodlibet # media player
      mpv # for video playback
      gapless # Beautiful, fast, fluent, light weight music player written in GTK4 [but no gaps]
    # =======[Ent Jar] |>|>|>|>|>|>|>

    # =======[Looks Jar] (+(+++++(+(+(++())))))
      #[cursors]
      bibata-cursors # clean material-style, very popular
      bibata-cursors-translucent # Translucent Varient of the Material Based Cursor
      catppuccin-cursors # matches catppuccin theme
      phinger-cursors # fun colorful ones

      #[Icons]
      catppuccin-papirus-folders # papirus but with catppuccin colored folders
      adwaita-icon-theme # gnome default, good fallback
      numix-icon-theme-circle # circular icons

      # [UI related]
      noctalia-shell # Sleek and minimal desktop shell thoughtfully crafted for Wayland, built with Quickshell
    # =======[Looks Jar] (+(+++++(+(+(++())))))

    # =======[Dev Jar] |>|>|>|>|>|>|>
      # [Academic Project Stack]
      dotnet-sdk_8 # Core functionality needed to create .NET Core projects, that is shared between Visual Studio and CLI (wrapper) (combined) (wrapper)
      php # HTML-embedded scripting language
      mariadb # Enhanced, drop-in replacement for MySQL
      
      # [Development Essentials]
      python315 # latest i can get
      rustc # Safe, concurrent, practical language (wrapper script)
      cargo # Downloads your Rust project's dependencies and builds your project
      nodejs # Event-driven I/O framework for the V8 JavaScript engine
      gcc # GNU Compiler Collection, version 15.2.0 (wrapper script)
      go # Go Programming language
      nil # Yet another language server for Nix
      nixd # Feature-rich Nix language server interoperating with C++ nix

      # [Technical Writing]
      pandoc # Conversion between documentation formats
      
      # [Database GUI (optional but helpful for ERD work)]
      dbeaver-bin # Universal SQL Client for developers, DBA and analysts. Supports MySQL, PostgreSQL, MariaDB, SQLite, and more
    # =======[Dev Jar] |>|>|>|>|>|>|>

    # ====Unsorteds====
    nwg-look  # The best tool for Wayland/Niri GTK styling if it is needed
    lmstudio # for those who want to use AI
    bottles # Easy-to-use wineprefix manager
    waydroid # Container-based approach to boot a full Android system on a regular GNU/Linux system
		cowsay # MOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
		lazygit # for kool github viewing
		polkit_gnome # for a weird thing for some flatpak thing
		gh # for github login
    discord # game social app [Will be depricated!]
  ];  
}