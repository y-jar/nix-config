{ pkgs, ... }:
{
  # ==========================User Packages=============================
  # My PACKAGES, How epic, just be sure to add pkgs. before each package name <3
  # Note, check home-jar/app-bin/ for apps, there might be some that arnt showing up here
  home.packages = with pkgs; [
    # [Base]
		firefox
    librewolf # prefered browser
    bazaar # flatpack app store [software center is in display.nix]
    gearlever # manages app images

    # [File Explorers]
		nautilus # gnome' file manager
    ranger # tui file explorer
    xfce.thunar # Xfce file manager    
		
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

    # [Other Folds]
    mediawriter # Tool to write images files to portable media

    # [management]
    easyeffects # audio mixer
    qpwgraph # Qt graph manager for PipeWire, similar to QjackCtls
    pavucontrol # PulseAudio Volume Control

    # [Entertainment]
    # -[Gaming]
    # stuff like! heroic, steam, prismlauncher WOW how awesome me, such a gaymer
    protonplus # manager and installer for proton versions
    protontricks # adds tricks for proton for additional preformance [right now it doesnt work...]
    steam # gaming app
    #prismlauncher

    # -[Media]
    blanket # Background noises
    quodlibet # media player
    mpv # for video playback
    gapless # Beautiful, fast, fluent, light weight music player written in GTK4

    # [My Cursors! / Icons! / +!]
    nwg-look  # The best tool for Wayland/Niri GTK styling if it is needed		
    #[cursors]
    bibata-cursors # clean material-style, very popular
    bibata-cursors-translucent # Translucent Varient of the Material Based Cursor
    catppuccin-cursors # matches catppuccin theme
    phinger-cursors # fun colorful ones
    #[Icons]
    catppuccin-papirus-folders # papirus but with catppuccin colored folders
    adwaita-icon-theme # gnome default, good fallback
    numix-icon-theme-circle # circular icons

    # [keyboard / language]
    fcitx5 # for typing in japanese?
    fcitx5-mozc # other japan language sturff


    # ====Unsorteds====
    lmstudio # for those who want to use AI
    bottles # Easy-to-use wineprefix manager
    waydroid # Container-based approach to boot a full Android system on a regular GNU/Linux system
		cowsay
		lazygit # for kool github viewing
		polkit_gnome # for a weird thing for some flatpak thing
		gh # for github login
    discord # game social app [Will be depricated!]
  ];  
}