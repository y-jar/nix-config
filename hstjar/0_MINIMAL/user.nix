# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host 0_MINIMAL: lean user toggle sheet (usrset).
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
    name = "PLEASECHANGEME_NAME"; # [CHANGE THIS] for git
    email = "PLEASECHANGEME_EMAIL"; # [CHANGE THIS] for git

    # core [shell]
    zsh.enable = true;

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
    fuzzel.enable = true; # ~10mib - fuzzel launcher
    resYoink = {
      enable = false; # resources OFF (~300+mib)
      wallpapers.enable = false;
      icons.enable = false;
      profilePictures.enable = false;
      minecraftSkins.enable = false;
    };
    # =========[experience]^^^

    # =========[appstream]
    browsers = {
      enable = true;
      firefox.enable = true; # keep only firefox (drop librewolf/chromium to save ~1.5GiB)
      librewolf.enable = false;
      chromium.enable = false;
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
      cherrytree.enable = false;
      pycharm.enable = false;
    };
    chatApps = {
      enable = false; # OFF: no discord/halloy (saves ~380mib)
      discord.enable = false;
      halloy.enable = false;
    };
    espanso = import ../../juajar/data/espansoconf.nix { enable = false; };
    flatpak.enable = false;
    nautilus.enable = true; # ~50mib file manager
    yazi.enable = true; # ~10mib terminal file manager
    ranger.enable = false;
    media = {
      enable = false; # OFF: minimal media
      mpv.enable = false;
      downloaders.enable = false;
      musicApps.enable = false;
      audioEditor.enable = false;
      viewers.enable = false;
      defaultApps.enable = true;
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
      imageTools.enable = false;
      threeD.enable = false;
      astronomy.enable = false;
    };
    office.enable = false; # OFF
    obs.enable = false; # OFF
    kdenlive.enable = false; # OFF
    # =========[creative tools]^^^

    # =========[management]
    inputMethods.japanese.enable = false;
    inputMethods.korean.enable = false;
    ai = {
      enable = aiEnable; # sets AI tools like opencode, llama.cpp
      opencode.enable = true; # opencode (NON-local models only)
      lmstudio.enable = false; # no LM Studio (saves ~2.3GiB)
    };
    dictation.enable = false;
    git.enable = true; # git
    tuneshon.enable = false; # NixOS update tool (gui + cli)
    nueon.enable = false; # conlang editor/creation app
    nueon.binary = false; # use the prebuilt release .deb
    bluetooth.enable = false;
    dev = {
      enable = false; # OFF: no dev toolchains
      python.enable = false;
      dotnet.enable = false;
      node.enable = false;
      cc.enable = false;
      go.enable = false;
      nixTools.enable = true; # keep nix tooling (comes with this repo)
      sqlTools.enable = false;
    };
    fastfetch.enable = true;
    # =========[management]^^^
    theming = {
      enable = true;
      variant = "dark";
      accent = "orange";
      blackness = true;
      cursorSize = 36;
    };
  }; # end of usrset
}
