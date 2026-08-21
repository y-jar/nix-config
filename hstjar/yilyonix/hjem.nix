# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host yilyonix: hjem toggle sheet (hjmSettings) — WIP.
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
      vscodium.enable = false;
      zed.enable = true;
      obsidian.enable = false;
      nvf.enable = true;
      helix.enable = false;
    };
    discord.enable = false;
    espanso = (import ../espansoconf.nix { }); # espanso text expander
    flatpak.enable = false;
    nautilus.enable = true;
    yazi.enable = true;
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
      prism.enable = false;
      heroic.enable = false;
    };

    art.enable = false;
    office.enable = false;
    obs.enable = false;
    kdenlive.enable = false;

    inputmethods.japanese.enable = true;
    inputmethods.korean.enable = false;
    ai.enable = false;
    git.enable = true;
    bluetooth.enable = true;
    fastfetch.enable = true;
    dev = {
      enable = false; # dev master toggle
      dotnet = false;
      node = false;
      cc = false;
      go = false;
      nixTools = false;
      sqlTools = false;
    };

    resYoink = {
      enable = false;
      wallpapers = false;
      icons = false;
      profilePictures = false;
    };
  };
}
