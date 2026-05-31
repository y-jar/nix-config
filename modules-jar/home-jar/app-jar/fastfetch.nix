{ pkgs, ...}:
{
  xdg.configFile."fastfetch/config.jsonc".source = ./config.jsonc;
  xdg.configFile."fastfetch/logos-bin".source = ./logos-bin;
}