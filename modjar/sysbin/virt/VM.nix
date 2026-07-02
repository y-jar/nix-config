{
  config,
  lib,
  ...
}:
let
  cfg = config.sysSettings.virt;
in
{
  config = lib.mkIf cfg.isInVM {
    virtualisation.libvirtd.enable = false; # Ensure disabled
    services.qemuGuest.enable = true; # set as guest
    services.spice-vdagentd.enable = true; # Handles clipboard sharing and dynamic scaling
  }; # end of config
}
