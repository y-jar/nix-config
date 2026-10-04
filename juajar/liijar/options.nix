# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: The usrset toggle sheet single source of truth for user options.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[liijar/options.nix] =-=-=
# Declares every `usrset.*` option ONCE. Auto-imported by liijar/default.nix
# into the hjem user scope (via hjemkey). Hosts set their values in
# hstjar/<host>/user.nix; the app modules read them. Never declare usrset
# options anywhere else.
# =-=-=[end liijar/options.nix] =-=-=
{ lib, pkgs, ... }:
let
  # known tablet EDID identities; see the discovery command in the header there.
  knownTablets = import ../../hstjar/tabletconf.nix;
in
{
  options.usrset = {
    # [core]
    name = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Git user name";
    };
    email = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Git user email";
    };
    shell.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable zsh shell";
    };
    wine.enable = lib.mkEnableOption "wine (windows compatibility layer, ~500MiB)";
    cowsay.enable = lib.mkOption {
      type = lib.types.bool;
      default = true; # always installed unless a host turns it off
      description = "Enable cowsay. REFERENCE EXAMPLE module copy juajar/liijar/cowsay/ for new apps";
    };
    tools.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable shared helper scripts (jshot/jrec/jimg/jnote/... in liijar/scripts).";
    };

    # [input]
    tabletenable = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Map the '${name}' pen to its own display (mango tablet_map_to_mon).";
              };
              match = lib.mkOption {
                type = lib.types.str;
                default = knownTablets.${name}.match or "";
                description = "mango monitor spec identifying the tablet display. Defaults to the known-tablet catalog (hstjar/tabletconf.nix); set it for uncatalogued tablets. Find it: for e in /sys/class/drm/card*-*/edid; do echo \"$e: $(strings \"$e\" | tr '\\n' ' ')\"; done";
              };
            };
          }
        )
      );
      default = { };
      description = "Pen-display mappings keyed by device, e.g. { xppen.enable = true; }. Catalog: hstjar/tabletconf.nix. NOTE: mango 0.16.3 maps a single tablet globally (newer mango adds per-device rules).";
    };

    # [experience]
    hyprland = {
      enable = lib.mkEnableOption "hyprland";
      shelljar.enable = lib.mkEnableOption "shelljar (my quickshell island shell) for hyprland";
      noctalia.enable = lib.mkOption {
        type = lib.types.bool;
        default = true; # on by default (hyprland lua autostart spawns noctalia-shell)
        description = "Enable the noctalia desktop shell for hyprland";
      };
    };
    niri = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Niri window manager";
      };
      shelljar.enable = lib.mkEnableOption "shelljar (my quickshell island shell) for niri";
      noctalia.enable = lib.mkOption {
        type = lib.types.bool;
        default = true; # on by default so existing hosts keep noctalia until they swap shells
        description = "Enable the noctalia desktop shell for niri";
      };
    };
    mango = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable mango window manager";
      };
      shelljar.enable = lib.mkEnableOption "shelljar (my quickshell island shell) for mango";
      noctalia.enable = lib.mkEnableOption "noctalia desktop shell for mango";
    };
    launcher.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable fuzzel launcher";
    };
    theming = {
      enable = lib.mkEnableOption "theming (gruvbox gtk + qt + cursor)";
      variant = lib.mkOption {
        type = lib.types.enum [
          "dark"
          "light"
        ];
        default = "dark";
        description = "Gruvbox variant (dark|light)";
      };
      accent = lib.mkOption {
        type = lib.types.enum [
          "orange"
          "red"
          "yellow"
          "green"
          "teal"
          "purple"
          "pink"
          "grey"
          "default"
        ];
        default = "orange";
        description = "Gruvbox accent color (drives GTK theme + palette accent)";
      };
      blackness = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Darker backgrounds (gruvbox-gtk `black` tweak)";
      };
      cursorSize = lib.mkOption {
        type = lib.types.int;
        default = 36;
        description = "Cursor size in pixels";
      };
      colors = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = "Computed gruvbox palette (set by the theming module; read-only in practice)";
      };
      gtkThemeName = lib.mkOption {
        type = lib.types.str;
        default = "Gruvbox-Orange-Dark";
        description = "Exact GTK theme dir name (set by the theming module; read-only in practice)";
      };
      iconThemeName = lib.mkOption {
        type = lib.types.str;
        default = "Gruvbox-Plus-Dark";
        description = "Exact icon theme dir name (set by the theming module; read-only in practice)";
      };
    };

    # [appstream]
    browsers = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable browsers (librewolf + firefox)";
      };
      firefox = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable firefox [work]";
      };
      librewolf = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable librewolf [personal]";
      };
      chromium = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable chromium [needed for native webapps (`--app` mode)]";
      };
      default = lib.mkOption {
        type = lib.types.str;
        default = "firefox";
        description = "Preferred browser (command name): WM Mod+B keybind + default mime browser.";
      };
    };
    terminal = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable terminals (foot + kitty + alacritty)";
      };
      font = lib.mkOption {
        type = lib.types.str;
        default = "IntoneMono Nerd Font";
        description = "Terminal font. Options: \"IntoneMono Nerd Font\" \"Monocraft\" \"Miracode\"";
      };
      fontSize = lib.mkOption {
        type = lib.types.int;
        default = 14;
        description = "Terminal font size";
      };
    };
    syncthing.enable = lib.mkEnableOption "syncthing (bridged to the system service, runs as mainUser)";
    editors = {
      enable = lib.mkEnableOption "editors";
      vscodium.enable = lib.mkEnableOption "vscodium";
      zed.enable = lib.mkEnableOption "zed";
      obsidian.enable = lib.mkEnableOption "obsidian";
      nvf.enable = lib.mkEnableOption "nvf (neovim config)";
      helix.enable = lib.mkEnableOption "helix";
      cherrytree.enable = lib.mkEnableOption "cherrytree hierarchical note-taking editor";
      pycharm.enable = lib.mkEnableOption "jetbrains pycharm professional IDE (unfree)";
    };
    chatApps = {
      enable = lib.mkEnableOption "chat apps (discord + halloy)";
      discord.enable = lib.mkEnableOption "discord";
      halloy.enable = lib.mkEnableOption "halloy irc client";
    };
    espanso = {
      enable = lib.mkEnableOption "espanso text expander";
      shorts = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = "Espanso trigger -> replacement pairs, editable per host";
      };
      vars = lib.mkOption {
        type = lib.types.listOf lib.types.attrs;
        default = [ ];
        description = "Espanso match vars (e.g. date/time), used as {{name}} in replacements";
      };
      settings = lib.mkOption {
        inherit (pkgs.formats.yaml { }) type;
        default = { };
        description = "Extra espanso config/default.yml settings";
      };
    };
    flatpak.enable = lib.mkEnableOption "flatpak + bazaar";
    nautilus.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable nautilus file explorer";
    };
    yazi.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable yazi terminal file manager";
    };
    ranger.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable ranger terminal file manager";
    };
    media = {
      enable = lib.mkEnableOption "media tools (master toggle)";
      mpv = lib.mkEnableOption "mpv video player + yt-dlp integration";
      downloaders = lib.mkEnableOption "ffmpeg + yt-dlp download/transcode CLI";
      musicApps = lib.mkEnableOption "music players (quodlibet, gapless, blanket, spotify)";
      audioEditor = lib.mkEnableOption "audacity audio editor";
      viewers = lib.mkEnableOption "misc viewers (yacreader, constrict, anki)";
      defaultApps = lib.mkEnableOption "default mime apps + loupe/showtime/file-roller";
    };
    keepass.enable = lib.mkEnableOption "keepassxc";
    gaming = {
      prism.enable = lib.mkEnableOption "prismlauncher (minecraft)";
      heroic.enable = lib.mkEnableOption "heroic (gog + epic)";
    };

    # [creative]
    art = {
      enable = lib.mkEnableOption "art tools (master toggle)";
      imageTools = lib.mkEnableOption "2D/painting tools (krita, gimp, inkscape, ...)";
      threeD = lib.mkEnableOption "3D tools (blender, blockbench)";
      astronomy = lib.mkEnableOption "astronomy apps (stellarium, celestia)";
    };
    office.enable = lib.mkEnableOption "office (libreoffice + pandoc)";
    obs.enable = lib.mkEnableOption "obs studio";
    kdenlive.enable = lib.mkEnableOption "kdenlive video editor";

    # [management]
    dictation.enable = lib.mkEnableOption "push-to-talk dictation + transcript (voxtype)";
    inputmethods = {
      japanese.enable = lib.mkEnableOption "japanese input (fcitx5 + mozc)";
      korean.enable = lib.mkEnableOption "korean input (fcitx5 + hangul)";
    };
    ai = {
      enable = lib.mkEnableOption "ai tools (lm studio + opencode)";
      opencode.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Install opencode (CLI + desktop GUI) + write its config. On by default when ai.enable";
      };
      lmstudio.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Install LM Studio (~2.3GiB). Disable to keep opencode only";
      };
    };
    git.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable git tools (git + gh + lazygit)";
    };
    tuneshon = {
      enable = lib.mkEnableOption "tuneshon (NixOS update tool, gui + cli)";
      configDir = lib.mkOption {
        type = lib.types.str;
        default = "/etc/nixos";
        description = "NixOS config directory tuneshon operates on";
      };
      bootLoader = lib.mkOption {
        type = lib.types.str;
        default = "systemd-boot";
        description = "Boot loader name (systemd-boot, grub, ...)";
      };
      logFile = lib.mkOption {
        type = lib.types.str;
        default = "$HOME/.config/tuneshon/tuneshon.log";
        description = "Path to the tuneshon log file";
      };
      overwrite = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Force-write ~/.config/tuneshon/config.json on login (clobbers GUI edits)";
      };
    };
    bluetooth.enable = lib.mkEnableOption "bluetooth (blueman)";
    fastfetch.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable fastfetch system fetch";
    };
    dev = {
      enable = lib.mkEnableOption "dev tools (master toggle)";
      python = lib.mkEnableOption "python (pyenv + pip)";
      dotnet = lib.mkEnableOption "dotnet (C#/.NET) SDK";
      node = lib.mkEnableOption "nodejs (JS/TS runtime)";
      cc = lib.mkEnableOption "gcc (C/C++ compiler)";
      go = lib.mkEnableOption "go toolchain";
      nixTools = lib.mkEnableOption "nix language servers + formatters";
      sqlTools = lib.mkEnableOption "dbeaver + sql clients";
    };

    # [resources]
    resYoink = {
      enable = lib.mkEnableOption "resource symlinks (wallpapers, icons, pfps)";
      wallpapers = lib.mkEnableOption "wallpapers symlink (resjar/wall-jar)";
      icons = lib.mkEnableOption "icons symlink (resjar/iconbin) via icon-jar hjem module";
      profilePictures = lib.mkEnableOption "profile pictures symlink (resjar/pfpbin) via icon-jar hjem module";
      minecraftSkins = lib.mkEnableOption "minecraft skins symlink (resjar/mcskins-jar)";
    };
  }; # end of usrset
}
