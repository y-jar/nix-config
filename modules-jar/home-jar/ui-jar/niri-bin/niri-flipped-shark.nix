
{pkgs, ...}:
{
  xdg.configFile."niri/config.kdl".source = ./config-flipped-shark.kdl;
}
