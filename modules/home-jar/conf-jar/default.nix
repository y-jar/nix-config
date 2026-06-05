{
  imports = [
    ./fastfetch/fastfetch.nix # fastfetch config
    ./niri/link.nix # niri config
    ./foot.nix # foot config
    ./obs.nix # obs config
    ./fuzzel.nix # app launcher
    ./hyprland/hyprland-base.nix # hyprland config
  ];
}
