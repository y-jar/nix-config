{ config, pkgs, ... }:

{
  # This part is the "Infrastructure" - it stays regardless of the app(though i got this for obs)
  boot.extraModulePackages = with config.boot.kernelPackages; [ 
    v4l2loopback 
  ];

  # load at boot
  boot.kernelModules = [ "v4l2loopback" ];

  # Configure the virtual Camera
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Virtual Camera" exclusive_caps=1
  '';

  # leaving 'environment.systemPackages' EMPTY here. So the user can choose to untilise it if
  # need be :)
}
