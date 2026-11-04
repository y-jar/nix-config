# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Hermes Agent system-side seed (user service) for the local Ollama backend.
# -=-=-=-=-=-=-=-=-=-=-=
# Hermes is packaged by its own flake; the user packages live in
# juajar/liijar/ai/default.nix. This module only seeds ~/.hermes/config.yaml
# once, so `hermes model` can still rewrite it afterwards. It never manages the
# file declaratively after the first write.

{
  config,
  lib,
  pkgs,
  ...
}:

let
  ai = config.sysset.ai;
  ollama = ai.ollama;
  aliases = ollama.models;
  main = ollama.mainModel;
  mainAlias = if main != null && builtins.hasAttr main aliases then aliases.${main} else null;
  fallbackAlias = if aliases != { } then builtins.head (lib.attrNames aliases) else null;

  # Prefer the declared main alias; fall back to the first alias, then to the
  # historical 9B default. A source tag (not a nickname) is used verbatim.
  modelTag =
    if mainAlias != null then
      "${main}:latest"
    else if main != null then
      main
    else if fallbackAlias != null then
      "${fallbackAlias}:latest"
    else
      "qwen3.5:9b";
  modelCtx =
    if mainAlias != null then
      mainAlias.num_ctx
    else if fallbackAlias != null then
      aliases.${fallbackAlias}.num_ctx
    else
      ollama.contextLength;

  seed = pkgs.writeText "hermes-config.yaml" ''
    # Seeded once by NixOS; Hermes owns this file afterwards.
    model:
      provider: custom
      default: ${modelTag}
      base_url: http://127.0.0.1:${toString ai.port}/v1
      context_length: ${toString modelCtx}
  '';
in
{
  options.sysset.ai.hermes.enable =
    lib.mkEnableOption "seed the Hermes Agent config for the main user";

  config = lib.mkIf config.sysset.ai.hermes.enable {
    systemd.user.services.hermes-config-seed = {
      description = "Seed ~/.hermes/config.yaml if it does not exist";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      unitConfig = {
        # systemd.user.services is global; seed only the primary user.
        ConditionUser = config.sysset.mainUser;
      };
      script = ''
        mkdir -p "$HOME/.hermes"
        if [ ! -e "$HOME/.hermes/config.yaml" ]; then
          cp ${seed} "$HOME/.hermes/config.yaml"
          chmod 0660 "$HOME/.hermes/config.yaml"
        fi
      '';
    };
  };
}
