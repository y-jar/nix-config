{
  inputs,
  hostnm,
  ...
}:
{
  imports = [
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
      jar = import ./modules/home-jar/home.nix; # user entry
    };
  };

  networking.hostName = "${hostnm}"; # sets hostname

  # boot
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    }; # end of loader
  }; # end of boot

  # the aliases per system
  environment.shellAliases = {
    nht = "nh os test ~/nix-config#yilyonix"; # same as nrt
    nhs = "nh os switch ~/nix-config#yilyonix"; # same as nrs
    nrs = "nixos-rebuild switch --sudo --flake ~/nix-config#yilyonix"; # actual building
    nrt = "nixos-rebuild test --sudo --flake ~/nix-config#$yilyonix"; # testing
  }; # end of shell aliases
}
