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

  # the aliases per system
  environment.shellAliases = {
    nht = "nh os test ~/nix-config -- --flake ~/nix-config#flipped-jar";
    nhs = "nh os switch ~/nix-config -- --flake ~/nix-config#flipped-jar";
    nrs = "nixos-rebuild switch --sudo --flake ~/nix-config#flipped-jar"; # actual building
    nrt = "nixos-rebuild test --sudo --flake ~/nix-config#$flipped-jar"; # testing
  }; # end of shell aliases
}
