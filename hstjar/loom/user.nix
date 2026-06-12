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
      # =========[experience]^^^

      # =========[appstream]
      browsers.enable = true; # sets firefox and librewolf [work and personal]
      terminal.enable = true; # sets terminal as foot
      editors = {
        enable = false; # sets all editors
        vscodium.enable = true; # sets vscodium
        zed.enable = true; # sets zed
        obsidian.enable = true; # sets obsidian
      }; # end of editors
      discord.enable = true; # sets discord
      flatpak.enable = false; # sets flatpak and adds bazaar
      # [file explorers]
      nautilus.enable = true; # sets nautilus
      yazi.enable = true; # sets yazi
      ranger.enable = true; # sets ranger
      # [media]
      media.enable = true; # sets media tools like mpv
      keepass.enable = true; # sets keepassxc
      gaming = {
        prism.enable = true; # sets prismlauncher [minecraft]
        heroic.enable = true; # sets heroic [gog, epic.. other]
      }; # end of gaming
      # =========[appstream]^^^

      # =========[creative tools]
      art.enable = true; # sets krita, blender +
      # godot.enable = true; # sets godot
      office.enable = true; # sets libreoffice and other apps
      obs.enable = true; # sets up obs studio
      kdenlive.enable = true; # sets kdenlive
      # =========[creative tools]^^^

      # =========[management]
      japanese.enable = true; # sets japanese input
      ai.enable = true; # sets AI tools like LMstudio
      git.enable = true; # sets git
      bluetooth.enable = true; # sets blueman in home packages
      dev.enable = true; # sets dev tools and basic languages
      # =========[management]^^^
    }; # end of usrSettings

    theming = {
      enable = true; # sets theme for gtk/qt
    }; # end of theming
  }; # end of config
}
