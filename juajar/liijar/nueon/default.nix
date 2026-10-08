# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: nueon: conlang editor/creation app (Tauri GUI) from the nueon flake input.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[liijar/nueon] =-=-=
# Installs inputs.nueon's source-built package (Rust + Svelte + WebKit/GTK,
# deps pinned upstream on its own nixpkgs — no nixpkgs.follows). The package
# ships its own .desktop entry + hicolor icons, so no extra wiring is needed.
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
in
{
  config = lib.mkIf cfg.enable {
    packages = [
      inputs.nueon.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
