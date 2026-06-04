{ inputs, hostnm, ... }:
{
  imports = [
    ./hardware-configuration.nix # grabs the hardware
    #./battery-config.nix # handles my max charge fixs
    ./hardware-fix.nix
    inputs.home-manager.nixosModules.home-manager # Pulls in home-manager module
  ];

  # home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    # Passes my inputs
    extraSpecialArgs = {
      inherit inputs;
      inherit hostnm;
    };
    users = {
      jar = import ../../../modules/home-jar/home.nix; # user entry
    };
  };

  networking.hostName = "${hostnm}"; # sets hostname

  # add Bootloader options here[from /etc/nixos/configuration.nix]
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
