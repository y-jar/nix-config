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
  knownTablets = import ../data/tabletconf.nix;
in
{
  options.usrset = {
    # [system facts]
    # What the user modules need to know about the machine they run on. NOT toggles:
    # on NixOS juajar/bridge.nix fills them from sysset.*; on any other host leave the
    # defaults or set them in that host's user.nix. liijar modules read these instead
    # of `osConfig` / extra specialArgs, which keeps the user layer portable.
    system = {
      platform = lib.mkOption {
        type = lib.types.enum [
          "nixos"
          "debian"
        ];
        default = "nixos";
        description = "What the host OS is. NixOS-only pieces (nh/nixos-rebuild aliases, /run/current-system paths, tuneshon) switch off on anything else.";
      };
      hasDesktop = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Host runs a graphical session (WM/DE). Gates desktop-only session vars and packages.";
      };
      unfree = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Host allows unfree packages (drives the `,` temp-install and jn).";
      };
      nixpkgsYoinks = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Host uses the nixpkgs yoinks overlay (rsakura etc.).";
      };
      mullvad = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Host runs the Mullvad VPN service; the user side installs its GUI.";
      };
      audioAddon = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Host runs the jar-audio pipewire addon; compositors pin its sink at startup.";
      };
      autostart = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Per-host extra compositor autostart commands (sysset.autostart.commands).";
      };
      webapps = lib.mkOption {
        type = lib.types.raw;
        default = {
          enable = false;
          apps = [ ];
        };
        description = "Browser-apps-as-desktop-apps definitions ({ enable, apps }), same shape as sysset.webapps.";
      };
      aiModels = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Active Ollama model tags for the host (filled by bridge on NixOS).";
      };
      aiContextLength = lib.mkOption {
        type = lib.types.int;
        default = 8192;
        description = "Active Ollama context length for the host (filled by bridge on NixOS).";
      };
    };

    # [packages]
    # false = deliver configs only: every `packages` list is dropped so the host's own
    # package manager (apt on debian) owns the binaries. See liijar/platform.nix.
    packages.install = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install the nix packages of every enabled module. Set false on hosts where the system package manager provides the binaries and hjem should only write dotfiles.";
    };

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
    zsh.enable = lib.mkOption {
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
    scripts.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable shared helper scripts (jshot/jrec/jimg/jnote/... in liijar/scripts).";
    };

    # [input]
    tablets = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Map the '${name}' pen to its own display (mango device_rule: type:tablet -> monitor spec).";
              };
              match = lib.mkOption {
                type = lib.types.str;
                default = knownTablets.${name}.match or "";
                description = "mango monitor spec identifying the tablet display. Defaults to the known-tablet catalog (juajar/data/tabletconf.nix); set it for uncatalogued tablets. Find it: for e in /sys/class/drm/card*-*/edid; do echo \"$e: $(strings \"$e\" | tr '\\n' ' ')\"; done";
              };
            };
          }
        )
      );
      default = { };
      description = "Pen-display mappings keyed by device, e.g. { xppen.enable = true; }. Catalog: juajar/data/tabletconf.nix. NOTE: mango routes every tablet through one shared device_rule spec (per-tablet needs name: rules with device names from mmsg get all-devices).";
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
    fuzzel.enable = lib.mkOption {
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
      firefox.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable firefox [work]";
      };
      librewolf.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable librewolf [personal]";
      };
      chromium.enable = lib.mkOption {
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
      mpv.enable = lib.mkEnableOption "mpv video player + yt-dlp integration";
      downloaders.enable = lib.mkEnableOption "ffmpeg + yt-dlp download/transcode CLI";
      musicApps.enable = lib.mkEnableOption "music players (quodlibet, gapless, blanket, spotify)";
      audioEditor.enable = lib.mkEnableOption "audacity audio editor";
      viewers.enable = lib.mkEnableOption "misc viewers (constrict, anki)";
      defaultApps.enable = lib.mkEnableOption "default mime apps + loupe/showtime/file-roller";
    };
    keepass.enable = lib.mkEnableOption "keepassxc";
    gaming = {
      prism.enable = lib.mkEnableOption "prismlauncher (minecraft)";
      heroic.enable = lib.mkEnableOption "heroic (gog + epic)";
    };

    # [creative]
    art = {
      enable = lib.mkEnableOption "art tools (master toggle)";
      imageTools.enable = lib.mkEnableOption "2D/painting tools (krita, gimp, inkscape, ...)";
      threeD.enable = lib.mkEnableOption "3D tools (blender, blockbench)";
      astronomy.enable = lib.mkEnableOption "astronomy apps (stellarium, celestia)";
    };
    office.enable = lib.mkEnableOption "office (libreoffice + pandoc)";
    obs.enable = lib.mkEnableOption "obs studio";
    kdenlive.enable = lib.mkEnableOption "kdenlive video editor";

    # [management]
    dictation.enable = lib.mkEnableOption "push-to-talk dictation + transcript (voxtype)";
    inputMethods = {
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
    nueon.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable nueon (conlang editor/creation app)";
    };
    nueon.binary = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use the prebuilt release .deb (nueon-bin) instead of building from source";
    };
    bluetooth.enable = lib.mkEnableOption "bluetooth (blueman)";
    fastfetch.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable fastfetch system fetch";
    };
    dev = {
      enable = lib.mkEnableOption "dev tools (master toggle)";
      python.enable = lib.mkEnableOption "python (pyenv + pip)";
      dotnet.enable = lib.mkEnableOption "dotnet (C#/.NET) SDK";
      node.enable = lib.mkEnableOption "nodejs (JS/TS runtime)";
      cc.enable = lib.mkEnableOption "gcc (C/C++ compiler)";
      go.enable = lib.mkEnableOption "go toolchain";
      nixTools.enable = lib.mkEnableOption "nix language servers + formatters";
      sqlTools.enable = lib.mkEnableOption "dbeaver + sql clients";
    };

    # [resources]
    resYoink = {
      enable = lib.mkEnableOption "resource symlinks (wallpapers, icons, pfps)";
      wallpapers.enable = lib.mkEnableOption "wallpapers symlink (resjar/wall-jar)";
      icons.enable = lib.mkEnableOption "icons symlink (resjar/iconbin) via icon-jar hjem module";
      profilePictures.enable = lib.mkEnableOption "profile pictures symlink (resjar/pfpbin) via icon-jar hjem module";
      minecraftSkins.enable = lib.mkEnableOption "minecraft skins symlink (resjar/mcskins-jar)";
    };
  }; # end of usrset
}
