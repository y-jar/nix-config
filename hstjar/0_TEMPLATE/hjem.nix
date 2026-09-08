# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host 0_TEMPLATE: hjem toggle sheet (hjmSettings) — WIP.
# -=-=-=-=-=-=-=-=-=-=-=
{ ... }:
{
  hjmSettings = {
    name = "PLEASECHANGEME_NAME"; # [CHANGE THIS]
    email = "PLEASECHANGEME_EMAIL"; # [CHANGE THIS]

    shell.enable = true;
    hyprland.enable = false;
    niri = {
      enable = true;
      shelljar = {
        enable = false; # my quickshell island shell
      };
      noctalia = {
        enable = false; # noctalia desktop shell
      };
    };
    mango.enable = false; # mango (mangowm)
    launcher.enable = true;
    theming = {
      enable = true;
      flavor = "mocha";
      accent = "blue";
      cursorSize = 36;
    };

    browsers = {
      enable = true;
      firefox = false;
      librewolf = false;
      chromium = false;
      default = "firefox"; # preferred browser: WM Mod+B + default mime browser
    };
    terminal = {
      enable = true;
      font = "IntoneMono Nerd Font"; # options: "IntoneMono Nerd Font" "Monocraft" "Miracode"
      fontSize = 14;
    };
    editors = {
      enable = true;
      vscodium.enable = true;
      zed.enable = false;
      obsidian.enable = false;
      nvf.enable = true;
      helix.enable = false;
    };
    chatApps = {
      enable = true;
      discord.enable = true;
      halloy.enable = true;
    };
    espanso = (import ../espansoconf.nix { enable = false; }); # espanso text expander
    flatpak.enable = false;
    nautilus.enable = true;
    yazi.enable = true;
    ranger.enable = false;
    media = {
      enable = true;
      mpv = true;
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

    art = {
      enable = false;
      imageTools = false;
      threeD = false;
      astronomy = false;
    };
    office.enable = false;
    obs.enable = false;
    kdenlive.enable = false;

    inputmethods.japanese.enable = false;
    inputmethods.korean.enable = false;
    ai = {
      enable = false; # sets AI tools like opencode, llama.cpp
      opencode.enable = true; # opencode CLI + GUI (keep even if local llama is off)
      lmstudio.enable = true; # LM Studio (~2.3GiB) — set false to save space
    };
    dictation.enable = false;
    git.enable = true;
    bluetooth.enable = false;
    fastfetch.enable = true;
    dev = {
      enable = false;
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
      minecraftSkins = false;
    };
  };
}
