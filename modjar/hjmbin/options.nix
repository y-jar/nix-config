{ lib, pkgs, ... }:

{
  options.hjmSettings = {
    # [core]
    shell.enable = lib.mkEnableOption "zsh shell";

    # [experience]
    hyprland.enable = lib.mkEnableOption "hyprland";
    niri.enable = lib.mkEnableOption "niri";
    launcher.enable = lib.mkEnableOption "fuzzel launcher";

    # [appstream]
    browsers = {
      enable = lib.mkEnableOption "browsers (librewolf + firefox)";
      firefox = lib.mkEnableOption "firefox";
      librewolf = lib.mkEnableOption "librewolf";
    };
    terminal.enable = lib.mkEnableOption "terminals (foot + kitty + alacritty)";
    editors = {
      enable = lib.mkEnableOption "editors";
      vscodium.enable = lib.mkEnableOption "vscodium";
      zed.enable = lib.mkEnableOption "zed";
      obsidian.enable = lib.mkEnableOption "obsidian";
      nvf.enable = lib.mkEnableOption "nvf (neovim config)";
      helix.enable = lib.mkEnableOption "helix";
    };
    discord.enable = lib.mkEnableOption "discord";
    flatpak.enable = lib.mkEnableOption "flatpak + bazaar";
    nautilus.enable = lib.mkEnableOption "nautilus file explorer";
    yazi.enable = lib.mkEnableOption "yazi terminal file manager";
    ranger.enable = lib.mkEnableOption "ranger terminal file manager";
    media.enable = lib.mkEnableOption "media tools (mpv + ffmpeg)";
    keepass.enable = lib.mkEnableOption "keepassxc";
    espanso = {
      enable = lib.mkEnableOption "espanso text expander";
      shorts = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = "Espanso trigger -> replacement pairs, editable per host";
      }; # end of shorts
      vars = lib.mkOption {
        type = lib.types.listOf lib.types.attrs;
        default = [ ];
        description = "Espanso match vars (e.g. date/time), used as {{name}} in replacements";
      }; # end of vars
      settings = lib.mkOption {
        type = (pkgs.formats.yaml { }).type;
        default = { };
        description = "Extra espanso config/default.yml settings";
      }; # end of settings
    }; # end of espanso
    gaming = {
      prism.enable = lib.mkEnableOption "prismlauncher (minecraft)";
      heroic.enable = lib.mkEnableOption "heroic (gog + epic)";
    };

    # [creative]
    art.enable = lib.mkEnableOption "creative tools (blender + krita + gimp + inkscape)";
    office.enable = lib.mkEnableOption "office (libreoffice + pandoc)";
    obs.enable = lib.mkEnableOption "obs studio";
    kdenlive.enable = lib.mkEnableOption "kdenlive video editor";

    # [management]
    inputmethods = {
      japanese.enable = lib.mkEnableOption "japanese input (fcitx5 + mozc)";
      korean.enable = lib.mkEnableOption "korean input (fcitx5 + hangul)";
    };
    ai.enable = lib.mkEnableOption "ai tools (lm studio + opencode)";
    git.enable = lib.mkEnableOption "git tools (git + gh + lazygit)";
    bluetooth.enable = lib.mkEnableOption "bluetooth (blueman)";
    dev.enable = lib.mkEnableOption "dev tools (dotnet + python + node + gcc + go)";

    # [resources]
    resYoink = {
      enable = lib.mkEnableOption "resource symlinks (wallpapers, icons, pfps)";
      wallpapers = lib.mkEnableOption "wallpapers symlink";
      icons = lib.mkEnableOption "icons symlink";
      profilePictures = lib.mkEnableOption "profile pictures symlink";
    };
  };

  # =-=-=[hjemDotfiles] =-=-=
  # Internal options set by hjmbin modules, consumed by hjemkey.nix.
  # If null, the dotfile is skipped.
  options.hjemDotfiles = {
    # [shell/zsh.nix]
    zshrc = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      internal = true;
      description = "Generated .zshrc path";
    };
    fzfrc = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      internal = true;
      description = "Generated .fzfrc path";
    };
    # [directories/default.nix]
    dirSetup = lib.mkOption {
      type = lib.types.nullOr lib.types.lines;
      default = null;
      internal = true;
      description = "Shell commands for creating user directories";
    };
    # [git/default.nix]
    gitconfig = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      internal = true;
      description = "Generated .gitconfig path";
    };
    # [yazi/default.nix]
    yaziToml = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      internal = true;
      description = "Generated yazi.toml path";
    };
    yaziKeymap = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      internal = true;
      description = "Generated yazi keymap.toml path";
    };
    yaziTheme = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      internal = true;
      description = "Generated yazi theme.toml path";
    };
    # [media/default.nix]
    mpvConf = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      internal = true;
      description = "Generated mpv.conf path";
    };
    mimeApps = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      internal = true;
      description = "Generated mimeapps.list path";
    };
    # [espanso/default.nix]
    espansoDefault = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      internal = true;
      description = "Generated espanso config/default.yml path";
    };
    espansoBase = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      internal = true;
      description = "Generated espanso match/base.yml path";
    };
    espansoGlobals = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      internal = true;
      description = "Generated espanso match/globals.yml path";
    };
    # [inputmethods/default.nix]
    mozcConfig1Db = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      internal = true;
      description = "Generated mozc config1.db path";
    };
    fcitx5Files = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      internal = true;
      description = "Generated fcitx5 config dir path";
    };
    # [niri/default.nix]
    nwgDrawerCss = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      internal = true;
      description = "nwg-drawer drawer.css path";
    };
    niriFiles = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.submodule {
          options = {
            config = lib.mkOption { type = lib.types.path; };
            base = lib.mkOption { type = lib.types.path; };
            bindings = lib.mkOption { type = lib.types.path; };
            rules = lib.mkOption { type = lib.types.path; };
            startups = lib.mkOption { type = lib.types.path; };
            hostInputs = lib.mkOption { type = lib.types.path; };
          }; # end of niriFiles sub module options
        }
      ); # end of niriFiles sub modules
      default = null;
      internal = true;
      description = "Niri KDL config files";
    }; # end of niriFiles

    # [resyoink/default.nix]
    resYoink = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.submodule {
          options = {
            wallpapers = lib.mkOption { type = lib.types.path; };
            icons = lib.mkOption { type = lib.types.path; };
            profilePictures = lib.mkOption { type = lib.types.path; };
          };
        }
      );
      default = null;
      internal = true;
      description = "Resource symlink paths (wallpapers, icons, pfps)";
    }; # end of resYoink
  }; # end of hjmbin options dotfiles
}
