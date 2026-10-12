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
    hjem.url = "github:feel-co/hjem"; # the user backend (manages dotfiles + user packages)
  }; # end of inputs

  # within a outputs set, you can define the specific outputs from your inputs. 
  #   when declaring specific things like `nixpkgs` or `hjem`, you can use said 
  #   specific inputs to configure them to preform functions within your flake.
  outputs = { 
    self, 
    nixpkgs, 
    # hjem
    # This is commented out to state that we can still use it, but it will not 
    #   be used in this flake directly, but later on in the system entry (hjemkey). 
    #   As it is commented out, it will still be avalible because it is within 
    #   the inputs set. And inputs is inherited within the modules list below.
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

in this repo the user side is handled by hjem (home-manager is long gone). the wiring lives in one place `juajar/hjemkey.nix` which imports the hjem NixOS module and points it at the app tree:
```nix
# (the real thing, simplified from juajar/hjemkey.nix)
{
  imports = [ inputs.hjem.nixosModules.default ]; # pull hjem in

  config = {
    hjem = {
      clobberByDefault = true; # hjem overwrites conflicting files instead of backing them up
      extraModules = [
        ./liijar # the app tree (auto-imported)
        (hostDir + "/user.nix") # the host's toggle sheet (hostDir comes from mkJar specialArgs)
      ];
      users.''${mainUser} = {
        enable = true;
        directory = "/home/''${mainUser}";
        # .profile = dirSetup lines + the hjem environment (packages, sessionVariables)
      };
    };
  };
}
```
hjem modules are evaluated *inside* the user submodule, so an app module writes `packages` and `files.".config/app/config".source` directly no home.* / programs.* anything.

## Adding an app to the jar (the modern way)

since the big reorg, user-level apps live in ONE tree: [juajar/liijar/](../../juajar/liijar). every app is one dir with a single module file, the same shape as sysjar:

```
juajar/liijar/<app>/
  default.nix   # the module: toggle gates + packages + generated config files
```

**cowsay is the commented reference example** read [juajar/liijar/cowsay/](../../juajar/liijar/cowsay), it explains itself + the gotchas. the short version:

1. `juajar/liijar/options.nix` declare your toggle (`usrset.<app>.enable = ...`) there and ONLY there
2. copy `cowsay/` to `liijar/<app>/`, put your packages in `default.nix`
3. flip the toggle in the host's `hstjar/<host>/user.nix`
4. done `liijar/default.nix` auto-imports every app dir. no registration, no key edits

gotchas the example comments cover: `//` does not compose `lib.mkIf` (use `lib.mkMerge`), hjem config files are read-only store symlinks (self-saving apps can't persist), no user systemd units (write the unit file + the dirSetup bus), need a system service? that's sysjar territory.

## Adding a system module (sysjar)

same idea on the system side: [juajar/sysjar/](../../juajar/sysjar) is auto-imported (every root `.nix` + every dir), so a new feature is one dir:

```
juajar/sysjar/<feature>/
  default.nix   # options.sysset.<feature>.* + config = lib.mkIf cfg.enable { ... }
```

- declare the options in the SAME file as the config (sub-files of a module read the parent's options)
- a check that only concerns this module (an assertion) lives in the module; a check that compares modules lives in [juajar/sysjar/checks.nix](../../juajar/sysjar/checks.nix)
- open the firewall in the module that owns the service, never in `networking`
- hosts flip it in `hstjar/<host>/system.nix`

## Adding a window manager

a WM is ONE dir in [juajar/WMs/](../../juajar/WMs), holding everything about it:

```
juajar/WMs/<wm>/
  system.nix    # NixOS half: sysset.<wm>.enable + programs.<wm>   (routed by WMs/default.nix)
  user.nix      # hjem half: dotfiles + packages, reads usrset.<wm>.* (routed by WMs/hjem.nix)
  ...           # the raw config data (lua/kdl/conf) and host-inputs/<host>.<ext>
```

copy the closest existing WM, declare `usrset.<wm>.*` in `liijar/options.nix`, done. use `WMs/lib.nix` `hostInput` for the per-host file with the `0-unknown` fallback.

## Where system facts come from (sysset vs usrset)

`liijar` modules never read `osConfig` or `sysset`. what they need to know about the machine is in `config.usrset.system.*` (`platform`, `hasDesktop`, `unfree`, `mullvad`, `autostart`, `webapps`, ...). on NixOS [juajar/bridge.nix](../../juajar/bridge.nix) fills them from `sysset.*`, and it is also the one place where a `usrset` toggle reaches the system side (nvf, syncthing, theming, electron). a bridged value has ONE owner: set it in `user.nix`, not in `system.nix`.

`usrset.system.platform` (`nixos` | `debian`) switches the NixOS-only pieces off (nh/nixos-rebuild aliases, `/run/current-system` paths, tuneshon). `usrset.packages.install = false` drops every module's packages so the host's own package manager provides the binaries and hjem only writes dotfiles.

## Naming conventions

- **dir name = option name**: `chatApps/` is `usrset.chatApps`, `powerProfiles/` is `sysset.powerProfiles`. camelCase for multi-word names, in dirs and options alike
- **every feature toggle is `<name>.enable`**, including sub-features (`media.mpv.enable`, `dev.python.enable`, `base.coreTools.enable`). plain bools are only for modes and settings (`nueon.binary`, `tuneshon.overwrite`, `theming.blackness`)
- **gate with `lib.mkIf cfg.enable`** on the whole `config`; use `lib.mkMerge` for several gated pieces (`//` does not compose `mkIf`)
- **declare options once**: `usrset.*` only in `liijar/options.nix`; `sysset.*` in the module that owns them
- **data is not a module**: shared data goes in `juajar/data/`, raw WM config next to its WM; data dirs have no `default.nix` so the importers skip them
- **no home-manager leftovers**: files are keyed home-relative (`.config/app/x`, no `~/` prefix), and no module writes `home.*` / `programs.*` in `liijar`
