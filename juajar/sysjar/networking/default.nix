# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3>
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: NetworkManager + network configuration + fleet identity pins.
# -=-=-=-=-=-=-=-=-=-=-=
{
  hostnm,
  config,
  lib,
  ...
}:
# NOTE: this will be changes to a more modular layout, for now, this is a simple default config
let
  vpncfg = config.sysset.server.vpn;

  # [fleet identity registry] every hstjar/<host>/net.nix is pure data
  # ({ ip, hostKey }) and this module imports ALL of them - host configs
  # cannot see each other, but a shared data import can. each host then
  # pins every fleet host's ip (/etc/hosts) and ssh host key
  # (/etc/ssh/ssh_known_hosts), so `ssh whale` resolves + verifies without
  # avahi, and ~/.ssh/known_hosts is never consulted for fleet hosts -
  # stale entries there can't trigger host-key warnings anymore.
  # adding a host: fill its hstjar/<host>/net.nix while it is online
  # (scan the key with the `fkey` alias). hosts with no net.nix (or
  # ip = null) are skipped. rebuilt host = new key: re-scan, update its
  # net.nix, jc + rebuild the rest of the fleet.
  fleetRoot = ../../../hstjar;
  fleetRaw = lib.filterAttrs (
    name: type: type == "directory" && builtins.pathExists (fleetRoot + "/${name}/net.nix")
  ) (builtins.readDir fleetRoot);
  fleet = lib.filterAttrs (name: data: data ? ip && data.ip != null) (
    lib.mapAttrs (name: _: import (fleetRoot + "/${name}/net.nix")) fleetRaw
  );
  # hosts with a pinned key get the full treatment (dns pin + known_hosts
  # + ssh block); hosts with hostKey = null only get the dns pin.
  pinned = lib.filterAttrs (name: data: data ? hostKey && data.hostKey != null) fleet;
in
{
  options = {
    sysset.server = {
      vpn = {
        mullvad.enable = lib.mkEnableOption "Mullvad VPN";
      }; # end of sysset.server.vpn
    }; # end of sysset.server
  }; # end of options

  config = {
    # [Enable the OpenSSH daemon.]
    services.openssh.enable = true;
    networking = {
      # NOTE: If hostname is changed, be sure to match it on flake.nix and in the shell alias in
      # 	~/nix-config/modules/home/shell/zsh.nix
      networkmanager.enable = true;
      hostName = "${hostnm}"; # sets HOSTNAME
      #[ for resolving local ip info]
      # ip -4 addr show | grep inet
      # [fleet pins: one line per hstjar/*/net.nix - dns resolves without
      # avahi; ips are stable dhcp-reserved lan addresses]
      extraHosts = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: data: "${data.ip} ${name} ${name}.local") fleet
      );

      # [for dns issues i keep running into]
      nameservers = [
        "8.8.8.8" # google
        "1.1.1.1" # Coudflare
      ]; # end of nameservers

      # [Configure network proxy if necessary]
      #proxy.default = "http://user:password@http://proxy:port/";
      #proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      # [firewall shii]
      firewall = {
        enable = true;
        allowedTCPPorts = [
          53317 # LocalSend
          25600 # Komga
          8096 # Jellyfin (if not handled by services.jellyfin.openFirewall)
        ];
        allowedUDPPorts = [
          53317
          5353
        ];

        # [For KDE Connect / Phone integration Un comment if needed]
        allowedTCPPortRanges = [
          {
            from = 53317;
            to = 53320;
          }
        ]; # end of TCP port ranges

        allowedUDPPortRanges = [
          {
            from = 1714;
            to = 1764;
          }
        ]; # end of UDP port ranges

        # [interfaces to trust]
        trustedInterfaces = [
          "virbr0" # virtual bridge for vms
        ];
      }; # end of firewall
    }; # end of networking

    # [fleet ssh: pinned host keys + per-host blocks. UserKnownHostsFile
    # points fleet hosts at the global pinned file only - the user's
    # ~/.ssh/known_hosts is bypassed entirely (stale entries can't break
    # logins or trigger warnings). user is jar fleet-wide.]
    programs.ssh = {
      knownHosts = lib.mapAttrs (name: data: {
        hostNames = [
          name
          "${name}.local"
          data.ip
        ];
        publicKey = data.hostKey;
      }) pinned;
      extraConfig = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: data: ''
          Host ${name} ${name}.local ${data.ip}
            HostName ${name}.local
            User jar
            UserKnownHostsFile /etc/ssh/ssh_known_hosts
        '') pinned
      );
    }; # end of programs.ssh

    # [network optimization]
    boot = {
      kernelModules = [ "tcp_bbr" ];
      kernel.sysctl = {
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.core.default_qdisc" = "cake";
      };
    };

    # [for the dynamic seaching that other distros use.]
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
      }; # end of publish
    }; # end of avahi

    # [vpn]
    services = {
      mullvad-vpn.enable = vpncfg.mullvad.enable; # mullvad vpn
    }; # end of services
  }; # end of config
}
