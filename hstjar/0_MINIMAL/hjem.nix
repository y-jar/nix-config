# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host 0_MINIMAL: hjem toggle sheet (hjmSettings).
# -=-=-=-=-=-=-=-=-=-=-=
{ ... }:
{
  # Fill this out! Same toggles as home.nix but for hjem (lean defaults).
  hjmSettings = {
    # personal [for git]
    name = "PLEASECHANGEME_NAME"; # [CHANGE THIS]
    email = "PLEASECHANGEME_EMAIL"; # [CHANGE THIS]

    # [core]
    shell.enable = true;

    # [experience]
    hyprland.enable = false;
    niri = {
      enable = false;
      shelljar = {
        enable = false; # my quickshell island shell
      };
      noctalia = {
        enable = false; # noctalia desktop shell
      };
    };
    mango = {
      enable = true; # default WM on the minimal host
      shelljar = {
        enable = false; # raw mango, no desktop shell (minimal)
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
      firefox = true; # keep only firefox (drop librewolf/chromium to save ~1.5GiB)
      librewolf = false;
      chromium = false;
      # default = "firefox"; # preferred browser: WM Mod+B + default mime browser
    };
    terminal = {
      enable = true;
      font = "IntoneMono Nerd Font";
      fontSize = 14;
    };
    editors = {
      enable = false; # OFF
      vscodium.enable = false;
      zed.enable = false;
      obsidian.enable = false;
      nvf.enable = true; # keep neovim config
      helix.enable = false;
    };
    chatApps = {
      enable = false;
      discord.enable = false;
      halloy.enable = false;
    };
    espanso = (import ../espansoconf.nix { enable = false; });
    flatpak.enable = false;
    nautilus.enable = true;
    yazi.enable = true;
    ranger.enable = false;
    media = {
      enable = false; # OFF
      mpv = false;
      downloaders = false;
      musicApps = false;
      audioEditor = false;
      viewers = false;
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
      enable = false; # OFF: no dev toolchains
      dotnet = false;
      node = false;
      cc = false;
      go = false;
      nixTools = true;
      sqlTools = false;
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
