{ pkgs, ...}:
{
# Enable dconf [required for GNOME apps to save settings]
  programs.dconf.enable = true;

  # enable Libvirtd
  virtualization.libvirtd.enable = true;

  # spice for better guest performance [copy-paste, resizing]
  virtualization.spiceUSBRedirection.enable = true;
  virtualisation
  # enable libvirtd
  virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
  };
}