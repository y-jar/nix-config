{ ... }:
{
  # Fill this out! Same toggles as home.nix but for hjem.
  hjmSettings = {
    # personal [for git]
    name = "PLEASECHANGEME_NAME"; # [CHANGE THIS]
    email = "PLEASECHANGEME_EMAIL"; # [CHANGE THIS]

    # [core]
    shell.enable = true;

    # [experience]
    hyprland.enable = true;
    niri = {
      enable = false;
      shelljar = {
        enable = false; # my quickshell island shell
      };
      noctalia = {
        enable = false; # noctalia desktop shell
      };
    };
    launcher.enable = true;

    # [appstream]
    browsers = {
      enable = true;
      firefox = true;
      librewolf = true;
    };
    terminal.enable = true;
    terminal.font = "IntoneMono Nerd Font"; # options: "IntoneMono Nerd Font" "Monocraft" "Miracode"
    editors = {
      enable = true;
      vscodium.enable = true;
      zed.enable = true;
      obsidian.enable = false;
      nvf.enable = true;
      helix.enable = false;
    };
    discord.enable = false;
    espanso = (import ../espansoconf.nix { enable = false; }); # ~30mib - espanso text expander
    flatpak.enable = false;
    nautilus.enable = true;
    yazi.enable = true;
    ranger.enable = false;
    media.enable = true; # sets media tools + default apps (images, video, audio, archives)
    keepass.enable = true;
    gaming = {
      prism.enable = false;
      heroic.enable = false;
    };

    # [creative]
    art.enable = false;
    office.enable = false;
    obs.enable = false;
    kdenlive.enable = false;

    # [management]
    inputmethods.japanese.enable = false;
    inputmethods.korean.enable = false;
    ai.enable = false;
    git.enable = true;
    bluetooth.enable = false;
    dev.enable = true;

    # [resources]
    resYoink = {
      enable = false;
      wallpapers = false;
      icons = false;
      profilePictures = false;
    };
  };
}
