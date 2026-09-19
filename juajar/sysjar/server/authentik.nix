# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Self-hosted authentik SSO/IdP (login provider for outline & friends).
# -=-=-=-=-=-=-=-=-=-=-=
# module source: github:nix-community/authentik-nix (nixpkgs ships the package
# but no services.authentik module; the flake pins its own nixpkgs on purpose).
# first boot: fully hands-off. the env-gen unit auto-creates a root-only
# /var/lib/authentik/env with a random secret key + akadmin bootstrap password
# + an API bootstrap token. to see the akadmin password once:
#   sudo grep AUTHENTIK_BOOTSTRAP_PASSWORD /var/lib/authentik/env
# (want your own password instead? create that file yourself before first
# boot - the unit only writes it when missing.)
# OIDC endpoints for clients (e.g. outline):
#   authorize: http://<host>:9000/application/o/authorize/
#   token:     http://<host>:9000/application/o/token/
#   userinfo:  http://<host>:9000/application/o/userinfo/
# secrets: AUTHENTIK_SECRET_KEY is auto-generated into the environmentFile on
# first boot if the file is missing (generated on the host, never in the store).
{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.sysset.server.authentik;
in
{
  imports = [ inputs.authentik-nix.nixosModules.default ];

  options = {
    sysset.server.authentik = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable authentik SSO IdP (local postgres, port 9000, ~1.5GiB)";
      }; # end of enable
      port = lib.mkOption {
        type = lib.types.port;
        default = 9000;
        description = "Port for the authentik web UI/API";
      }; # end of port
      environmentFile = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/authentik/env";
        description = "systemd EnvironmentFile holding AUTHENTIK_SECRET_KEY (auto-generated if missing)";
      }; # end of environmentFile
      extraConfig = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        description = ''
          Extra options passed straight to services.authentik
          (settings, nginx, ...).
        '';
      }; # end of extraConfig
    }; # end of sysset.server.authentik
  }; # end of options

  config = lib.mkIf cfg.enable {
    # [the IdP itself]
    services.authentik = lib.mkMerge [
      {
        enable = true;
        environmentFile = cfg.environmentFile;
        # NOTE: 2026.8+ config loader wants listen.http as a *sequence*
        # (env vars get comma-split leniently, but the yaml file is strict)
        settings.listen.http = [ "0.0.0.0:${toString cfg.port}" ];
      }
      cfg.extraConfig
    ]; # end of services.authentik

    # [secret bootstrap: generate the env file on the host if it doesn't exist]
    # (bootstrap vars are only read by authentik on its very first startup;
    # values are generated on the host at runtime - nothing lands in the store)
    systemd.services.authentik-env = {
      description = "authentik: generate secret env file if missing";
      wantedBy = [ "multi-user.target" ];
      before = [
        "authentik.service"
        "authentik-migrate.service"
        "authentik-worker.service"
      ];
      unitConfig.ConditionPathExists = "!${cfg.environmentFile}";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.writeShellScript "authentik-env-gen" ''
          umask 077
          mkdir -p "$(dirname "${cfg.environmentFile}")"
          {
            # app secret (same recipe as upstream docs)
            echo "AUTHENTIK_SECRET_KEY=$(${lib.getExe pkgs.openssl} rand -base64 60 | tr -d '\n')"
            # akadmin bootstrap password (auto-generated: sudo grep it once)
            echo "AUTHENTIK_BOOTSTRAP_PASSWORD=$(${lib.getExe pkgs.openssl} rand -hex 12)"
            # api bearer token for the oidc provisioner (max key length is 60)
            echo "AUTHENTIK_BOOTSTRAP_TOKEN=$(${lib.getExe pkgs.openssl} rand -hex 30)"
            echo "AUTHENTIK_BOOTSTRAP_EMAIL=akadmin@localhost"
          } > "${cfg.environmentFile}"
        ''}";
      }; # end of serviceConfig
    }; # end of authentik-env

    # [firewall]
    networking.firewall.allowedTCPPorts = [ cfg.port ];
  }; # end of config
} # end of End
