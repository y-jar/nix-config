# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: editors: vscodium/zed/obsidian/helix packages + helix config.
# -=-=-=-=-=-=-=-=-=-=-=
# vscodium/zed follow the master toggle + their own sub-toggle; obsidian/helix
# follow only their own sub-toggle (mirrors the old bucket gates). nvf does
# NOT live here it comes system-level via the sysset.nvf bridge (hjemkey)
# running juajar/sysjar/nvf.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.editors;

  # [helix] settings attrset (./helix.nix) -> ~/.config/helix/config.toml
  helixSettings = import ./helix.nix;
  helixConfigToml = (pkgs.formats.toml { }).generate "helix-config" helixSettings;
in
{
  config = lib.mkMerge [
    {
      packages =
        lib.optionals (cfg.enable && cfg.vscodium.enable) [ pkgs.vscodium ]
        ++ lib.optionals (cfg.enable && cfg.zed.enable) [ pkgs.zed-editor ]
        ++ lib.optionals cfg.obsidian.enable [ pkgs.obsidian ]
        ++ lib.optionals cfg.helix.enable [ pkgs.helix ]
        # editor extras (from the old home-manager module)
        ++ lib.optionals cfg.enable (
          with pkgs;
          [
            gnome-text-editor
            lorem # Generate placeholder text
            qownnotes # markdown app editor
            buffer # Minimal editing space for all those things that don't need keeping
          ]
        );
    }
    (lib.mkIf cfg.helix.enable {
      files.".config/helix/config.toml".source = helixConfigToml;
    })
  ]; # end of config
}
