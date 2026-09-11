# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: voxtype push-to-talk dictation + transcript.
# =-=-=[dictation] =-=-=
# User systemd units are not managed here, so the daemon + model bootstrap
# are shipped as plain unit files under ~/.config/systemd/user/ and enabled
# on login via the dirSetup (.profile) bootstrap (the bus is declared in
# liijar/profile-bus.nix).
# =-=-=[end dictation] =-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.dictation;

  # voxtype + its runtime helpers + the `vtt` meeting-mode transcriber wrapper
  dictationPackages = with pkgs; [
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
  ]; # end of dictationPackages

  runtimeBinPath = lib.makeBinPath [
    pkgs.voxtype
    pkgs.wtype
    pkgs.wl-clipboard
    pkgs.libnotify
    pkgs.playerctl
    pkgs.coreutils
    pkgs.bash
  ];

  voxtypeConfig = pkgs.writeText "voxtype-config.toml" ''
    state_file = "auto"

    [hotkey]
    enabled = true
    key = "F9"

    [audio]
    device = "default"
    sample_rate = 16000
    max_duration_secs = 60
    pause_media = true

    [whisper]
    model = "base.en"
    language = "en"

    [output]
    mode = "type"
    fallback_to_clipboard = true
    type_delay_ms = 1

    [output.notification]
    on_transcription = true
  '';

  voxtypeModelUnit = pkgs.writeText "voxtype-model.service" ''
    [Unit]
    Description=Voxtype whisper model bootstrap
    After=graphical-session-pre.target

    [Service]
    Type=oneshot
    RemainAfterExit=yes
    ExecStart=${pkgs.bash}/bin/bash -lc 'test -e "''${HOME}/.local/share/voxtype/models/ggml-base.en.bin" || ${lib.getExe pkgs.voxtype} setup --download --no-post-install'

    [Install]
    WantedBy=default.target
  '';

  voxtypeServiceUnit = pkgs.writeText "voxtype.service" ''
    [Unit]
    Description=Voxtype dictation daemon
    After=voxtype-model.service

    [Service]
    ExecStart=${lib.getExe pkgs.voxtype}
    Restart=on-failure
    RestartSec=3
    Environment=PATH=${runtimeBinPath}:/run/current-system/sw/bin

    [Install]
    WantedBy=default.target
  '';

  dirSetup = ''
    # [enable voxtype dictation user services]
    systemctl --user daemon-reload
    systemctl --user enable voxtype-model.service voxtype.service
  '';
in
{
  config = lib.mkIf cfg.enable {
    packages = dictationPackages;

    files = {
      ".config/voxtype/config.toml".source = voxtypeConfig;
      ".config/systemd/user/voxtype-model.service".source = voxtypeModelUnit;
      ".config/systemd/user/voxtype.service".source = voxtypeServiceUnit;
    };

    # append the enable step to the existing .profile dirSetup (idempotent)
    hjemDotfiles.dirSetup = lib.mkAfter dirSetup;
  };
}
