# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: lidm TUI display manager, gruvbox, tty7.
# -=-=-=-=-=-=-=-=-=-=-=
{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.sysset.lidm;

  # vendored unit on purpose: upstream module.nix has no enable gate (its
  # config is unconditional, would leak a dead unit + defaultSession into
  # every host) and pins a stale v2.0.1 GitHub tarball; we drive their
  # packaging (lidm.nix) directly from the locked input rev instead.
  version = builtins.elemAt (builtins.match "VERSION[[:blank:]]*:=?[[:space:]]*([^\n]*)\n.*" (builtins.readFile "${inputs.lidm}/Makefile")) 0;

  # gruvbox-dark (Gruvbox-Orange accent) as truecolor ANSI SGR codes
  gruvbox = {
    colors = {
      bg = "48;2;40;40;40"; # #282828 bg0
      fg = "22;24;38;2;235;219;178"; # #ebdbb2 fg1
      err = "1;38;2;251;73;52"; # bold red
      s_wayland = "38;2;131;165;178"; # blue bright
      s_xorg = "38;2;215;153;33"; # yellow
      s_shell = "38;2;184;187;38"; # green bright
      e_hostname = "38;2;211;134;155"; # purple bright
      e_date = "38;2;168;153;132"; # gray
      e_box = "38;2;102;92;84"; # bg3, subtle border
      e_header = "1;4;38;2;254;128;25"; # bold underline orange accent
      e_user = "38;2;142;192;124"; # aqua bright
      e_passwd = "38;2;131;165;178"; # blue bright
      e_badpasswd = "3;4;38;2;251;73;52"; # italic underline red
      e_key = "38;2;254;128;25"; # orange accent
    }; # end of colors
    behavior = {
      timefmt = "%Y-%m-%d %H:%M:%S";
      source = [
        "/etc/lidm.env"
        "/etc/locale.conf"
      ]; # end of sources
      user_source = ".lidm.env";
    }; # end of behavior
  };

  # session dirs are compiled into the binary (CPPFLAGS), so the package
  # needs the session union, which only exists with displayManager on
  lidmPkg = pkgs.callPackage "${inputs.lidm}/assets/pkg/nix/lidm.nix" {
    inherit pkgs lib;
    config = {
      inherit version;
      src = inputs.lidm.outPath;
      xsessions = "${config.services.displayManager.sessionData.desktops}/share/xsessions";
      wayland-sessions = "${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
      cfg = gruvbox;
    };
  };
in
{
  options = {
    sysset.lidm.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable lidm TUI display manager on tty7 (mutually exclusive with sysset.gdm)";
    };
  }; # end options

  config = lib.mkIf cfg.enable {
    # populates sessionData.desktops (the wayland-sessions union lidm lists)
    services.displayManager.enable = true;

    # lidm auths through the stock `login` PAM service, which NixOS already
    # wires pam_gnome_keyring into, so keyring unlock needs nothing here
    systemd.services.lidm = {
      description = "lidm TUI display manager";
      aliases = [ "display-manager.service" ];
      wantedBy = [ "graphical.target" ];
      after = [
        "systemd-user-sessions.service"
        "plymouth-quit-wait.service"
      ];
      unitConfig.Wants = [ "systemd-user-sessions.service" ];
      serviceConfig = {
        Type = "idle";
        ExecStart = "${lidmPkg}/bin/lidm 7";
        StandardInput = "tty";
        StandardOutput = "tty";
        StandardError = "tty";
        TTYPath = "/dev/tty7";
        TTYReset = true;
        TTYVHangup = true;
        TTYVTDisallocate = true;
      };
      # don't kill the greeter/session on nixos-rebuild
      restartIfChanged = false;
    }; # end of lidm unit

    # boot straight to the login menu
    systemd.defaultUnit = "graphical.target";

    # keep the on-demand getty off lidm's VT
    systemd.services."autovt@tty7".enable = false;

    # gdm and lidm both claim display-manager.service
    assertions = [
      {
        assertion = !config.sysset.gdm.enable;
        message = "sysset.lidm and sysset.gdm are mutually exclusive";
      }
    ];
  }; # end config
}
