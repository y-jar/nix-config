{ pkgs, ... }:

{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      swtpm.enable = true; # Allows libvirtd to use swtpm to create an emulated TPM.
      # ovmf.packages = [ pkgs.OVMFFull.fd ]; # Something about `Sample UEFI firmware for QEMU and KVM`
    };
  };

  virtualisation.spiceUSBRedirection.enable = true;

  environment.systemPackages = with pkgs; [
    gnome-boxes
    dnsmasq
    phodav # Optional: For file sharing with guest VMs
  ];
}
