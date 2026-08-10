{ ... }:
{
  hjmSettings = {
    name = "y-jar"; # [CHANGE THIS]
    email = "park.7qs@gmail.com"; # [CHANGE THIS]

    shell.enable = true;
    hyprland.enable = false;
    niri.enable = true;
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
      obsidian.enable = true;
      nvf.enable = true;
      helix.enable = true;
    };
    discord.enable = true;
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

    art.enable = false;
    office.enable = true;
    obs.enable = false;
    kdenlive.enable = false;

    inputmethods.japanese.enable = true;
    ai.enable = false;
    git.enable = true;
    bluetooth.enable = true;
    dev.enable = true;

    resYoink.enable = false;
  };
}
