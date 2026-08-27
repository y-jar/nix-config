# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host 0_TEMPLATE: hjem toggle sheet (hjmSettings) — WIP.
# -=-=-=-=-=-=-=-=-=-=-=
{ ... }:
{
  # Fill this out! Same toggles as home.nix but for hjem.
  hjmSettings = {
    # personal [for git]
    name = "y-jar"; # [CHANGE THIS]
    email = "park.7qs@gmail.com"; # [CHANGE THIS]

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
    theming = {
      enable = true; # catppuccin gtk/qt + kvantum + cursor
      flavor = "mocha";
      accent = "blue";
      cursorSize = 36;
    };

    # [appstream]
    browsers = {
      enable = true;
      firefox = true;
      librewolf = true;
      chromium = true;
    };
    terminal = {
      enable = true;
      font = "monocraft"; # options: "IntoneMono Nerd Font" "Monocraft" "Miracode"
      fontSize = 16;
    };
    editors = {
      enable = true;
      vscodium.enable = true;
      zed.enable = false;
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
    media = {
      enable = true; # media master toggle
      mpv = true;
      downloaders = true;
      musicApps = false;
      audioEditor = true;
      viewers = true;
      defaultApps = true;
    };
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
    inputmethods.japanese.enable = true;
    inputmethods.korean.enable = false;
    ai.enable = false;
    git.enable = true;
    bluetooth.enable = false;
    fastfetch.enable = true;
    dev = {
      enable = true; # dev master toggle
      dotnet = false;
      node = false;
      cc = false;
      go = false;
      nixTools = true;
      sqlTools = false;
    };

    # [resources]
    resYoink = {
      enable = true;
      wallpapers = true;
      icons = true;
      profilePictures = true;
    };
  };
}
