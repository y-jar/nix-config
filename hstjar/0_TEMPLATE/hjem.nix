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
    theming = {
      enable = false; # catppuccin gtk/qt + kvantum + cursor
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
    chatApps = {
      enable = false;
      discord.enable = false;
      halloy.enable = false;
    };
    espanso = (import ../espansoconf.nix { enable = false; }); # ~30mib - espanso text expander
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

    # [resources]
    resYoink = {
      enable = false;
      wallpapers = false;
      icons = false;
      profilePictures = false;
      minecraftSkins = false;
    };
  };
}
