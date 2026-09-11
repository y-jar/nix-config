# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Dictation shared package bucket (voxtype + runtime deps + vtt).
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[liijar/dictation/shared.nix] =-=-=
# The dictation package list shared by both backends (HM hm.nix, hjem
# hjem.nix): voxtype + its runtime helpers + the `vtt` meeting-mode
# transcriber wrapper. The config file + service units stay per-backend
# (HM: systemd.user.services + xdg.configFile; hjem: raw unit files +
# dirSetup).
# =-=-=[end liijar/dictation/shared.nix] =-=-=
{
  pkgs,
  lib,
  ...
}:

{
  packages = with pkgs; [
    voxtype # local voice-to-text daemon (Whisper engine)
    wtype # Wayland typing (needed for output.mode = "type")
    wl-clipboard # clipboard fallback output
    libnotify # transcription notifications
    playerctl # auto-pause MPRIS media while recording
    (pkgs.writeShellScriptBin "vtt" ''
      # vtt - voxtype meeting-mode transcriber (continuous -> VTT/SRT/Markdown export)
      # usage: vtt <start|stop|export|help>
      case "''${1:-}" in
        start)
          shift
          exec ${lib.getExe pkgs.voxtype} meeting start "$@"
          ;;
        stop)
          shift
          exec ${lib.getExe pkgs.voxtype} meeting stop "$@"
          ;;
        export)
          shift
          exec ${lib.getExe pkgs.voxtype} meeting export --format vtt "$@"
          ;;
        help | -h | --help)
          echo "vtt - voxtype meeting transcriber"
          echo "  vtt start              begin a continuous transcription session"
          echo "  vtt stop               finish transcribing"
          echo "  vtt export [path]      export the last meeting as a .vtt transcript"
          echo "  vtt <args...>          pass through to 'voxtype meeting <args...>'"
          ;;
        *)
          exec ${lib.getExe pkgs.voxtype} meeting "$@"
          ;;
      esac
    '')
  ]; # end of packages
}
