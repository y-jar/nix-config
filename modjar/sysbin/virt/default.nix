{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sysSettings.virt;
in
{
  options = {
    sysSettings = {
      virt = lib.mkOption {
        type = lib.types.bool;
        default = false;
      }; # end of virt
    }; # end of sysSettings
  }; # end of options

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true; # Allows libvirtd to use swtpm to create an emulated TPM.
        # ovmf.packages = [ pkgs.OVMFFull.fd ]; # Something about `Sample UEFI firmware for QEMU and KVM`
      }; # end of qemu
      spiceUSBRedirection.enable = true;
    }; # end of virtualisation.libvirtd

    environment.systemPackages = with pkgs; [
      gnome-boxes # Virtual machine manager
      dnsmasq # DNS server
      phodav # Optional: For file sharing with guest VMs
    ]; # end of environment.systemPackages
  }; # end of config
}
