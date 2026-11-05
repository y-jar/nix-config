# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Ollama backend (sysset.ai.ollama options + service config).
# -=-=-=-=-=-=-=-=-=-=-=
# Configured by hosts in `sysset.ai.ollama`. Model availability lives in
# ./models.nix (ollamaSets curated registry); `ollama-model-loader.service`
# pulls activeModels in the background after every switch/boot.

{
  config,
  lib,
  pkgs,
  ...
}:

let
  aiCfg = config.sysset.ai;
  cfg = aiCfg.ollama;
  registry = import ./models.nix;

  ollamaPackage =
    if cfg.gpu == "rocm" then
      pkgs.ollama-rocm
    else if cfg.gpu == "cuda" then
      pkgs.ollama-cuda
    else if cfg.gpu == "vulkan" then
      pkgs.ollama-vulkan
    else
      pkgs.ollama-cpu;

  gpuModelSources = lib.unique (
    lib.mapAttrsToList (_: model: model.source) (
      lib.filterAttrs (_: model: model.target == "gpu") cfg.models
    )
  );

  activeOllamaModels =
    if cfg.modelSet == "small" then
      registry.ollamaSets.small
    else if cfg.modelSet == "medium" then
      registry.ollamaSets.medium
    else if cfg.modelSet == "large" then
      registry.ollamaSets.large
    else
      gpuModelSources;

  activeCpuModels = lib.unique (
    lib.mapAttrsToList (_: model: model.source) (
      lib.filterAttrs (_: model: model.target == "cpu") cfg.models
    )
  );

  gpuAliasNames = lib.attrNames (lib.filterAttrs (_: model: model.target == "gpu") cfg.models);
  cpuAliasNames = lib.attrNames (lib.filterAttrs (_: model: model.target == "cpu") cfg.models);

  # `ollama list` shows aliases with :latest, sources keep their own tag.
  withLatest = names: names ++ map (name: "${name}:latest") names;

  gpuAllowedModels = lib.unique (activeOllamaModels ++ withLatest gpuAliasNames);
  cpuAllowedModels = lib.unique (activeCpuModels ++ withLatest cpuAliasNames);

  ollamaHost = "http://127.0.0.1:${toString aiCfg.port}";
  cpuHost = "http://127.0.0.1:${toString cfg.cpu.port}";

  mkAliasCalls =
    target:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        name: alias:
        "create_alias ${
          lib.escapeShellArg (if target == "cpu" then cpuHost else ollamaHost)
        } ${lib.escapeShellArg alias.source} ${lib.escapeShellArg name} ${toString alias.num_ctx}"
      ) (lib.filterAttrs (_: model: model.target == target) cfg.models)
    );

  gpuAliasCalls = mkAliasCalls "gpu";
  cpuAliasCalls = mkAliasCalls "cpu";

  gpuAllowedFile = lib.optionalString cfg.autoPrune ''
    printf '%s\n' ${lib.escapeShellArgs gpuAllowedModels} > "$STATE/gpu.allowed"
  '';
  cpuAllowedFile = lib.optionalString cfg.autoPrune ''
    printf '%s\n' ${lib.escapeShellArgs cpuAllowedModels} > "$STATE/cpu.allowed"
  '';
  gpuPrune = lib.optionalString cfg.autoPrune ''
    prune_models ${lib.escapeShellArg ollamaHost} "$STATE/gpu.allowed"
  '';
  cpuPrune = lib.optionalString cfg.autoPrune ''
    prune_models ${lib.escapeShellArg cpuHost} "$STATE/cpu.allowed"
  '';
