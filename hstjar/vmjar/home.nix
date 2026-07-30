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
      browsers = {
        enable = true; # sets firefox and librewolf [work and personal]
        firefox = false; # disables firefox [work]
        librewolf = true; # enables librewolf [personal]
      };
      terminal.enable = true; # sets terminal as foot
      terminal.font = "IntoneMono Nerd Font"; # options: "IntoneMono Nerd Font" "Monocraft" "Miracode"
      # terminal.fontSize = 14; # font size (default: 14)
      syncthing.enable = true; # file sync (web UI at localhost:8384)
      editors = {
        enable = true; # sets all editors
        vscodium.enable = true; # sets vscodium
        zed.enable = false; # sets zed
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
      japanese.enable = false; # sets japanese input
      ai.enable = aiEnable; # sets AI tools like opencode, ollama
      git.enable = true; # sets git
      bluetooth.enable = false; # sets blueman in home packages
      dev.enable = false; # sets dev tools and basic languages
      # =========[management]^^^
      theming = {
        enable = true; # sets theme for gtk/qt
        # cursorSize = 36; # cursor size in pixels (default: 36)
      };
    }; # end of usrSettings

  }; # end of config
}
