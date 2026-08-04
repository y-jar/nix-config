{ config, lib, ... }:

let
  cfg = config.sysSettings.tlp;
in
{
  options = {
    sysSettings.tlp = {
      enable = lib.mkEnableOption "Enable TLP daemon";

      startChargeThreshold = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = ''
          Start charge threshold for BAT0 (0 = always charge).
          Only honored on hardware that exposes charge-control sysfs
          (e.g. ThinkPads). HP consumer systems do not expose this.
        '';
      };

      stopChargeThreshold = lib.mkOption {
        type = lib.types.int;
        default = 100;
        description = ''
          Stop charge threshold for BAT0 (100 = no cap, 80 = cap at 80%).
          Only honored on hardware that exposes charge-control sysfs
          (e.g. ThinkPads). HP consumer systems have no hard charge cap:
          the closest is BIOS (F10 -> Power Management) "Adaptive Battery
          Optimizer", which is adaptive (slows charging, trims capacity)
          and still reports 100%. This module reports enforcement status
          at boot.
        '';
      };

      cpuEppOnBattery = lib.mkOption {
        type = lib.types.str;
        default = "balance_power";
        description = "Intel Energy-Performance Preference on battery (default|performance|balance_performance|balance_power|power)";
      };

      platformProfileOnBattery = lib.mkOption {
        type = lib.types.str;
        default = "balanced";
        description = "Platform profile on battery (cool|quiet|balanced|performance)";
      };

      pcieAspmOnBattery = lib.mkOption {
        type = lib.types.str;
        default = "default";
        description = "PCIe ASPM policy on battery (default|performance|powersave|powersupersave)";
      };
    }; # end of tlp options
  }; # end of options

  config = lib.mkIf cfg.enable {
    services.tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = cfg.startChargeThreshold;
        STOP_CHARGE_THRESH_BAT0 = cfg.stopChargeThreshold;
        CPU_ENERGY_PERF_POLICY_ON_BAT = cfg.cpuEppOnBattery;
        PLATFORM_PROFILE_ON_BAT = cfg.platformProfileOnBattery;
        PCIE_ASPM_ON_BAT = cfg.pcieAspmOnBattery;
      };
    }; # end of tlp

    services.power-profiles-daemon.enable = lib.mkForce false;

    # When a charge cap is requested, report at boot whether the hardware
    # can actually enforce it. Some machines expose charge-control sysfs
    # (TLP handles it). On HP consumer systems there is no hard cap; the
    # closest is the BIOS "Adaptive Battery Optimizer" (exposed as
    # "Adaptive Battery Extender" by hp-bioscfg), which is adaptive and
    # does not stop at a fixed percentage.
    systemd.services.tlp-battery-cap-check = lib.mkIf (cfg.stopChargeThreshold < 100) {
      description = "Report battery charge cap enforceability";
      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-modules-load.service" ];
      script = ''
        BAT=/sys/class/power_supply/BAT0
        HP=/sys/class/firmware-attributes/hp-bioscfg/attributes

        if [ -e "$BAT/charge_control_end_threshold" ]; then
          echo "battery-cap: sysfs charge control present, TLP enforces cap at ${toString cfg.stopChargeThreshold}%"
          exit 0
        fi

        if [ -d "$HP" ]; then
          abe=$(cat "$HP/Adaptive Battery Extender/current_value" 2>/dev/null || true)
          abe_status=$(cat "$HP/Adaptive Battery Extender Status/current_value" 2>/dev/null || true)
          if [ "$abe" = "Enable" ]; then
            echo "battery-cap: HP Adaptive Battery Optimizer = $abe ($abe_status)"
            echo "battery-cap: NOTE - this is ADAPTIVE, not a hard ${toString cfg.stopChargeThreshold}% cap; HP consumer systems expose no fixed charge limit."
            exit 0
          fi
          echo "battery-cap: WARNING - HP Adaptive Battery Optimizer is disabled in BIOS (F10 -> Power Management)."
        fi

        echo "battery-cap: WARNING - requested ${toString cfg.stopChargeThreshold}% cap cannot be hard-enforced on this hardware."
      '';
    };
  }; # end of config
}
