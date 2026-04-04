{ pkgs, ...}:
{
    # links to config file and the logos
    xdg.configFile."niri/config.jsonc".source = ./config.jsonc;
    xdg.configFile."niri/logos-bin".source = ./logos-bin;
}