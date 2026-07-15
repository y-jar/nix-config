{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sysSettings.audio; # shortens config.sysSettings.audio
in
{
  imports = [ ./addon.nix ];
  options = {
    sysSettings.audio = {
      enable = lib.mkEnableOption "Enable audio (~100MiB, PipeWire + tools)";
    }; # end of sysSettings.audio
  }; # end of options

  # config to enable audio
  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true; # <-- I need this for some games
      pulse.enable = true; # enables PulseAudio translation
      jack.enable = true; # enables JACK translation
    }; # end of services.pipewire

    # hardware 32-bit audio support is enabled globally
    services.pulseaudio = {
      enable = false;
      support32Bit = true;
    }; # end of services.pulseaudio

    environment.systemPackages = with pkgs; [
      pulseaudioFull # full pulseaudio libs for compatibility
      easyeffects # audio mixer
      qpwgraph # Qt graph manager for PipeWire, similar to QjackCtls
      pavucontrol # PulseAudio Volume Control
    ]; # end of environment.systemPackages
  }; # end of config
}
