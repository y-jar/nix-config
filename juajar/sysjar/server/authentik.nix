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
# + an API bootstrap token + the declared admin email. the akadmin email is
# pinned to that declared value forever by the authentik-akadmin-email unit
# (bootstrap vars are only read on authentik's very first start).
# to see the akadmin password once:
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
      adminEmail = lib.mkOption {
        type = lib.types.str;
        default = "akadmin@${config.networking.hostName}.local";
        description = "Declared email for the akadmin user; must be dotted (outline's isEmail rejects single-label domains like @localhost)";
      }; # end of adminEmail
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
        inherit (cfg) environmentFile;
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
            # declared admin email (dotted - single-label domains break outline login)
            echo "AUTHENTIK_BOOTSTRAP_EMAIL=${cfg.adminEmail}"
          } > "${cfg.environmentFile}"
        ''}";
      }; # end of serviceConfig
    }; # end of authentik-env

    # [guard: single-label emails (akadmin@localhost) sail through authentik
    # but explode later in outline's isEmail (validator.js require_tld) - catch
    # them at eval time instead of at login time]
    assertions = [
      {
        assertion =
          (builtins.match "^[^@[:space:]]+@[^@[:space:]]+[.][^@[:space:]]+$" cfg.adminEmail) != null;
        message = "sysset.server.authentik.adminEmail must be a dotted address (e.g. akadmin@whale.local), got: ${cfg.adminEmail}";
      }
    ];

    # [akadmin email converge: bootstrap only reads AUTHENTIK_BOOTSTRAP_EMAIL on
    # authentik's very first start, so this unit pins akadmin to the declared
    # value on every boot - PATCH via API when it differs, instant no-op
    # otherwise. manual UI edits revert on the next run; change the nix option
    # instead.]
    systemd.services.authentik-akadmin-email = {
      description = "authentik: converge akadmin email to declared value";
      wantedBy = [ "multi-user.target" ];
      after = [ "authentik.service" ];
      wants = [ "authentik.service" ];
      path = [
        pkgs.curl
        pkgs.jq
        pkgs.coreutils
      ];
      serviceConfig = {
        Type = "oneshot";
        PrivateTmp = true;
      }; # end of serviceConfig
      script = ''
        set -euo pipefail

        # --[inputs (from nix)]--
        EMAIL=${lib.escapeShellArg cfg.adminEmail}
        ENV_FILE=${lib.escapeShellArg cfg.environmentFile}
        API_BASE="http://localhost:${toString cfg.port}"

        # --[bootstrap token from authentik's root-only env file]--
        TOKEN=$(sed -n 's/^AUTHENTIK_BOOTSTRAP_TOKEN=//p' "$ENV_FILE" || true)
        if [ -z "$TOKEN" ]; then
          echo "authentik-akadmin-email: no AUTHENTIK_BOOTSTRAP_TOKEN in $ENV_FILE" >&2
          exit 1
        fi

        # --[wait for authentik + akadmin: nothing orders after this unit, so a
        # generous loop costs nothing (max-time: a hung call must never wedge it)]--
        USER_JSON=""
        for i in $(seq 1 60); do
          USER_JSON=$(curl -s --max-time 30 -H "Authorization: Bearer $TOKEN" \
            "$API_BASE/api/v3/core/users/?username=akadmin" 2>/dev/null || true)
          if printf '%s' "$USER_JSON" | jq -e '.results[0].pk' >/dev/null 2>&1; then
            break
          fi
          USER_JSON=""
          echo "authentik-akadmin-email: waiting for authentik ($i/60)..."
          sleep 10
        done
        if [ -z "$USER_JSON" ]; then
          echo "authentik-akadmin-email: authentik/akadmin never became reachable" >&2
          exit 1
        fi

        # --[converge: patch only when the current value differs]--
        PK=$(printf '%s' "$USER_JSON" | jq -r '.results[0].pk')
        CURRENT=$(printf '%s' "$USER_JSON" | jq -r '.results[0].email // ""')
        if [ "$CURRENT" = "$EMAIL" ]; then
          echo "authentik-akadmin-email: already $EMAIL, nothing to do"
          exit 0
        fi
        RESP=$(curl -s --max-time 30 -X PATCH \
          -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
          -d "$(jq -n --arg e "$EMAIL" '{email:$e}')" \
          "$API_BASE/api/v3/core/users/$PK/")
        if ! printf '%s' "$RESP" | jq -e '.pk' >/dev/null 2>&1; then
          echo "authentik-akadmin-email: patch failed: $RESP" >&2
          exit 1
        fi
        echo "authentik-akadmin-email: akadmin email converged ($CURRENT -> $EMAIL)"
      ''; # end of script
    }; # end of authentik-akadmin-email

    # [firewall]
    networking.firewall.allowedTCPPorts = [ cfg.port ];
  }; # end of config
} # end of End
