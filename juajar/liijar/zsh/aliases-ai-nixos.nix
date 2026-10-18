# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: NixOS-ONLY AI backend aliases. Only loaded when usrset.ai.enable.
# -=-=-=-=-=-=-=-=-=-=-=
{ hostnm }:
{
  rllm = "sudo systemctl restart llama-cpp";
  sllm = "sudo systemctl restart llama-cpp";
  stllm = "sudo systemctl start llama-cpp";
  rollm = "sudo systemctl restart ollama";
  sollm = "sudo systemctl start ollama";
  stollm = "sudo systemctl stop ollama ollama-model-loader; sudo systemctl stop open-webui 2>/dev/null || true";
}
