# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Network base: hostname, NetworkManager, ssh daemon, avahi, dns, bbr, mullvad.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[networking] =-=-=
# Every piece is a toggle (defaults keep the old behaviour). The firewall is NOT
# opened here: each service module opens its own port, so a disabled service
# leaves nothing open. Fleet identity pins live in ./fleet.nix.
# =-=-=[end networking] =-=-=
{
  hostnm,
  config,
  lib,
  ...
}:
let
  cfg = config.sysset.networking;
in
{
  imports = [ ./fleet.nix ];

  options.sysset.networking = {
    networkManager.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Run NetworkManager (also adds users to the networkmanager group).";
    };
    ssh.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Run the OpenSSH daemon.";
    };
    avahi.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Run avahi (mDNS: host.local names, publishing, opens UDP 5353).";
    };
    nameservers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "8.8.8.8" # google
        "1.1.1.1" # cloudflare
      ];
      description = "Static DNS servers. Set [ ] to use whatever DHCP hands out.";
    };
    bbr.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "TCP BBR congestion control + cake qdisc.";
    };
    mullvad.enable = lib.mkEnableOption "Mullvad VPN";
  }; # end of sysset.networking

  config = lib.mkMerge [
    {
      # NOTE: if the hostname changes, match it in flake.nix (the nixosConfigurations name).
      networking = {
        hostName = hostnm;
        firewall.enable = true; # ports are opened by the module that owns the service
        nameservers = cfg.nameservers;
      };
    }

    (lib.mkIf cfg.networkManager.enable {
      networking.networkmanager.enable = true;
    })

    (lib.mkIf cfg.ssh.enable {
      services.openssh.enable = true;
    })

    (lib.mkIf cfg.avahi.enable {
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
    })

    (lib.mkIf cfg.bbr.enable {
      boot = {
        kernelModules = [ "tcp_bbr" ];
        kernel.sysctl = {
          "net.ipv4.tcp_congestion_control" = "bbr";
          "net.core.default_qdisc" = "cake";
        };
      };
    })

    (lib.mkIf cfg.mullvad.enable {
      services.mullvad-vpn.enable = true;
    })
  ];
}
