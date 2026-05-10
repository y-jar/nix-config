{ ... }:
{
  home.packages = with pkgs; [
    fcitx5 # for typing in japanese?
    fcitx5-mozc # other japan language sturff
  ];
}