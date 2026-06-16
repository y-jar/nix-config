{
  config,
  pkgs,
  lib,
  ...
}:

# This file is used for the Gyro issue and other issues that may arise with this Pc
let
  # make frm package
  hp-sensor-firmware = pkgs.stdenv.mkDerivation {
    name = "hp-sensor-firmware";
    src = ./firmware; # pointn to firmware dir

    installPhase = ''
      mkdir -p $out/lib/firmware/intel/ish
      cp $src/ish_lnlm_12128606.bin $out/lib/firmware/intel/ish/
    '';
  };
in
{
  # give firmware to the kernel
  hardware.firmware = [ hp-sensor-firmware ];

  # load the kernel modules
  boot.kernelModules = [
    "intel_ishtp_hid"
    "hid-sensor-hub"
  ];

  # apply the ACPI fix that worked on Fedora laft time for me
  boot.kernelParams = [ "intel_ish_hid.acpi_opmode=1" ];

  # enable the IIO Sensor Proxy service [handles iio-sensor-proxy automatically]
  hardware.sensor.iio.enable = true;

  # make sure linux-firmware is available
  hardware.enableAllFirmware = true;
}
