# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Flatpak support (system-level) + Bazaar setup.
# -=-=-=-=-=-=-=-=-=-=-=
{ lib, config, ... }:

let
  cfg = config.sysset.flatpak;
in
{
  options = {
    sysset.flatpak = {
      enable = lib.mkEnableOption "Enable flatpaks";
    };
  };

  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;
    xdg.portal.enable = true;

    # let sandboxed apps see the host GTK theme/config so gruvbox carries over
    # (this nixpkgs has no services.flatpak.overrides option, write the global
    # override file directly)
    system.activationScripts.flatpakTheme = lib.mkIf config.sysset.theming.enable ''
      mkdir -p /var/lib/flatpak/overrides
      cat > /var/lib/flatpak/overrides/global <<'EOF'
      [Context]
      filesystems=xdg-config/gtk-3.0:ro;xdg-config/gtk-4.0:ro;xdg-data/themes:ro;xdg-data/icons:ro;
      [Environment]
      GTK_THEME=${config.sysset.theming.gtkThemeName}
      EOF
    '';
  };
}
