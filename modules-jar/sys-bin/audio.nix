{ config, lib, pkgs, ... }:
{
  # This will load my prefered settings for audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}