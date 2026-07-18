{ config, lib, pkgs, inputs, hostnm, ... }:

{
  imports = [
    inputs.hjem.nixosModules.default
    inputs.nvf.nixosModules.default
  ];

  config = {
    hjem = {
      clobberByDefault = true;

      extraModules = [
        ../modjar/hjmbin # Hjem user modules (auto-imports all .nix and subdirs)
        ../hstjar/${hostnm}/hjem.nix # Host-specific hjem config
      ];

      users = builtins.listToAttrs (
        map (user: {
          name = user;
          value = {
            enable = true;
            directory = "/home/${user}";

            files = {
              ".profile" = {
                executable = true;
                source = config.hjem.users.${user}.environment.loadEnv;
              };
            } // lib.optionalAttrs (config.hjemDotfiles.zshrc != null) {
              ".zshrc".source = config.hjemDotfiles.zshrc;
              ".fzfrc".source = config.hjemDotfiles.fzfrc;
            };
          };
        }) config.sysSettings.users
      );
    }; # end of hjem

    hjem.specialArgs = {
      inherit hostnm;
      gnomeEnable = config.sysSettings.gnome.enable or false;
      hyprlandEnable = config.sysSettings.hyprland.enable;
      niriEnable = config.sysSettings.niri.enable;
      aiEnable = config.sysSettings.ai.enable;
    };
  };
}
