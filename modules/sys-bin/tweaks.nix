{ pkgs, ... }:
{
  # tell NixOS to include these in the generated pixbuf loaders cache
  programs.gdk-pixbuf.modulePackages = with pkgs; [
    librsvg
    webp-pixbuf-loader
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enables nix-ld to run unpatched binaries (like in my neovim config)
  # acts as a compatability thing, if this has an issue, or i dont like it, SHUT OFF HEHEHE
  programs.nix-ld.enable = true;

  programs.dconf.enable = true;
  services.gnome.gnome-keyring.enable = true; # Helps store passwords/settings
  services.tumbler.enable = true; # image stuff
  programs.evince.enable = true; # Enablilng this native option automatically sets up PDF thumbnailing

  # supported file systems for them dum dum ntfs
  boot.supportedFilesystems = [
    "fuse"
    "ntfs"
  ];
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # nudges Electron/Chrome apps to use Wayland
    QT_QPA_PLATFORMTHEME = "gtk2";
  };
}
