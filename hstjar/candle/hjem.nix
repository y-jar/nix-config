{ ... }:
{
  hjmSettings = {
    name = "jar"; # [CHANGE THIS]
    email = "park.7qs@gmail.com"; # [CHANGE THIS]

    shell.enable = true;
    hyprland.enable = true;
    niri.enable = false;
    launcher.enable = true;

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
    discord.enable = true;
    flatpak.enable = false;
    nautilus.enable = true;
    yazi.enable = false;
    ranger.enable = false;
    media.enable = true;
    keepass.enable = true;
    gaming = {
      prism.enable = true;
      heroic.enable = true;
    };

    art.enable = false;
    office.enable = false;
    obs.enable = true;
    kdenlive.enable = false;

    japanese.enable = true;
    ai.enable = false;
    git.enable = true;
    bluetooth.enable = false;
    dev.enable = true;

    resYoink.enable = false;
  };
}
