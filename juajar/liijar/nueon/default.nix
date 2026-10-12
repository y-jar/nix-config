# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: nueon: conlang editor/creation app (Tauri GUI) from the nueon flake input.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[liijar/nueon] =-=-=
# Installs inputs.nueon's package. `usrset.nueon.binary` picks between the
# prebuilt release `.deb` (`nueon-bin`) and the source build (`default`). The
# flake input follows this flake's nixpkgs so the runtime WebKit/GTK closure is
# shared. The package ships its own .desktop entry + hicolor icons.
# =-=-=[end liijar/nueon] =-=-=
{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.usrset.nueon;
  pkg =
    inputs.nueon.packages.${pkgs.stdenv.hostPlatform.system}
    .${if cfg.binary then "nueon-bin" else "default"};
in
{
  config = lib.mkIf cfg.enable {
    packages = [ pkg ];
  };
}
