{ pkgs, ...}:
{
# Enable dconf [required for GNOME apps to save settings]
  programs.dconf.enable = true;

  # Add vm app to system
  environment.systemPackages = with pkgs; [
    gnome-boxes
  ];

  # enable Libvirtd
  virtualization.libvirtd.enable = true;

  # spice for better guest performance [copy-paste, resizing]
  virtualization.spiceUSBRedirection.enable = true;
}