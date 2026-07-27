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
      browsers.enable = true; # sets firefox and librewolf [work and personal]
      terminal.enable = true; # sets terminal as foot
      terminal.font = "IntoneMono Nerd Font"; # options: "IntoneMono Nerd Font" "Monocraft" "Miracode"
      # terminal.fontSize = 14; # font size (default: 14)
      syncthing.enable = false; # file sync (web UI at localhost:8384)
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
      media.enable = true; # sets media tools + default apps (images, video, audio, archives)
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
      ai.enable = aiEnable; # sets AI tools like opencode, ollama
      git.enable = true; # sets git
      bluetooth.enable = true; # sets blueman in home packages
      dev.enable = false; # sets dev tools and basic languages
      # =========[management]^^^
    }; # end of usrSettings

    theming = {
      enable = false; # sets theme for gtk/qt
      # cursorSize = 36; # cursor size in pixels (default: 36)
    }; # end of theming
  }; # end of config
}
