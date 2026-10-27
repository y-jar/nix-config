# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host 0_TEMPLATE: user toggle sheet (usrset).
# -=-=-=-=-=-=-=-=-=-=-=
# This is the USER configuration file for this host (the `usrset` sheet).
#
# HOW TO USE THIS SHEET
#   - Every option below is declared once in juajar/liijar/options.nix; this file
#     only sets values. Most are opt-in (default false).
#   - Each option is a toggle: enable only what you need (sizes are rough comments).
#   - Keep `zsh.enable` true: it's the default shell for most systems.
#   - WM toggles mirror the system sheet (./system.nix) via the *Enable args.
#   - Pair options here with the matching system toggles in ./system.nix.
#   - Per-app behaviour lives in juajar/liijar/<app>/default.nix; shared shell
#     aliases/functions live in juajar/liijar/zsh/.
#   - For extra Hyprland/Niri per-host config see juajar/WMs/<wm>/host-inputs.
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

    # core [users, shell, basic things]
    # enables zsh shell with aliases [should be on by default]
    zsh.enable = true;
    # NOTE: granted as bridge.nix (system -> user facts) - do NOT set by hand:
    #   system.platform/hasDesktop/unfree/nixpkgsYoinks/mullvad/audioAddon/
    #   autostart/webapps/aiModels/aiContextLength
    wine.enable = false; # ~500mib - windows compatibility layer (opt-in)
    cowsay.enable = false; # cowsay + fortune pipes - also the example module
    # cowsay.enable = true; # reference example module copy juajar/liijar/cowsay for new apps

    # [kill switches] master shutoffs for whole module layers
    packages.install = true; # false = drop EVERY module's user packages list (platform.nix)
    scripts.enable = true; # false = drop the home-manager script buckets (platform.nix)

    # =========[experience] [pick one or more if you know what you're doing] [sizes approximate]
    hyprland = {
      enable = hyprlandEnable;
      shelljar.enable = false; # my quickshell island shell
      noctalia.enable = false; # noctalia desktop shell
    };
    niri = {
      enable = niriEnable;
      shelljar.enable = false; # my quickshell island shell
      noctalia.enable = false; # noctalia desktop shell
    };
    mango = {
      enable = mangoEnable; # mango (mangowm)
      shelljar.enable = false; # my quickshell island shell
      noctalia.enable = false; # noctalia desktop shell
    };
    fuzzel.enable = true; # ~10mib - sets launcher fuzzel
    # [tablet / pen display] map a pen's absolute coords to its own screen.
    # Keys come from juajar/data/tabletconf.nix (or set match yourself for new devices).
    # Find a display's identity in a terminal:
    #   for e in /sys/class/drm/card*-*/edid; do echo "$e: $(strings "$e" | tr '\n' ' ')"; done
    # then:  tablets.<key>.enable = true;
    tablets.xppen = {
      enable = false; # XP-Pen Artist 13.3 Pro (identity from juajar/data/tabletconf.nix)
      # match = "model:PRODUCT_NAME"; # override the catalogued EDID match for new devices
    };
    # tablets.myTablet = { enable = true; match = "model:PRODUCT_NAME"; }; # uncatalogued
    resYoink = {
      enable = false; # symlinks resources into ~/resjar/ [~300+mib for wallpapers]
      wallpapers.enable = false;
      icons.enable = false;
      profilePictures.enable = false;
      minecraftSkins.enable = false;
    };
    # =========[experience]^^^

    # =========[appstream]
    browsers = {
      enable = true; # ~500mib - librewolf + firefox
      firefox.enable = false; # firefox [work]
      librewolf.enable = false; # librewolf [personal]
      chromium.enable = false; # enables chromium [personal]
      default = "firefox"; # preferred browser: pick one that's enabled (firefox|librewolf|chromium). WM Super+B + default mime browser.
    };
    terminal = {
      enable = true; # ~30mib - sets terminal as foot + kitty + alacritty
      font = "IntoneMono Nerd Font"; # options: "IntoneMono Nerd Font" "Monocraft" "Miracode"
      fontSize = 14; # font size (default: 14)
    };
    syncthing.enable = false; # file sync (web UI at localhost:8384)
    editors = {
      enable = true; # ~600mib - VSCodium + Zed + Obsidian + Helix + NVF
      vscodium.enable = true; # ~300mib
      zed.enable = false; # ~200mib
      obsidian.enable = false; # ~200mib
      nvf.enable = true; # ~200mib - neovim config
      helix.enable = false; # ~20mib
      cherrytree.enable = false; # ~150mib - hierarchical note-taking editor
      pycharm.enable = false; # ~2.5gib - JetBrains PyCharm Professional (unfree)
    }; # end of editors
    chatApps = {
      enable = true;
      discord.enable = true; # ~300mib
      halloy.enable = true; # ~69mib nice
    };
    espanso = import ../../juajar/data/espansoconf.nix { enable = false; }; # ~30mib - espanso text expander
    # The espansoconf import also carries shorts + vars; for stray default.yml
    # content the declared escape hatch is the espanso.settings attr, see
    # juajar/liijar/espanso/default.nix.
    flatpak.enable = false; # ~10mib - flatpak + bazaar
    # [file explorers]
    nautilus.enable = true; # ~50mib
    yazi.enable = true; # ~10mib
    ranger.enable = false; # ~20mib
    # [media]
    media = {
      enable = true; # media master toggle
      mpv.enable = true; # mpv video player + yt-dlp
      downloaders.enable = false; # ffmpeg + yt-dlp
      musicApps.enable = false; # quodlibet, gapless, blanket
      audioEditor.enable = false; # audacity
      viewers.enable = false; # constrict, anki
      defaultApps.enable = true; # default mime apps + loupe/showtime/file-roller
    };
    keepass.enable = true; # ~100mib
    gaming = {
      prism.enable = false; # ~200mib - Prism Launcher [minecraft]
      heroic.enable = false; # ~300mib - Heroic [gog, epic.. other]
      protonplus.enable = false; # proton-ge/luxtorpeda compat tools manager [needs steam or heroic]
    }; # end of gaming
    # =========[appstream]^^^

    # =========[creative tools]
    art = {
      enable = false; # art master toggle
      imageTools.enable = false; # krita, gimp, inkscape, ...
      threeD.enable = false; # blender, blockbench
      astronomy.enable = false; # stellarium, celestia
    };
    office.enable = false; # ~800mib - LibreOffice + Pandoc
    obs.enable = false; # ~400mib - OBS Studio + plugins
    kdenlive.enable = false; # sets kdenlive
    # =========[creative tools]^^^

    # =========[management]
    inputMethods.japanese.enable = false; # ~100mib - fcitx5 + Mozc
    inputMethods.korean.enable = false; # ~100mib - fcitx5 + Hangul
    ai = {
      enable = aiEnable; # sets AI tools like opencode, llama.cpp
      opencode.enable = true; # opencode CLI + GUI (keep even if local llama is off)
      lmstudio.enable = true; # LM Studio (~2.3GiB) set false to save space
    };
    dictation.enable = false; # voxtype push-to-talk dictation + meeting/VTT transcript (F9)
    git.enable = true; # ~10mib - git + gh + lazygit
    tuneshon = {
      enable = false; # NixOS update tool (gui + cli) - set true to install it
      configDir = "/etc/nixos"; # point at THIS host's nix config repo (e.g. "/home/<user>/nix-config")
      bootLoader = "systemd-boot"; # CHANGE to match boot.nix (systemd-boot | grub | ...)
      logFile = "/home/PLEASECHANGEME_USERNAME/.config/tuneshon/tuneshon.log"; # default location
      overwrite = false; # true = force-reseed config.json each login (clobbers GUI edits)
    };
    nueon.enable = false; # conlang editor/creation app
    nueon.binary = false; # use the prebuilt release .deb
    bluetooth.enable = false; # ~5mib - blueman
    dev = {
      enable = false; # dev master toggle
      python.enable = false; # python (pyenv + pip)
      dotnet.enable = true; # dotnet SDK
      node.enable = true; # nodejs
      cc.enable = true; # gcc
      go.enable = true; # go
      nixTools.enable = true; # nix language servers + formatters
      sqlTools.enable = true; # dbeaver
    };
    fastfetch.enable = true; # sets fastfetch
    # =========[management]^^^
    theming = {
      enable = true; # sets theme for gtk/qt
      variant = "dark"; # gruvbox variant (dark|light)
      accent = "orange"; # gruvbox accent (orange is the warm star)
      blackness = true; # darker backgrounds
      cursorSize = 36; # cursor size in pixels (default: 36)
      # NOTE: theming.colors.* + gtkThemeName/iconThemeName are COMPUTED the
      # gruvbox palette module derives them from variant/accent/blackness; only
      # set them if you are hand-mixing a palette (read-only in practice).
    };
  }; # end of usrset
}
