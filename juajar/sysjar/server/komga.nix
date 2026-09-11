# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Komga manga/comic server.
# -=-=-=-=-=-=-=-=-=-=-=
{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.sysset.server.komga;
in
{
  options = {
    sysset.server.komga = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Komga media server (port 25600)";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 25600 ];

    systemd.services.komga = {
      description = "Komga - Media server for comics, manga, and other media";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        User = config.sysset.mainUser;
        ExecStart = "${pkgs.komga}/bin/komga --server.address=0.0.0.0 --server.port=25600";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
