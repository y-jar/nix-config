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
      nvf.enable = true;
      helix.enable = true;
    };
    discord.enable = true;
    espanso = {
      enable = true; # espanso text expander
      shorts = {
        ":addr" = "123 Jar Street, Warrington";
        ":sig" = "Best,\nJar";
        ":np" = "now playing: $|$";
        ":gitadd" = "git add -A && git commit -m \"$|$\"";
        ":date" = "{{mydate}}";
      };
      vars = [
        {
          name = "mydate";
          type = "date";
          params = {
            format = "%Y-%m-%d";
          };
        }
      ];
    };
    flatpak.enable = false;
    nautilus.enable = true;
    yazi.enable = true;
    ranger.enable = true;
    media.enable = true; # sets media tools + default apps (images, video, audio, archives)
    keepass.enable = true;
    gaming = {
      prism.enable = true;
      heroic.enable = false;
    };

    art.enable = true;
    office.enable = true;
    obs.enable = true;
    kdenlive.enable = false;

    inputmethods.japanese.enable = true;
    inputmethods.korean.enable = true;
    ai.enable = false;
    git.enable = true;
    bluetooth.enable = false;
    dev.enable = true;

    resYoink = {
      enable = true;
      wallpapers = true;
      icons = true;
      profilePictures = true;
    };
  };
}
