# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host 0_MINIMAL: lean user toggle sheet (usrset) shared by both backends.
# -=-=-=-=-=-=-=-=-=-=-=
# Bare essentials: shell + terminal + a browser + opencode (non-local AI).
# Heavy groups (editors, chat, media, art, office, dev, gaming) default OFF.
# Flip what you need back on. Pair with ./system.nix.
{
  hyprlandEnable,
  niriEnable,
  mangoEnable,
  aiEnable,
  ...
}:

{
  usrset = {
    stateVersion = "HomeManagerVersionNumber"; # [CHANGE THIS]
    name = "PLEASECHANGEME_NAME"; # [CHANGE THIS] for git
    email = "PLEASECHANGEME_EMAIL"; # [CHANGE THIS] for git

    # core [shell]
    shell.enable = true;

    # =========[experience]
    hyprland.enable = hyprlandEnable;
    niri = {
      enable = niriEnable;
      shelljar.enable = false; # my quickshell island shell
      noctalia.enable = false; # noctalia desktop shell
    };
    mango = {
      enable = mangoEnable; # mango (mangowm) default WM on this minimal host
      shelljar.enable = false; # my quickshell island shell
    };
    launcher.enable = true; # ~10mib - fuzzel launcher
    resYoink = {
      enable = false; # resources OFF (~300+mib)
      wallpapers = false;
      icons = false;
      profilePictures = false;
      minecraftSkins = false;
    };
    # =========[experience]^^^

    # =========[appstream]
    browsers = {
      enable = true;
      firefox = true; # keep only firefox (drop librewolf/chromium to save ~1.5GiB)
      librewolf = false;
      chromium = false;
      default = "firefox";
    };
    terminal = {
      enable = true; # foot
      font = "IntoneMono Nerd Font";
      fontSize = 14;
    };
    syncthing.enable = false;
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
    espanso = (import ../espansoconf.nix { enable = false; });
    flatpak.enable = false;
    nautilus.enable = true; # ~50mib file manager
    yazi.enable = true; # ~10mib terminal file manager
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
    keepass.enable = true; # ~100mib password manager (privacy-important)
    gaming = {
      prism.enable = false;
      heroic.enable = false;
    };
    # =========[appstream]^^^

    # =========[creative tools]
    art = {
      enable = false; # OFF
      imageTools = false;
      threeD = false;
      astronomy = false;
    };
    office.enable = false; # OFF
    obs.enable = false; # OFF
    kdenlive.enable = false; # OFF
    # =========[creative tools]^^^

    # =========[management]
    inputmethods.japanese.enable = false;
    inputmethods.korean.enable = false;
    ai = {
      enable = aiEnable; # sets AI tools like opencode, llama.cpp
      opencode.enable = true; # opencode (NON-local models only)
      lmstudio.enable = false; # no LM Studio (saves ~2.3GiB)
    };
    dictation.enable = false;
    git.enable = true; # git
    bluetooth.enable = false;
    dev = {
      enable = false; # OFF: no dev toolchains
      python = false;
      dotnet = false;
      node = false;
      cc = false;
      go = false;
      nixTools = true; # keep nix tooling (comes with this repo)
      sqlTools = false;
    };
    fastfetch.enable = true;
    # =========[management]^^^
    theming = {
      enable = true;
      flavor = "mocha";
      accent = "blue";
      cursorSize = 36;
    };
  }; # end of usrset
}
