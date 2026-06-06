{ pkgs, ... }:
{

  # ==========================[Enabled User Packages]=====================
  programs.foot.enable = true; # my baby
  # ==========================[User Packages]=============================
  home.packages = with pkgs; [
    # =======[Ness Jar] |>|>|>|>|>|>|>
    # [Base]
    firefox # Web browser for school or work related activities
    librewolf # Prefered browser; Security focused around my personal data
    kitty # incase foot doesnt work for root
    comma # Runs programs without installing them
    wine # Wine is a compatibility layer for running Windows programs on Unix-like systems

    # [File Explorers]
    nautilus # gnome's file manager
    ranger # File manager with minimalistic curses interface
    yazi # Blazing fast terminal file manager written in Rust, based on async I/O
    keepassxc # [passwordmgr]

    # [management]
    bazaar # flatpack app store / manager
    easyeffects # audio mixer
    qpwgraph # Qt graph manager for PipeWire, similar to QjackCtls
    pavucontrol # PulseAudio Volume Control
    gearlever # Manages app images
    # =======[Ness Jar] |>|>|>|>|>|>|>

    # =======[Folding Jar] |>|>|>|>|>|>|>
    # [Text Editors]
    neovim # Vim text editor fork focused on extensibility and agility
    vscodium # editor
    zed-editor # good text editor
    # helix # Post-modern modal text editor
    qownnotes # markdown app editor
    libreoffice # documents writer
    buffer # Minimal editing space for all those things that don't need keeping
    obsidian # Powerful knowledge base that works on top of a local folder of plain text Markdown files

    # [graphics]
    # obs-studio # good video software
    kdePackages.kdenlive # video editor
    halftone # Simple app for giving images that pixel-art style
    krita # Free and open source painting application
    converseen # Batch image converter and resizer
    fontforge # Font editor
    coulr # Color box to help developers and designers
    upscayl # Free and Open Source AI Image Upscaler
    digikam # Photo management application
    evince # PDF viewer + thumbnailer

    # [Other Folds]
    mediawriter # Tool to write images files to portable media
    # =======[Folding Jar] |>|>|>|>|>|>|>

    # =======[Entertainment] |>|>|>|>|>|>|>
    #[Gaming]
    prismlauncher
    heroic # Native GOG, Epic, and Amazon Games Launcher for Linux, Windows and Mac
    mangohud # for huds
    protonup-qt # installer for proton vers

    #[Media]
    blanket # Background noises
    quodlibet # media player
    mpv # for video playback
    gapless # Beautiful, fast, fluent, light weight music player written in GTK4 [but no gaps]
    # =======[Entertainment] |>|>|>|>|>|>|>

    # =======[Looks Jar] |>|>|>|>|>|>|>
    #[cursors]
    bibata-cursors # clean material-style, very popular
    bibata-cursors-translucent # Translucent Varient of the Material Based Cursor
    catppuccin-cursors # matches catppuccin theme
    phinger-cursors # fun colorful ones

    #[UI related]
    noctalia-shell # Sleek and minimal desktop shell thoughtfully crafted for Wayland, built with Quickshell
    tmux # terminal multiplexer [fuck.. i never used this]
    # =======[Looks Jar] |>|>|>|>|>|>|>

    # =======[Dev Jar] |>|>|>|>|>|>|>
    # [cli / tui / tools]
    tldr # Simplified and community-driven man pages
    bat # Cat(1) clone with syntax highlighting and Git integration
    jp # json parser
    fastfetch # Actively maintained, feature-rich and performance oriented, neofetch like system information tool
    btop # Monitor of resources
    fzf # fuzzy finder
    fd # Simple, fast and user-friendly alternative to find
    tree # Command to produce a depth indented directory listing

    # [Academic Project Stack]
    dotnet-sdk_8 # Core functionality needed to create .NET Core projects, that is shared between Visual Studio and CLI (wrapper) (combined) (wrapper)
    php # HTML-embedded scripting language
    mariadb # Enhanced, drop-in replacement for MySQL

    # [Data / Version Control]
    git # virsion control
    lazygit # for kool github viewing
    subversion # Version control system intended to be a compelling replacement for CVS in the open source community

    # [Development Essentials]
    gh # for github login
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
    nwg-look # The best tool for Wayland/Niri GTK styling if it is needed
    lmstudio # for those who want to use AI
    bottles # Easy-to-use wineprefix manager
    waydroid # Container-based approach to boot a full Android system on a regular GNU/Linux system
    cowsay # MOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
    polkit_gnome # for a weird thing for some flatpak thing
    discord # game social app [Will be depricated!]
    # waytrogen # Lightning fast wallpaper setter for Wayland
    # waypaper # use for setting wallpapers for WMs
  ];
}
