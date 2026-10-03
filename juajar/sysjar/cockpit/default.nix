# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Cockpit web management UI (systemd/storage/network/logs + plugins).
# -=-=-=-=-=-=-=-=-=-=-=
# Cockpit listens on `port` (default 9090). On a trusted LAN set
# allowUnencrypted = true and openFirewall = true; behind a TLS reverse proxy
# leave allowUnencrypted = false. Plugins are real packages (cockpit-machines,
# cockpit-podman) added via services.cockpit.plugins, not systemPackages.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  hostnm,
  ...
}:
let
  cfg = config.sysset.cockpit;

  pluginPackages =
    lib.optional cfg.machines pkgs.cockpit-machines
    ++ lib.optional cfg.podman pkgs.cockpit-podman
    ++ cfg.extraPlugins;

  # this host's own net.nix (pure data; the same file the networking module
  # reads). ip feeds the LAN origin so cockpit is reachable by address too.
  netData =
    let
      p = ../../../hstjar/${hostnm}/net.nix;
    in
    if builtins.pathExists p then import p else { };
  hostIp = netData.ip or null;
in
{
  options.sysset.cockpit = {
    enable = lib.mkEnableOption "Cockpit web management UI";

    port = lib.mkOption {
      type = lib.types.port;
      default = 9090;
      description = "Port Cockpit listens on.";
    }; # end of port

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open the Cockpit port in the firewall.";
    }; # end of openFirewall

    allowUnencrypted = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Allow plain-HTTP access (settings.WebService.AllowUnencrypted). Use on a trusted LAN or behind a TLS reverse proxy.";
    }; # end of allowUnencrypted

    machines = lib.mkEnableOption "cockpit-machines (manage KVM/QEMU VMs via libvirt)";
    podman = lib.mkEnableOption "cockpit-podman (manage containers)";

    extraOrigins = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Extra cockpit origins on top of localhost + host/.local/ip (e.g. alternate names).";
    }; # end of extraOrigins

    extraPlugins = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Extra cockpit plugin packages (must provide a cockpit plugin path).";
    }; # end of extraPlugins
  }; # end of options

  config = lib.mkIf cfg.enable {
    services.cockpit = {
      enable = true;
      inherit (cfg) port openFirewall;
      plugins = pluginPackages;
      # [origins] cockpit rejects websocket upgrades whose Origin header is
      # not whitelisted. nixpkgs only whitelists https://localhost, so add
      # the LAN faces here: hostname, .local, and (from net.nix) the host ip.
      allowed-origins = [
        "http://${hostnm}:${toString cfg.port}"
        "https://${hostnm}:${toString cfg.port}"
        "http://${hostnm}.local:${toString cfg.port}"
        "https://${hostnm}.local:${toString cfg.port}"
      ]
      ++ lib.optionals (hostIp != null) [
        "http://${hostIp}:${toString cfg.port}"
        "https://${hostIp}:${toString cfg.port}"
      ]
      ++ cfg.extraOrigins;
      settings.WebService.AllowUnencrypted = cfg.allowUnencrypted;
    }; # end of services.cockpit
  }; # end of config
}
