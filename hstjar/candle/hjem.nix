# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host candle: hjem toggle sheet (hjmSettings) — WIP.
# -=-=-=-=-=-=-=-=-=-=-=
{ ... }:
{
  hjmSettings = {
    name = "y-jar"; # [CHANGE THIS]
    email = "park.7qs@gmail.com"; # [CHANGE THIS]

    shell.enable = true;
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
    theming = {
      enable = true;
      flavor = "mocha";
      accent = "blue";
      cursorSize = 36;
    };

    browsers = {
      enable = true;
      firefox = true;
      librewolf = true;
      chromium = true;
    };
    terminal = {
      enable = true;
      font = "IntoneMono Nerd Font"; # options: "IntoneMono Nerd Font" "Monocraft" "Miracode"
      fontSize = 14;
    };
    editors = {
      enable = true;
      vscodium.enable = true;
      zed.enable = true;
      obsidian.enable = false;
      nvf.enable = true;
      helix.enable = false;
    };
    discord.enable = true;
    espanso = (import ../espansoconf.nix { }); # espanso text expander
    flatpak.enable = false;
    nautilus.enable = true;
    yazi.enable = false;
    ranger.enable = false;
    media = {
      enable = true; # media master toggle
      mpv = true;
      downloaders = true;
      musicApps = true;
      audioEditor = true;
      viewers = true;
      defaultApps = true;
    };
    keepass.enable = true;
    gaming = {
      prism.enable = true;
      heroic.enable = true;
    };

    art.enable = false;
    office.enable = false;
    obs.enable = true;
    kdenlive.enable = false;

    inputmethods.japanese.enable = true;
    inputmethods.korean.enable = false;
    ai.enable = false;
    git.enable = true;
    bluetooth.enable = false;
    fastfetch.enable = true;
    dev = {
      enable = true; # dev master toggle
      dotnet = true;
      node = true;
      cc = true;
      go = true;
      nixTools = true;
      sqlTools = true;
    };

    resYoink = {
      enable = false;
      wallpapers = false;
      icons = false;
      profilePictures = false;
    };
  };
}
