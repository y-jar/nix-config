#*/-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Hi this is the user configuration file for the picked host.
#
# And remember, your configuration is yours to customize.
# After you're done, head over to ./system.nix to configure your system!
#
# Some notes for new systems:
# 1. try to avoid disabling shell. It's the default shell for most systems.
# 2. enable and disable only what you need.
# 3. for hyprland and niri, there are some files you can tweak in modjar/usrbin for
#   per system configuration. There is an unknown default to prevent issues.
#*/-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
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
    home.stateVersion = "HomeManagerVersionNumber"; # [CHANGE THIS]

    # Fill this out!
    usrSettings = {
      name = "PLEASECHANGEME_NAME"; # [CHANGE THIS] for git
      email = "PLEASECHANGEME_EMAIL"; # [CHANGE THIS] for git

      # core [users, shell, basic things]
      # enables zsh shell with aliases [should be on by default]
      shell = {
        enable = true;
      };

      # =========[experience] [pick one or more if you know what you're doing] [sIZES ARE APPROXIMATE]
      # gnome.enable = gnomeEnable;
      hyprland.enable = hyprlandEnable;
      niri.enable = niriEnable;
      # [epr plus]
      launcher.enable = true; # ~10mib - sets launcher fuzzel
      resYoink = {
        enable = false; # symlinks resources into ~/resjar/ [~300+mib for wallpapers]
        wallpapers = false;
        icons = false;
        profilePictures = false;
      };
      # =========[experience]^^^

      # =========[appstream]
      browsers = {
        enable = true; # ~500mib - librewolf + firefox
        firefox = false; # disables firefox [work]
        librewolf = true; # enables librewolf [personal]
      };
      terminal.enable = true; # ~30mib - sets terminal as foot + kitty + alacritty
      terminal.font = "IntoneMono Nerd Font"; # options: "IntoneMono Nerd Font" "Monocraft" "Miracode"
      syncthing.enable = false; # file sync (web UI at localhost:8384)
      editors = {
        enable = true; # ~600mib - VSCodium + Zed + Obsidian + Helix + NVF
        vscodium.enable = true; # ~300mib
        zed.enable = true; # ~200mib
        obsidian.enable = false; # ~200mib
        nvf.enable = true; # ~200mib - neovim config
        helix.enable = false; # ~20mib
      }; # end of editors
      discord.enable = false; # ~300mib
      flatpak.enable = false; # ~10mib - flatpak + bazaar
      # [file explorers]
      nautilus.enable = true; # ~50mib
      yazi.enable = true; # ~10mib
      ranger.enable = false; # ~20mib
      # [media]
      media.enable = true; # ~200mib - mpv + ffmpeg + music players
      keepass.enable = true; # ~100mib
      gaming = {
        prism.enable = false; # ~200mib - Prism Launcher [minecraft]
        heroic.enable = false; # ~300mib - Heroic [gog, epic.. other]
      }; # end of gaming
      # =========[appstream]^^^

      # =========[creative tools]
      art.enable = false; # ~3gib - Blender + Krita + GIMP + Inkscape + more
      # godot.enable = true; # ~500mib
      office.enable = false; # ~800mib - LibreOffice + Pandoc
      obs.enable = false; # ~400mib - OBS Studio + plugins
      videoEditors.kdenlive.enable = false; # ~400mib
      # =========[creative tools]^^^

      # =========[management]
      japanese.enable = false; # ~100mib - fcitx5 + Mozc
      ai.enable = aiEnable; # ~1.5gib - LM Studio + opencode-desktop
      git.enable = true; # ~10mib - git + gh + lazygit
      bluetooth.enable = false; # ~5mib - blueman
      dev.enable = true; # ~1.5gib - dotnet + python + node + gcc + go + nix tools
      # =========[management]^^^
    }; # end of usrSettings

    theming = {
      enable = true; # sets theme for gtk/qt
    }; # end of theming
  }; # end of config
}
