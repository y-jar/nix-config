{
  pkgs,
  inputs,
  hostnm,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix # yoink mah hardware
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

  # boot
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    }; # end of loader
    initrd.kernelModules = [ "amdgpu" ];
    kernelPackages = pkgs.linuxPackages_latest;
  }; # end of boot

  networking.hostName = "${hostnm}"; # sets hostname

  # the aliases per system
  environment.shellAliases = {
    # nrt = "nh os test ~/nix-config -- --flake ~/nix-config#calender";
    # nrs = "nh os switch ~/nix-config -- --flake ~/nix-config#calender";
    nrs = "nixos-rebuild switch --sudo --flake ~/nix-config#calender"; # actual building
    nrt = "nixos-rebuild test --sudo --flake ~/nix-config#$calender"; # testing
  }; # end of shell aliases
}
