**Links:**
- [Back Home](../../README.md)
- [Documentation Key](./key-key.md)

# Adding Modules Guide

When configuring some might recomend adding a *nixos module*, which typically can be found in the [nixpkgs](https://github.com/NixOS/nixpkgs) repository or other places. This would typically involve adding some part of it to the flake.nix file. This is where i describe what i have learned about how it is done!

Here is an example of adding a module to the flake.nix file *(with a fair amount of comments)*:

> You'll want to read the comments to understand what each part does. `:)`
```nix
{
  # Nix goes and fetches those repos and locks them in flake.lock. Nothing is "usable" yet, 
  #   they're just downloaded.
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05"; # this sets the nixpkgs version
    home-manager = {
        url = "github:nix-community/home-manager/release-26.05"; # this grabs a specific release of home-manager
        inputs.nixpkgs.follows = "nixpkgs"; # tells HM to reuse YOUR nixpkgs, not download its own
    }; # end of home-manager
  }; # end of inputs

  # within a outputs set, you can define the specific outputs from your inputs. 
  #   when declaring specific things like `nixpkgs` or `home-manager`, you can use said 
  #   specific inputs to configure them to preform functions within your flake.
  outputs = { 
    self, 
    nixpkgs, 
    # home-manager 
    # This is commented out to state that we can still use it, but it will not 
    #   be used in this flake, but later on in the system like in the system entry. As it is 
    #   commented out, it will still be avalible because it is within the inputs set. 
    #   And inputs is inherited within the modules list below within `YouNameAConfigurationHere`.
  }@inputs: # `@inputs` captures the entire inputs set, so you can use it within the configuration below.
    {
      # this is where you define your nixos configurations like hardware specifications, packages, and other settings if you want.
      nixosConfigurations = {
        #                           [LOOK]<- this is from the specified set of the start of outputs!
        YouNameAConfigurationHere = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs; # this sends the entire inputs set over as a single argument to 
                            #   the configuration
          };
          modules = [
            ./path/to/system/entry.nix # this is the system entry point, could declare hostname, 
                                       #   super cool apps, and all other settings for use on a PC or server. 
                                       #   And you can use inputs within this file to access the inputs set.
          ]; # end of modules
        }; # end of configuration
      }; # end of nixosConfigurations
    }; # end of outputs
}
```

after it is done, if you configure Home Manager this is what you need to do:
```nix
# example file
{
  pkgs,
  inputs,
  hostnm,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager # Pull in home-manager module
  ];

  # home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    # Passes my inputs
    extraSpecialArgs = {
      # inside is where you inherit any important inputs or varibles like my hostname 
      #   and any other important settings you want to pass to home-manager
      inherit inputs; # sends the entire inputs set over as a single argument to home-manager and all inputs you placed in it.
    };
    users = {
      jar = import ./path/to/user.nix; # user entry
    };
  };
}
```


## Adding an app to the jar (the modern way)

since the big reorg, user-level apps live in ONE tree: [juajar/liijar/](../../juajar/liijar). every app gets a dir with up to three files, and both backends (home-manager + hjem) read the same app:

```
juajar/liijar/<app>/
  shared.nix   # the app's data: packages + generated files (single source)
  hm.nix       # home-manager adapter (home.packages, home.file, programs.*)
  hjem.nix     # hjem adapter (packages, files."...".source)
```

**cowsay is the commented reference example** read [juajar/liijar/cowsay/](../../juajar/liijar/cowsay), every file explains itself + the gotchas. the short version:

1. `juajar/liijar/options.nix` declare your toggle (`usrset.<app>.enable = ...`) there and ONLY there
2. copy `cowsay/` to `liijar/<app>/`, put your packages in `shared.nix`
3. flip the toggle in the host's `hstjar/<host>/user.nix`
4. done both `liijar/hm.nix` and `liijar/hjem.nix` auto-import the app. no registration, no key edits

gotchas the example comments cover: `//` does not compose `lib.mkIf` (use `lib.mkMerge`), programs.* wraps binaries (filter raw pkgs out on the hm side), hjem has no programs.*/user units (write unit files + the dirSetup bus).
