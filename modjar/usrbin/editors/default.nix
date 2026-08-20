# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Editor master toggle + dispatches to sub-editors.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.usrSettings.editors;
in
{
  options = {
    usrSettings.editors = {
      enable = lib.mkEnableOption "Enable editors (~600MiB, VSCodium + Zed + Obsidian + Helix + NVF)";
      vscodium.enable = lib.mkEnableOption "Enable VSCodium editor (~300MiB)";
      zed.enable = lib.mkEnableOption "Enable Zed editor (~200MiB)";
      obsidian.enable = lib.mkEnableOption "Enable Obsidian editor (~200MiB)";
    }; # end of editors options
  }; # end of options

  imports = [
    ./helix.nix # helix config from: https://github.com/ryan4yin/nix-config
    ./nvf-neovim-vim # my neovim config via nvf
  ]; # end of imports

  config = lib.mkIf cfg.enable {
    # Install each editor if the master switch is on OR the editor is explicitly enabled
    programs.vscodium.enable = cfg.vscodium.enable;
    programs.zed-editor.enable = cfg.zed.enable;
    programs.obsidian.enable = cfg.obsidian.enable;

    home.packages = with pkgs; [
      gnome-text-editor
      lorem # Generate placeholder text
      qownnotes # markdown app editor
      buffer # Minimal editing space for all those things that don't need keeping
    ]; # end of home.packages
  }; # end of config
}
