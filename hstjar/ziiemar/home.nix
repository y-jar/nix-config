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
      shelljar.enable = false; # my quickshell island shell
      noctalia.enable = false; # noctalia desktop shell
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
      terminal.fontSize = 14; # font size (default: 14)
      syncthing.enable = true; # file sync (web UI at localhost:8384)
      editors = {
        enable = true; # sets all editors
        vscodium.enable = true; # sets vscodium
        zed.enable = true; # sets zed
        obsidian.enable = true; # sets obsidian
        nvf.enable = true; # sets nvf config for neovim [~2G]
        helix.enable = true; # sets helix
      }; # end of editors
      discord.enable = true; # sets discord
      espanso = (import ../espansoconf.nix { }); # espanso text expander
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
      office.enable = true; # sets libreoffice and other apps
      obs.enable = false; # sets up obs studio
      videoEditors = {
        enable = false; # sets video editors
        kdenlive.enable = false; # sets kdenlive
      }; # end of videoEditors
      # =========[creative tools]^^^

      # =========[management]
      inputmethods.japanese.enable = true; # sets japanese input
      inputmethods.korean.enable = false; # sets korean input
      ai.enable = aiEnable; # sets AI tools like opencode, llama.cpp
      dictation.enable = false; # voxtype push-to-talk dictation + meeting/VTT transcript (F9)
      git.enable = true; # sets git
      bluetooth.enable = true; # sets blueman in home packages
      dev.enable = false; # sets dev tools and basic languages
      # =========[management]^^^
      theming = {
        enable = true; # sets theme for gtk/qt
        flavor = "mocha"; # catppuccin flavor (latte|frappe|macchiato|mocha)
        accent = "blue"; # catppuccin accent color
        cursorSize = 36; # cursor size in pixels (default: 36)
      };
      fastfetch.enable = true; # sets fastfetch
    }; # end of usrSettings

    # Drop the OLED panel to 48Hz on battery, 120Hz on AC, to save power.
    systemd.user.services.niri-refresh-on-battery = {
      Unit = {
        Description = "Switch niri eDP-1 refresh rate based on power source";
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        Environment = [ "WAYLAND_DISPLAY=wayland-1" ];
        ExecStart = "${pkgs.writeShellScriptBin "niri-refresh-on-battery" ''
          set -eu
          last=""
          while :; do
            ac=$(cat /sys/class/power_supply/AC/online 2>/dev/null || echo 0)
            if [ "$ac" = "0" ]; then
              mode="2880x1800@48.001"
            else
              mode="2880x1800@120.001"
            fi
            if [ "$mode" != "$last" ]; then
              niri msg output eDP-1 mode "$mode" 2>/dev/null || true
              last="$mode"
            fi
            sleep 10
          done
        ''}/bin/niri-refresh-on-battery";
        Restart = "on-failure";
        RestartSec = 10;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

  }; # end of config
}
