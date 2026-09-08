# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host vmjar: hjem toggle sheet (hjmSettings) — WIP.
# -=-=-=-=-=-=-=-=-=-=-=
{ ... }:
{
  hjmSettings = {
    name = "y-jar"; # [CHANGE THIS]
    email = "park.7qs@gmail.com"; # [CHANGE THIS]

    shell.enable = true;
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
      firefox = true;
      librewolf = false;
      chromium = true;
      default = "firefox"; # preferred browser: WM Mod+B + default mime browser
    };
    terminal = {
      enable = true;
      font = "IntoneMono Nerd Font"; # options: "IntoneMono Nerd Font" "Monocraft" "Miracode"
      fontSize = 14;
    };
    # syncthing: home-manager only (modjar/usrbin/syncthing.nix) — no hjmbin port yet, skipped here.
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
    flatpak.enable = false;
    nautilus.enable = true;
    yazi.enable = true;
    ranger.enable = false;
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
      dotnet = false;
      node = false;
      cc = false;
      go = false;
      nixTools = false;
      sqlTools = false;
    };

    resYoink = {
      enable = true;
      wallpapers = true;
      icons = true;
      profilePictures = true;
      minecraftSkins = false;
    };
  };
}
