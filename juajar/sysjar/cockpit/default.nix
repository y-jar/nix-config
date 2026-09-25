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
  ...
}:
let
  cfg = config.sysset.cockpit;

  pluginPackages =
    lib.optional cfg.machines pkgs.cockpit-machines
    ++ lib.optional cfg.podman pkgs.cockpit-podman
    ++ cfg.extraPlugins;
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
      settings.WebService.AllowUnencrypted = cfg.allowUnencrypted;
    }; # end of services.cockpit
  }; # end of config
}
