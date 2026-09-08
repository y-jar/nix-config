# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host 0_MINIMAL: hjem toggle sheet (hjmSettings) — WIP.
# -=-=-=-=-=-=-=-=-=-=-=
{ ... }:
{
  hjmSettings = {
    name = "PLEASECHANGEME_NAME"; # [CHANGE THIS]
    email = "PLEASECHANGEME_EMAIL"; # [CHANGE THIS]

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
    mango = {
      enable = true; # mango (mangowm) — default WM on this minimal host
      shelljar = {
        enable = false; # my quickshell island shell
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
      firefox = true; # keep only firefox (drop librewolf/chromium to save ~1.5GiB)
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
      enable = false; # OFF: no vscodium/zed/obsidian
      vscodium.enable = false;
      zed.enable = false;
      obsidian.enable = false;
      nvf.enable = true; # keep neovim config (small-ish)
      helix.enable = false;
    };
    chatApps = {
      enable = false; # OFF: no discord/halloy (saves ~380mib)
      discord.enable = false;
      halloy.enable = false;
    };
    espanso = (import ../espansoconf.nix { enable = false; }); # espanso text expander
    flatpak.enable = false;
    nautilus.enable = true;
    yazi.enable = true;
    ranger.enable = false;
    media = {
      enable = false; # OFF: minimal media
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
      enable = true; # sets AI tools like opencode, llama.cpp
      opencode.enable = true; # opencode (NON-local models only)
      lmstudio.enable = false; # no LM Studio (saves ~2.3GiB)
    };
    dictation.enable = false;
    git.enable = true;
    bluetooth.enable = false;
    fastfetch.enable = true;
    dev = {
      enable = false; # OFF: no dev toolchains
      dotnet = false;
      node = false;
      cc = false;
      go = false;
      nixTools = true; # keep nix tooling (comes with this repo)
      sqlTools = false;
    };

    resYoink = {
      enable = false; # resources OFF (~300+mib)
      wallpapers = false;
      icons = false;
      profilePictures = false;
      minecraftSkins = false;
    };
  };
}
