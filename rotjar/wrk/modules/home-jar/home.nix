{ ... }:
{
  imports = [
    ./conf-jar/default.nix # LOADS ALL CONFIGS
    ./input-methods.nix # KEYBOARD SETTINGS & CONFIGS
    ./pkgs-user.nix # ALL USER PKGS
    ./git.nix # GIT SETTINGS
    ./theming.nix # anything in gtk ig
    ./shell.nix # Loads shell config
  ];
  home = {
    username = "jar";
    homeDirectory = "/home/jar";
    stateVersion = "26.05";
  };
}
