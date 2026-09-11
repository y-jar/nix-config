# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Editor master toggle + dispatches to sub-editors.
# -=-=-=-=-=-=-=-=-=-=-=
# The plain editor packages per-toggle live in ./shared.nix (hjem side);
# the home-manager side installs them via the programs.* modules below.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.usrset.editors;
in
{

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
