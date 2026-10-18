# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: NixOS-ONLY AI backend gum menu (jai). Only loaded when usrset.ai.enable.
# -=-=-=-=-=-=-=-=-=-=-=
{ lib, pkgs, ... }:
let
  t = import ./ai-menu-text.nix;
  gum = "${pkgs.gum}/bin/gum";
  ollama = "${pkgs.ollama}/bin/ollama";
in
''
  jai() {
    local backend="" service=""
    if systemctl is-active --quiet ollama 2>/dev/null; then
      backend="ollama"; service="ollama"
    elif systemctl is-active --quiet llama-cpp 2>/dev/null; then
      backend="llama.cpp"; service="llama-cpp"
    fi

    while true; do
      local choice
      choice="$(${gum} choose --header="${t.menuPrompt}" \
        "${t.optStatus}" "${t.optToggle}" "${t.optDownload}" "${t.optRemove}" \
        "${t.optStopModel}" "${t.optLogs}" "${t.optExit}")"
      [[ -z "$choice" ]] && break

      case "$choice" in
        "${t.optStatus}")
          if [[ -z "$backend" ]]; then
            echo "${t.unavailable}"
          else
            echo "${t.labelBackend} $backend"
            if [[ "$backend" == "ollama" ]]; then
              echo "${t.labelRunning}"; ${ollama} ps
              echo "${t.labelInstalled}"; ${ollama} list
            else
              echo "  llama.cpp has no model management <3"
            fi
          fi
          ;;
        "${t.optToggle}")
          if [[ -n "$backend" ]]; then
            if sudo systemctl stop "$service"; then
              local msg="${t.toggleStopped}"; msg="''${msg//\{backend\}/$backend}"; echo "$msg"
              backend=""; service=""
            else
              local msg="${t.toggleFailed}"; msg="''${msg//\{backend\}/$backend}"; echo "$msg"
            fi
          else
            if sudo systemctl start ollama; then
              backend="ollama"; service="ollama"
              local msg="${t.toggleStarted}"; msg="''${msg//\{backend\}/$backend}"; echo "$msg"
            else
              local msg="${t.toggleFailed}"; msg="''${msg//\{backend\}/$backend}"; echo "$msg"
            fi
          fi
          ;;
        "${t.optDownload}")
          if [[ "$backend" != "ollama" ]]; then
            echo "${t.unavailable}"
            continue
          fi
          local model
          model="$(${gum} input --placeholder="${t.downloadPlaceholder}" --prompt="${t.downloadPrompt}")"
          [[ -z "$model" ]] && continue
          if ${ollama} pull "$model"; then
            local msg="${t.downloadSuccess}"; msg="''${msg//\{model\}/$model}"; echo "$msg"
          else
            local msg="${t.downloadFailure}"; msg="''${msg//\{model\}/$model}"; echo "$msg"
          fi
          ;;
        "${t.optRemove}")
          if [[ "$backend" != "ollama" ]]; then
            echo "${t.unavailable}"
            continue
          fi
          local models model
          models="$(${ollama} list | awk 'NR > 1 { print $1 }')"
          if [[ -z "$models" ]]; then
            echo "${t.removeNone}"
            continue
          fi
          model="$(${gum} choose --header="${t.removePrompt}" <<< "$models")"
          [[ -z "$model" ]] && continue
          local confirm
          confirm="${t.removeConfirm}"; confirm="''${confirm//\{model\}/$model}"
          if ${gum} confirm "$confirm"; then
            if ${ollama} rm "$model"; then
              local msg="${t.removeSuccess}"; msg="''${msg//\{model\}/$model}"; echo "$msg"
            else
              local msg="${t.removeFailure}"; msg="''${msg//\{model\}/$model}"; echo "$msg"
            fi
          fi
          ;;
        "${t.optStopModel}")
          if [[ "$backend" != "ollama" ]]; then
            echo "${t.unavailable}"
            continue
          fi
          local running model
          running="$(${ollama} ps | awk 'NR > 1 { print $1 }')"
          if [[ -z "$running" ]]; then
            echo "${t.stopNone}"
            continue
          fi
          model="$(${gum} choose --header="${t.stopPrompt}" <<< "$running")"
          [[ -z "$model" ]] && continue
          if ${ollama} stop "$model"; then
            local msg="${t.stopSuccess}"; msg="''${msg//\{model\}/$model}"; echo "$msg"
          else
            local msg="${t.stopFailure}"; msg="''${msg//\{model\}/$model}"; echo "$msg"
          fi
          ;;
        "${t.optLogs}")
          if [[ -z "$backend" ]]; then
            echo "${t.unavailable}"
          else
            local msg="${t.logsText}"; msg="''${msg//\{backend\}/$backend}"; echo "$msg"
            sudo journalctl -u "$service" -f
          fi
          ;;
        "${t.optExit}")
          break
          ;;
      esac
    done
  }
''
