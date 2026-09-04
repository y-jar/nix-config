# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host calender: hjem toggle sheet (hjmSettings) — WIP.
# -=-=-=-=-=-=-=-=-=-=-=
{ ... }:
{
  hjmSettings = {
    name = "y-jar"; # [CHANGE THIS]
    email = "park.7qs@gmail.com"; # [CHANGE THIS]

    shell.enable = true;
    hyprland.enable = false;
    niri = {
      enable = true;
      shelljar = {
        enable = false; # my quickshell island shell
      };
      noctalia = {
        enable = true; # noctalia desktop shell
      };
    };
    launcher.enable = true;
    theming = {
      enable = true;
      flavor = "mocha";
      accent = "blue";
      cursorSize = 48;
    };

    browsers = {
      enable = true;
      firefox = true;
      librewolf = true;
      chromium = true;
      default = "firefox"; # preferred browser: WM Mod+B + default mime browser
    };
    terminal = {
      enable = true;
      font = "Monocraft"; # options: "IntoneMono Nerd Font" "Monocraft" "Miracode"
      fontSize = 12;
    };
    editors = {
      enable = true;
      vscodium.enable = true;
      zed.enable = true;
      obsidian.enable = true;
      nvf.enable = true;
      helix.enable = true;
    };
    chatApps = {
      enable = true;
      discord.enable = true;
      halloy.enable = true;
    };
    espanso = (import ../espansoconf.nix { }); # espanso text expander
    flatpak.enable = true;
    nautilus.enable = true;
    yazi.enable = true;
    ranger.enable = true;
    media = {
      enable = true;
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

    art = {
      enable = true;
      imageTools = true;
      threeD = true;
      astronomy = true;
    };
    office.enable = true;
    obs.enable = true;
    kdenlive.enable = false;

    inputmethods.japanese.enable = true;
    inputmethods.korean.enable = false;
    ai.enable = false;
    dictation.enable = true;
    git.enable = true;
    bluetooth.enable = false;
    fastfetch.enable = true;
    dev = {
      enable = true;
      dotnet = true;
      node = true;
      cc = true;
      go = true;
      nixTools = true;
      sqlTools = true;
    };

    resYoink = {
      enable = true;
      wallpapers = true;
      icons = true;
      profilePictures = true;
      minecraftSkins = true;
    };
  };
}
