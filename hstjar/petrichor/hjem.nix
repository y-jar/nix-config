# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host petrichor: hjem toggle sheet (hjmSettings) — WIP.
# -=-=-=-=-=-=-=-=-=-=-=
{ ... }:
{
  hjmSettings = {
    name = "kway"; # [CHANGE THIS]
    email = "kwayckyle@gmail.com"; # [CHANGE THIS]

    shell.enable = true;
    hyprland.enable = false;
    niri = {
      enable = true;
      shelljar = {
        enable = true; # my quickshell island shell
      };
      noctalia = {
        enable = false; # noctalia desktop shell
      };
    };
    mango = {
      enable = true; # mango (mangowm)
      shelljar = {
        enable = true; # my quickshell island shell
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
      librewolf = false;
      chromium = false;
      default = "firefox"; # preferred browser: WM Mod+B + default mime browser
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
    chatApps = {
      enable = true;
      discord.enable = true;
      halloy.enable = false;
    };
    espanso = (import ../espansoconf.nix { enable = false; }); # espanso text expander
    flatpak.enable = true;
    nautilus.enable = true;
    yazi.enable = true;
    ranger.enable = false;
    media = {
      enable = true;
      mpv = true;
      downloaders = false;
      musicApps = true;
      audioEditor = false;
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
      threeD = false;
      astronomy = true;
    };
    office.enable = true;
    obs.enable = true;
    kdenlive.enable = false;

    inputmethods.japanese.enable = false;
    inputmethods.korean.enable = false;
    ai = {
      enable = false; # sets AI tools like opencode, llama.cpp
      opencode.enable = true; # opencode CLI + GUI (keep even if local llama is off)
      lmstudio.enable = false; # LM Studio (~2.3GiB) — set false to save space
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
      sqlTools = false;
    };

    resYoink = {
      enable = true;
      wallpapers = true;
      icons = true;
      profilePictures = false;
      minecraftSkins = false;
    };
  };
}
