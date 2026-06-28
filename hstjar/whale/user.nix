{
  config,
  pkgs,
  gnomeEnable,
  hyprlandEnable,
  niriEnable,
  ...
}:

{
  config = {
    # Fill this out!
    usrSettings = {
      # core [users, shell, basic things]
      # enables zsh shell with aliases [should be on by default]
      shell = {
        enable = true;
      };

      # =========[experience] [pick one or more if you know what you're doing]
      # gnome.enable = gnomeEnable;
      hyprland.enable = hyprlandEnable;
      niri.enable = niriEnable;
      # [epr plus]
      launcher.enable = true; # sets launcher fuzzel
      addMyWalls.enable = true; # sets my wallpapers [off by default]
      # =========[experience]^^^

      # =========[appstream]
      browsers.enable = true; # sets firefox and librewolf [work and personal]
      terminal.enable = true; # sets terminal as foot
      editors = {
        enable = true; # sets all editors
        vscodium.enable = true; # sets vscodium
        zed.enable = true; # sets zed
        obsidian.enable = false; # sets obsidian
        nvf.enable = true; # sets nvf config for neovim [~2G]
      }; # end of editors
      discord.enable = false; # sets discord
      flatpak.enable = false; # sets flatpak and adds bazaar
      # [file explorers]
      nautilus.enable = true; # sets nautilus
      yazi.enable = true; # sets yazi
      ranger.enable = false; # sets ranger
      # [media]
      media.enable = true; # sets media tools like mpv
      keepass.enable = true; # sets keepassxc
      gaming = {
        prism.enable = false; # sets prismlauncher [minecraft]
        heroic.enable = false; # sets heroic [gog, epic.. other]
      }; # end of gaming
      # =========[appstream]^^^

      # =========[creative tools]
      art.enable = false; # sets krita, blender +
      # godot.enable = true; # sets godot
      office.enable = false; # sets libreoffice and other apps
      obs.enable = false; # sets up obs studio
      videoEditors.kdenlive.enable = false; # sets kdenlive
      # =========[creative tools]^^^

      # =========[management]
      japanese.enable = true; # sets japanese input
      ai.enable = false; # sets AI tools like LMstudio
      git.enable = true; # sets git
      bluetooth.enable = true; # sets blueman in home packages
      dev.enable = false; # sets dev tools and basic languages
      # =========[management]^^^
    }; # end of usrSettings

    theming = {
      enable = false; # sets theme for gtk/qt
    }; # end of theming
  }; # end of config
}