in
{
  options.sysset.ai.ollama = {
    enable = lib.mkEnableOption "Ollama server (multi-GPU capable local LLM backend)";
    gpu = lib.mkOption {
      type = lib.types.enum [
        "rocm"
        "cuda"
        "vulkan"
        "cpu"
      ];
      default = "rocm";
      description = "Ollama GPU backend: rocm (AMD), cuda (NVIDIA), vulkan, or cpu";
    }; # end of ollama.gpu
    contextLength = lib.mkOption {
      type = lib.types.int;
      default = 8192;
      description = "Default context length (OLLAMA_CONTEXT_LENGTH) for models served by Ollama";
    }; # end of ollama.contextLength
    devices = lib.mkOption {
      type = lib.types.str;
      default = "0,1";
      description = "Comma-separated GPU UUIDs/indices exposed to Ollama via ROCR_VISIBLE_DEVICES (prefer UUIDs; use to exclude iGPUs)";
    }; # end of ollama.devices
    modelSet = lib.mkOption {
      type = lib.types.enum [
        "small"
        "medium"
        "large"
        "custom"
      ];
      default = "medium";
      description = "Curated Ollama model set: small, medium, large, or custom (`custom` uses the `models` map)";
    }; # end of ollama.modelSet
    activeModels = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      readOnly = true;
      description = "Resolved Ollama model tags for the active modelSet";
    }; # end of ollama.activeModels
    syncModels = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Remove Ollama models not listed in the active set";
    }; # end of ollama.syncModels
    autoPrune = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Remove installed sources and aliases not declared in `models` (custom model set only). Unlike syncModels, this keeps generated aliases.";
    }; # end of ollama.autoPrune
    keepAlive = lib.mkOption {
      type = lib.types.str;
      default = "5m";
      description = "OLLAMA_KEEP_ALIVE value for loaded models";
    }; # end of ollama.keepAlive
    flashAttention = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "OLLAMA_FLASH_ATTENTION. Required for a quantized KV cache (kvCache != f16). Default true on ROCm hosts; disable only if the GPU/driver lacks flash-attention support.";
    }; # end of ollama.flashAttention
    kvCache = lib.mkOption {
      type = lib.types.enum [
        "f16"
        "q8_0"
        "q4_0"
      ];
      default = "q4_0";
      description = "OLLAMA_KV_CACHE_TYPE. q4_0 shrinks the KV cache about 4x vs f16 and is the default for long context on 16GB cards; q8_0 is a quality/size middle ground; f16 needs no flashAttention.";
    }; # end of ollama.kvCache
    maxLoadedModels = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = "OLLAMA_MAX_LOADED_MODELS. 1 keeps a single model resident so a second model cannot evict the main one on a small GPU; raise only with enough VRAM.";
    }; # end of ollama.maxLoadedModels
    numParallel = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = "OLLAMA_NUM_PARALLEL. Concurrent requests per loaded model; every slot multiplies KV-cache VRAM, so keep this at 1 on 16GB.";
    }; # end of ollama.numParallel

    models = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            source = lib.mkOption {
              type = lib.types.str;
              description = "Ollama tag to pull and alias, e.g. hf.co/unsloth/gemma-4-E2B-it-GGUF:Q4_K_M.";
            };
            num_ctx = lib.mkOption {
              type = lib.types.int;
              description = "Context length baked into the alias Modelfile (PARAMETER num_ctx). Requests without num_ctx inherit it.";
            };
            display = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Optional user-facing name in opencode/Hermes. Defaults to the attribute name (the nickname). The real Ollama tag is <nickname>:latest.";
            };
            target = lib.mkOption {
              type = lib.types.enum [
                "gpu"
                "cpu"
              ];
              default = "gpu";
              description = "Which server owns the source and creates the alias: the GPU instance (ai.port) or the CPU sidecar (cpu.port). CPU targets require cpu.enable = true.";
            };
            weightsMB = lib.mkOption {
              type = lib.types.nullOr lib.types.int;
              default = null;
              description = "Optional GGUF size in MB. Set together with kvMBPer1k to enable the build-time VRAM budget check; omit to let Ollama offload at runtime.";
            };
            kvFixedMB = lib.mkOption {
              type = lib.types.nullOr lib.types.int;
              default = 0;
              description = "Optional KV cache that does not scale with context (sliding-window layers at window size). Defaults to 0; only used when weightsMB and kvMBPer1k are set.";
            };
            kvMBPer1k = lib.mkOption {
              type = lib.types.nullOr lib.types.float;
              default = null;
              description = "Optional KV-cache growth per 1000 tokens for full-attention layers. Set together with weightsMB to enable the VRAM check.";
            };
          };
        }
      );
      default = { };
      description = ''
        Per-model definitions: the attribute name is the nickname, which is also
        the Ollama tag and the opencode model id (`<nickname>:latest`). Each
        entry creates/updates an alias with `FROM <source>` + `PARAMETER num_ctx
        <num_ctx>`, so the same weights can be served at different context
        lengths without changing the global default.

        When `modelSet = "custom"`, the unique `source` values (split by target)
        become the GPU/CPU pull lists. Duplicate sources are allowed: the same
        weights at two `num_ctx` values, or once `gpu` and once `cpu`.

        The footprint fields (`weightsMB`, `kvFixedMB`, `kvMBPer1k`) are
        optional. When both `weightsMB` and `kvMBPer1k` are set, the eval check
        verifies `weights + KV(num_ctx) <= vramBudgetMB` for gpu-target models.
        Omit them to skip that check; Ollama then offloads layers to RAM/CPU as
        needed at runtime.

        Nicknames must be lowercase `[a-z0-9][a-z0-9._-]*` and must not collide
        with another nickname or a source tag.
      '';
    }; # end of ollama.models
    smallModel = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Nickname (preferred) or source tag for opencode's small_model and lightweight subagents. If a source tag matches a `models` entry, its nickname is used.";
    }; # end of ollama.smallModel
    mainModel = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Nickname or source tag of the primary chat model. Used by the Hermes seed and as the comparison point for smallModel.";
    }; # end of ollama.mainModel
    vramBudgetMB = lib.mkOption {
      type = lib.types.int;
      default = 15000;
      description = "Usable VRAM budget in MB for the eval-time per-model check. Keep it below the card total to leave room for the compositor and compute buffers (16GB 9070 XT: ~15000 is realistic).";
    }; # end of ollama.vramBudgetMB
    cpu = {
      enable = lib.mkEnableOption "a second, CPU-only Ollama instance for small models (keeps GPU VRAM for the main model)";
      port = lib.mkOption {
        type = lib.types.port;
        default = 11435;
        description = "Port for the CPU sidecar (the GPU instance stays on ai.port).";
      };
      modelsDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/ollama-cpu/models";
        description = "Separate model store for the sidecar. Do not share the GPU store: the server writes locks/temp files during load.";
      };
      keepAlive = lib.mkOption {
        type = lib.types.str;
        default = "1h";
        description = "OLLAMA_KEEP_ALIVE for the sidecar. It uses RAM, so keeping small models hot is cheap.";
      };
      contextLength = lib.mkOption {
        type = lib.types.int;
        default = 32768;
        description = "OLLAMA_CONTEXT_LENGTH for the sidecar; per-model num_ctx still overrides.";
      };
    }; # end of ollama.cpu
  }; # end of ollama options

  # Ollama only when ai.enable AND ai.ollama.enable
  config = lib.mkIf (aiCfg.enable && cfg.enable) {
    services.ollama = {
      enable = true;
      package = ollamaPackage;
      inherit (aiCfg) host;
      inherit (aiCfg) port;
      openFirewall = lib.mkIf (aiCfg.host == "0.0.0.0") true;
      loadModels = activeOllamaModels;
      syncModels = cfg.syncModels;
      environmentVariables = {
        OLLAMA_CONTEXT_LENGTH = toString cfg.contextLength;
        OLLAMA_KEEP_ALIVE = cfg.keepAlive;
        OLLAMA_MAX_LOADED_MODELS = toString cfg.maxLoadedModels;
        OLLAMA_NUM_PARALLEL = toString cfg.numParallel;
      }
      // lib.optionalAttrs cfg.flashAttention {
        OLLAMA_FLASH_ATTENTION = "1";
      }
      // lib.optionalAttrs (cfg.kvCache != "f16") {
        OLLAMA_KV_CACHE_TYPE = cfg.kvCache;
      }
      // lib.optionalAttrs (cfg.gpu == "rocm" && cfg.devices != "") {
        ROCR_VISIBLE_DEVICES = cfg.devices;
      };
    }; # end of ollama config

    # [aliases] per-model num_ctx wrappers (FROM <source> + PARAMETER num_ctx).
    # Each alias polls for its own source (up to 30 min), so this is immune to
    # loader restart/activating states and slow pulls. Missing sources are
    # skipped, never fatal. No RemainAfterExit: a loader (re)start re-runs it.
    systemd.services.ollama-model-aliases = lib.mkIf (cfg.models != { }) {
      description = "Create/update Ollama model aliases with per-model num_ctx";
      wantedBy = [
        "ollama.service"
        "ollama-model-loader.service"
      ]
      ++ lib.optional cfg.cpu.enable "ollama-cpu-model-loader.service";
      after = [
        "ollama.service"
        "ollama-model-loader.service"
      ]
      ++ lib.optional cfg.cpu.enable "ollama-cpu-model-loader.service";
      bindsTo = [ "ollama.service" ];
      # A switch that changes the model map re-runs this unit even if the
      # loaders did not restart.
      restartTriggers = [ (builtins.toJSON cfg.models) ];
      path = [
        ollamaPackage
        pkgs.coreutils
        pkgs.gnugrep
        pkgs.gawk
      ];
      serviceConfig = {
        # The script polls up to 30 min for late-pulled sources. Keep it out of
        # switch-to-configuration: a oneshot here blocks nht/nhs on model changes.
        Type = "exec";
        StateDirectory = "ollama-aliases";
      };
      script = ''
        set -eu
        OLLAMA_BIN=${ollamaPackage}/bin/ollama
        STATE=/var/lib/ollama-aliases
        mkdir -p "$STATE"

        # Wait for the GPU API itself before asking it for the model list.
        export OLLAMA_HOST=${lib.escapeShellArg ollamaHost}
        tries=0
        until "$OLLAMA_BIN" list >/dev/null 2>&1; do
          tries=$((tries + 1))
          [ "$tries" -ge 60 ] && break
          sleep 1
        done

        create_alias() {
          host="$1"
          source="$2"
          name="$3"
          ctx="$4"
          export OLLAMA_HOST="$host"
          # Poll for this specific source instead of trusting loader state:
          # Type=exec loaders pass through activating/restarting windows where
          # `systemctl is-active` is false even though a pull is in progress.
          tries=0
          until "$OLLAMA_BIN" list 2>/dev/null | awk 'NR > 1 {print $1}' | grep -qxF "$source"; do
            tries=$((tries + 1))
            if [ "$tries" -ge 360 ]; then
              echo "skip (source not pulled after wait): $source"
              return 0
            fi
            sleep 5
          done
          modelfile="$(mktemp)"
          printf 'FROM %s\nPARAMETER num_ctx %s\n' "$source" "$ctx" > "$modelfile"
          echo "alias: $source -> $name (num_ctx=$ctx)"
          "$OLLAMA_BIN" create "$name" -f "$modelfile"
          rm -f "$modelfile"
        }

        prune_models() {
          host="$1"
          allowed="$2"
          export OLLAMA_HOST="$host"
          "$OLLAMA_BIN" list 2>/dev/null | awk 'NR > 1 {print $1}' | while IFS= read -r model; do
            [ -z "$model" ] && continue
            if grep -qxF "$model" "$allowed"; then
              continue
            fi
            echo "prune: $model"
            "$OLLAMA_BIN" rm "$model" || true
          done
        }

        ${gpuAllowedFile}
        ${gpuPrune}
        ${gpuAliasCalls}

        ${lib.optionalString cfg.cpu.enable ''
          ${cpuAllowedFile}
          ${cpuPrune}
          ${cpuAliasCalls}
        ''}
      '';
    };

    # Run alias creation when the GPU pull list finishes. Type=exec loaders
    # have no completion dependency, so use systemd's OnSuccess.
    systemd.services.ollama-model-loader =
      lib.mkIf (cfg.models != { } && (activeOllamaModels != [ ] || cfg.syncModels))
        {
          onSuccess = [ "ollama-model-aliases.service" ];
        };

    # [cpu sidecar] a second Ollama instance on CPU for small models. Separate
    # store and port so it never competes with the GPU instance for VRAM.
    systemd.services.ollama-cpu = lib.mkIf cfg.cpu.enable {
      description = "Ollama CPU sidecar (small models, separate store)";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      path = [ pkgs.ollama-cpu ];
      environment = {
        # DynamicUser has no HOME; Ollama refuses to start without one.
        HOME = "/var/lib/ollama-cpu";
        OLLAMA_HOST = "127.0.0.1:${toString cfg.cpu.port}";
        OLLAMA_MODELS = cfg.cpu.modelsDir;
        OLLAMA_CONTEXT_LENGTH = toString cfg.cpu.contextLength;
        OLLAMA_KEEP_ALIVE = cfg.cpu.keepAlive;
        OLLAMA_MAX_LOADED_MODELS = "1";
        OLLAMA_NUM_PARALLEL = "1";
      };
      serviceConfig = {
        ExecStart = "${pkgs.ollama-cpu}/bin/ollama serve";
        StateDirectory = "ollama-cpu";
        DynamicUser = true;
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };

    # Pull the CPU-target sources into the sidecar's separate store.
    systemd.services.ollama-cpu-model-loader = lib.mkIf (cfg.cpu.enable && activeCpuModels != [ ]) {
      description = "Pull Ollama CPU sidecar models";
      wantedBy = [ "ollama-cpu.service" ];
      after = [
        "ollama-cpu.service"
        "network-online.target"
      ];
      wants = [ "network-online.target" ];
      bindsTo = [ "ollama-cpu.service" ];
      # Alias creation also runs when this pull list finishes.
      onSuccess = [ "ollama-model-aliases.service" ];
      path = [
        pkgs.ollama-cpu
        pkgs.coreutils
      ];
      environment = {
        # The ollama CLI panics in envconfig.Models() without HOME, even though
        # the pull itself is performed by the sidecar server over HTTP.
        HOME = "/var/lib/ollama-cpu";
        OLLAMA_HOST = "http://127.0.0.1:${toString cfg.cpu.port}";
        OLLAMA_MODELS = cfg.cpu.modelsDir;
      };
      serviceConfig = {
        Type = "oneshot";
        Restart = "on-failure";
        RestartSec = "5s";
      };
      script = ''
        ${lib.concatMapStringsSep "\n" (
          source: "${pkgs.ollama-cpu}/bin/ollama pull ${lib.escapeShellArg source}"
        ) activeCpuModels}
      '';
    };

    systemd.services.ollama.serviceConfig = {
      SupplementaryGroups = lib.mkForce [
        "render"
        "video"
      ];
    };
    boot.initrd.kernelModules = lib.mkIf (cfg.gpu == "rocm") [ "amdgpu" ];
    sysset.ai.ollama.activeModels = activeOllamaModels;
  }; # end of ollama config
}
