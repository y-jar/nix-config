# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Self-hosted Outline wiki/knowledge base server.
# -=-=-=-=-=-=-=-=-=-=-=
# ref: https://wiki.nixos.org/wiki/Outline
# stack: local postgres + local redis + local file storage (no S3 needed).
# secrets: app keys are auto-generated at /var/lib/outline/ on first boot.
# login: Outline has no local passwords; it needs an SSO provider. with
# authentik enabled on the same host, setting `extraConfig.oidcAuthentication`
# is fully hands-off: the outline-oidc-provision unit creates the authentik
# OAuth2 provider + application (incl. the custom email_verified scope mapping
# that outline requires) via authentik's API, writes the client secret to the
# clientSecretFile path (0640 root:outline), and restarts outline. it is
# idempotent and self-healing; retry after a failed first run with:
#   systemctl start outline-oidc-provision
# ref: https://integrations.goauthentik.io/documentation/outline/
{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.sysset.server.outline;

  # [oidc passthrough] read the oidc settings the host sheet wired (if any)
  oidcAuth =
    if (cfg.extraConfig ? oidcAuthentication) then cfg.extraConfig.oidcAuthentication else null;
  oidcSecretFile =
    if (oidcAuth != null && oidcAuth ? clientSecretFile) then oidcAuth.clientSecretFile else null;
  oidcClientId = if (oidcAuth != null && oidcAuth ? clientId) then oidcAuth.clientId else null;

  # [authentik neighbor] (same server block, option always declared)
  authentikCfg = config.sysset.server.authentik;

  # [auto provisioning] only when outline+authentik run together and oidc is wired
  provision =
    cfg.enable
    && oidcAuth != null
    && oidcClientId != null
    && oidcSecretFile != null
    && authentikCfg.enable;

  # [browser-facing callback] outline's oidc callback on our public url
  callback = (lib.removeSuffix "/" cfg.publicUrl) + "/auth/oidc.callback";
in
{
  options = {
    sysset.server.outline = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Outline wiki server (local postgres+redis, ~500MiB)";
      }; # end of enable
      port = lib.mkOption {
        type = lib.types.port;
        default = 3000;
        description = "Port for Outline (note: clashes with nixdraw's default 3000)";
      }; # end of port
      publicUrl = lib.mkOption {
        type = lib.types.str;
        default = "http://localhost:3000";
        description = "The fully qualified URL users browse Outline from (SSO redirects must match it)";
      }; # end of publicUrl
      extraConfig = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        description = ''
          Extra options passed straight to services.outline
          (oidcAuthentication, smtp, cdnUrl, ...).
        '';
      }; # end of extraConfig
    }; # end of sysset.server.outline
  }; # end of options

  config = lib.mkIf cfg.enable {
    # [the wiki itself]
    services.outline = lib.mkMerge [
      {
        enable = true;
        port = cfg.port;
        publicUrl = cfg.publicUrl;
        databaseUrl = "local"; # spins up local postgres + outline db
        redisUrl = "local"; # local redis over a unix socket (no extra port)
        storage.storageType = "local"; # attachments on disk (no S3/MinIO)
        forceHttps = false; # plain http on LAN; flip when behind TLS
      }
      cfg.extraConfig
    ]; # end of services.outline

    # [oidc secret file placeholder] (the provisioner writes the real secret in)
    systemd.tmpfiles.rules =
      lib.optionals (oidcSecretFile != null && !lib.hasPrefix "/nix/store/" oidcSecretFile)
        [
          "f ${oidcSecretFile} 0640 root ${config.services.outline.group} -"
        ]; # end of tmpfiles

    # [wire oidc into authentik: idempotent, self-healing provisioner]
    systemd.services.outline-oidc-provision = lib.mkIf provision {
      description = "outline: wire OIDC into authentik (idempotent)";
      wantedBy = [ "multi-user.target" ];
      after = [ "authentik.service" ];
      wants = [ "authentik.service" ];
      path = [
        pkgs.curl
        pkgs.jq
        pkgs.openssl
        pkgs.coreutils
        pkgs.systemd
      ];
      serviceConfig = {
        Type = "oneshot";
        PrivateTmp = true;
      }; # end of serviceConfig
      script = ''
        set -euo pipefail

        # --[inputs (from nix)]--
        CLIENT_ID=${lib.escapeShellArg oidcClientId}
        SECRET_FILE=${lib.escapeShellArg oidcSecretFile}
        CALLBACK=${lib.escapeShellArg callback}
        ENV_FILE=${lib.escapeShellArg authentikCfg.environmentFile}
        API_BASE="http://localhost:${toString authentikCfg.port}"
        OUTLINE_GROUP=${lib.escapeShellArg config.services.outline.group}
        PROV_NAME="outline"
        APP_SLUG="outline"
        KEY_NAME="jar-outline-oidc-signing"
        EMAIL_MAP_NAME="jar: outline email (verified)"
        FLOW_SLUG="default-provider-authorization-implicit-consent"

        # --[already provisioned? instant exit]--
        if [ -s "$SECRET_FILE" ]; then
          echo "outline-oidc-provision: already provisioned, nothing to do"
          exit 0
        fi

        # --[bootstrap token from authentik's root-only env file]--
        TOKEN=$(sed -n 's/^AUTHENTIK_BOOTSTRAP_TOKEN=//p' "$ENV_FILE" || true)
        if [ -z "$TOKEN" ]; then
          echo "outline-oidc-provision: no AUTHENTIK_BOOTSTRAP_TOKEN in $ENV_FILE" >&2
          exit 1
        fi

        # --[api helpers]--
        api_get() {
          curl -s -H "Authorization: Bearer $TOKEN" "$1" || true
        }
        post_json() {
          curl -s -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d "$2" "$1" || true
        }
        patch_json() {
          curl -s -X PATCH -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d "$2" "$1" || true
        }
        # first_pk URL KEY VALUE -> pk of first list entry where entry[KEY] == VALUE
        first_pk() {
          api_get "$1" | jq -r --arg k "$2" --arg v "$3" '.results[]? | select(.[$k]==$v) | .pk' | head -n1 || true
        }

        # --[wait for authentik: token accepted + default blueprints imported]--
        FLOW_PK=""
        AUTH_REJECTS=0
        for i in $(seq 1 60); do
          CODE=$(curl -s -o /dev/null -w '%{http_code}' -H "Authorization: Bearer $TOKEN" "$API_BASE/api/v3/core/applications/" 2>/dev/null || true)
          CODE=$(printf '%s' "$CODE" | tr -d '[:space:]')
          if [ -z "$CODE" ]; then CODE="000"; fi
          if [ "$CODE" = "401" ] || [ "$CODE" = "403" ]; then
            # authentik can answer 401/403 briefly while it finishes booting,
            # so only give up after several consecutive rejections
            AUTH_REJECTS=$((AUTH_REJECTS + 1))
            if [ "$AUTH_REJECTS" -ge 5 ]; then
              echo "outline-oidc-provision: bootstrap token rejected ($CODE, $AUTH_REJECTS tries); was authentik's first start done without it?" >&2
              exit 1
            fi
          else
            AUTH_REJECTS=0
          fi
          if [ "$CODE" = "200" ]; then
            FLOW_PK=$(api_get "$API_BASE/api/v3/flows/instances/" | jq -r --arg s "$FLOW_SLUG" '.results[]? | select(.slug==$s) | .pk' | head -n1 || true)
            if [ -n "$FLOW_PK" ]; then break; fi
          fi
          echo "outline-oidc-provision: waiting for authentik ($i/60)..."
          sleep 10
        done
        if [ -z "$FLOW_PK" ]; then
          echo "outline-oidc-provision: authentik never became ready" >&2
          exit 1
        fi

        # --[signing keypair (RS256 id tokens; created if missing)]--
        KEY_PK=$(first_pk "$API_BASE/api/v3/crypto/certificatekeypairs/" name "$KEY_NAME")
        if [ -z "$KEY_PK" ]; then
          TMPD=$(mktemp -d)
          openssl req -x509 -newkey rsa:2048 -nodes -days 3650 \
            -subj "/CN=jar outline oidc signing" -keyout "$TMPD/key.pem" -out "$TMPD/cert.pem" 2>/dev/null
          RESP=$(post_json "$API_BASE/api/v3/crypto/certificatekeypairs/" "$(jq -n \
            --arg n "$KEY_NAME" --arg c "$(cat "$TMPD/cert.pem")" --arg k "$(cat "$TMPD/key.pem")" \
            '{name:$n, certificate_data:$c, key_data:$k}')")
          rm -rf "$TMPD"
          KEY_PK=$(printf '%s' "$RESP" | jq -r '.pk // empty' 2>/dev/null || true)
          if [ -z "$KEY_PK" ]; then
            echo "outline-oidc-provision: keypair create failed: $RESP" >&2
            exit 1
          fi
        fi

        # --[custom email scope mapping (outline needs email_verified: true)]--
        # NOTE: 2026.8 moved scope mappings to propertymappings/provider/scope
        MAP_PK=$(first_pk "$API_BASE/api/v3/propertymappings/provider/scope/" name "$EMAIL_MAP_NAME")
        if [ -z "$MAP_PK" ]; then
          RESP=$(post_json "$API_BASE/api/v3/propertymappings/provider/scope/" "$(jq -n \
            --arg n "$EMAIL_MAP_NAME" \
            --arg e 'return {"email": request.user.email, "email_verified": True}' \
            '{name:$n, scope_name:"email", description:"email + email_verified=true (outline requirement)", expression:$e}')")
          MAP_PK=$(printf '%s' "$RESP" | jq -r '.pk // empty' 2>/dev/null || true)
          if [ -z "$MAP_PK" ]; then
            echo "outline-oidc-provision: scope mapping create failed: $RESP" >&2
            exit 1
          fi
        fi

        # --[scopes: default openid+profile mappings plus the custom email one]--
        DEF_PKS=$(api_get "$API_BASE/api/v3/propertymappings/provider/scope/" | jq -r \
          '[.results[]? | select(.scope_name=="openid" or .scope_name=="profile") | .pk]' 2>/dev/null || true)
        if [ -z "$DEF_PKS" ] || [ "$DEF_PKS" = "[]" ]; then
          echo "outline-oidc-provision: no openid/profile scope mappings found (did the worker import default blueprints?)" >&2
          exit 1
        fi
        PROPS=$(jq -n --argjson d "$DEF_PKS" --arg m "$MAP_PK" '$d + [$m]')

        # --[the oauth2 provider itself]--
        CLIENT_SECRET=$(openssl rand -hex 32)
        PAYLOAD=$(jq -n \
          --arg name "$PROV_NAME" --arg flow "$FLOW_PK" --arg cid "$CLIENT_ID" --arg cs "$CLIENT_SECRET" \
          --arg cb "$CALLBACK" --arg key "$KEY_PK" --argjson props "$PROPS" \
          '{
            name: $name,
            authorization_flow: $flow,
            client_type: "confidential",
            client_id: $cid,
            client_secret: $cs,
            redirect_uris: [{matching_mode: "strict", url: $cb, redirect_uri_type: "authorization"}],
            sub_mode: "user_username",
            include_claims_in_id_token: true,
            signing_key: (if $key == "" then null else $key end),
            property_mappings: $props
          }')
        PROV_PK=$(first_pk "$API_BASE/api/v3/providers/oauth2/" name "$PROV_NAME")
        if [ -n "$PROV_PK" ]; then
          patch_json "$API_BASE/api/v3/providers/oauth2/$PROV_PK/" "$PAYLOAD" >/dev/null
        else
          RESP=$(post_json "$API_BASE/api/v3/providers/oauth2/" "$PAYLOAD")
          PROV_PK=$(printf '%s' "$RESP" | jq -r '.pk // empty' 2>/dev/null || true)
          if [ -z "$PROV_PK" ]; then
            echo "outline-oidc-provision: provider create failed: $RESP" >&2
            exit 1
          fi
        fi

        # --[the application entry that exposes the provider]--
        APP_PK=$(first_pk "$API_BASE/api/v3/core/applications/" slug "$APP_SLUG")
        APP_PAYLOAD=$(jq -n --arg p "$PROV_PK" '{name:"Outline", slug:"outline", provider:$p}')
        if [ -n "$APP_PK" ]; then
          patch_json "$API_BASE/api/v3/core/applications/$APP_PK/" "$APP_PAYLOAD" >/dev/null
        else
          RESP=$(post_json "$API_BASE/api/v3/core/applications/" "$APP_PAYLOAD")
          if ! printf '%s' "$RESP" | jq -e '.pk' >/dev/null; then
            echo "outline-oidc-provision: application create failed: $RESP" >&2
            exit 1
          fi
        fi

        # --[hand the secret to outline, then restart it to pick the secret up]--
        if [ ! -f "$SECRET_FILE" ]; then
          install -D -m 0640 -o root -g "$OUTLINE_GROUP" /dev/null "$SECRET_FILE"
        fi
        printf '%s' "$CLIENT_SECRET" > "$SECRET_FILE"
        systemctl restart outline.service
        echo "outline-oidc-provision: outline <-> authentik wired (client: $CLIENT_ID)"
      ''; # end of script
    }; # end of outline-oidc-provision

    # [outline waits for provisioning before its first start]
    systemd.services.outline = lib.mkIf provision {
      after = [ "outline-oidc-provision.service" ];
      wants = [ "outline-oidc-provision.service" ];
    }; # end of outline ordering

    # [firewall]
    networking.firewall.allowedTCPPorts = [ cfg.port ];
  }; # end of config
} # end of End
