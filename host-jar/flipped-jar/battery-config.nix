{ ... }:
{
  services.upower = {
    enable = true;
    percentageLow = 20;
    percentageCritical = 10;
    percentageAction = 5;
  };

  # load HP BIOS config + WMI modules for battery management and BIOS attributes
  boot.kernelModules = [ "hp_bioscfg" "hp_wmi" ];
}