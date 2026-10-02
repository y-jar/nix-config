# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: tuneshon: NixOS update tool (gui + cli) + pre-seeded config dir.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[liijar/tuneshon] =-=-=
# Installs the tuneshon binary (built from the tuneshon flake input) and
# pre-seeds ~/.config/tuneshon/config.json so the app starts already pointed
# at the host's nix config dir (no in-app setup).
#
# WHY dirSetup (not hjem files):
#   tuneshon self-saves its config (AppConfig::save on first run + GUI
#   edits). hjem `files` are read-only /nix/store symlinks, which would break
#   that persistence. So we seed via the dirSetup (.profile) login bus,
#   writing a REAL writable file, gated so it doesn't clobber GUI edits
#   unless overwrite = true (same pattern as liijar/directories + dictation).
#
# NOTE: configDir is also exported as the TUNESHON_CONFIG_DIR env var
# (underlying default in src/config.rs), so the seeded file + env agree.
# =-=-=[end liijar/tuneshon] =-=-=
{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.usrset.tuneshon;

  # JSON seed written via dirSetup. Use `log_file` default with $HOME expanded
  # at login (dirSetup runs inside .profile where $HOME is set).
  seed = builtins.toJSON {
    config_dir = cfg.configDir;
    boot_loader = cfg.bootLoader;
    log_file = cfg.logFile;
  };
in
{
  config = lib.mkIf cfg.enable {
    # Bake the host's config dir into the installed binary wrapper
    # (TUNESHON_CONFIG_DIR), so a desktop-launched "update" always points at
    # the right repo even though launchers don't source ~/.profile.
    packages = [
      (inputs.tuneshon.lib.mkPackage {
        inherit pkgs;
        configDir = cfg.configDir;
      })
    ];

    # [login bootstrap] seed a writable config.json; skip unless overwrite.
    # Unquoted heredoc so the "$HOME" in log_file expands at login.
    hjemDotfiles.dirSetup = lib.mkBefore ''
      # [tuneshon] pre-seed config dir
      mkdir -p "$HOME/.config/tuneshon"
      if [[ "${
        if cfg.overwrite then "true" else "false"
      }" == "true" || ! -f "$HOME/.config/tuneshon/config.json" ]]; then
        cat > "$HOME/.config/tuneshon/config.json" <<TUNESHON_EOF
      ${seed}
      TUNESHON_EOF
      fi
    '';
  }; # end of config
}