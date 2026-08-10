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
      nvf.enable = false;
      helix.enable = false;
    };
    discord.enable = true;
    flatpak.enable = false;
    nautilus.enable = true;
    yazi.enable = true;
    ranger.enable = true;
    media.enable = true; # sets media tools + default apps (images, video, audio, archives)
    keepass.enable = true;
    gaming = {
      prism.enable = true;
      heroic.enable = true;
    };

    art.enable = true;
    office.enable = true;
    obs.enable = true;
    kdenlive.enable = true;

    inputmethods.japanese.enable = true;
    ai.enable = false;
    git.enable = true;
    bluetooth.enable = true;
    dev.enable = true;

    resYoink.enable = false;
  };
}
