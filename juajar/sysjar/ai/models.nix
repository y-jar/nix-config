# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Shared model registry for both local backends (llama.cpp + ollama).
# -=-=-=-=-=-=-=-=-=-=-=
# Not a module: `import ./models.nix` returns a plain attrset.
#   - <set> = models.nix.ollamaSets.<set> in juajar/sysjar/ai/ollama.nix
#   - llama presets: `services.llama-cpp.modelsPreset = models.llamaPresets`
# Edit model availability here; hosts pick via `sysset.ai.ollama.modelSet`
# (or `customModels` for fully bespoke lists).
{
  # Curated ollama sets (modelSet = small | medium | large)
  ollamaSets = {
    small = [
      "qwen2.5-coder:7b"
      "qwen3.5:9b"
    ];
    medium = [
      "qwen2.5-coder:14b"
      "qwen3.5:9b"
    ];
    large = [
      "qwen2.5-coder:32b"
      "qwen3.5:27b"
      "qwen3:30b-a3b"
    ];
  }; # end of ollamaSets

  # llama.cpp presets: auto-downloaded from HuggingFace on first request
  # into /var/cache/llama-cpp ("hf-repo/hf-file", served under "alias")
  llamaPresets = {
    "qwen3.5-9b" = {
      hf-repo = "unsloth/Qwen3.5-9B-GGUF";
      hf-file = "Qwen3.5-9B-UD-Q4_K_XL.gguf";
      alias = "qwen3.5-9b"; # model ID served by the API (matches opencode)
      fit = "on";
    }; # end of qwen3.5-9b preset
  }; # end of llamaPresets
}
