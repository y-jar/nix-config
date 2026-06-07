{
  pkgs,
  ...
}:
{
  imports = [
    ./audio-itoyu.nix
  ];
  # This will load my prefered settings for audio and hopefully prevent issues
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true; # <-- I need this for some games
    pulse.enable = true; # enables PulseAudio translation
    jack.enable = true; # enables JACK translation
  };

  # hardware 32-bit audio support is enabled globally
  services.pulseaudio = {
    enable = false;
    support32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    pulseaudioFull # full pulseaudio libs for compatibility
  ];
}
