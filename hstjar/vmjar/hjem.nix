{ ... }:
{
  hjmSettings = {
    name = "y-jar"; # [CHANGE THIS]
    email = "park.7qs@gmail.com"; # [CHANGE THIS]

    shell.enable = true;
    hyprland.enable = true;
    niri.enable = false;
    launcher.enable = true;

    browsers = {
      enable = true;
      firefox = false;
      librewolf = true;
    };
    terminal.enable = true;
    editors = {
      enable = true;
      vscodium.enable = true;
      zed.enable = false;
      obsidian.enable = false;
      nvf.enable = true;
      helix.enable = false;
    };
    discord.enable = false;
    flatpak.enable = false;
    nautilus.enable = true;
    yazi.enable = true;
    ranger.enable = false;
    media.enable = true;
    keepass.enable = true;
    gaming = {
      prism.enable = false;
      heroic.enable = false;
    };

    art.enable = false;
    office.enable = false;
    obs.enable = false;
    kdenlive.enable = false;

    japanese.enable = false;
    ai.enable = false;
    git.enable = true;
    bluetooth.enable = false;
    dev.enable = false;

    resYoink.enable = false;
  };
}
