{ inputs, hostnm, ... }:
{
  inputs = [
    ./hardware-configuration.nix
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

  # boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
