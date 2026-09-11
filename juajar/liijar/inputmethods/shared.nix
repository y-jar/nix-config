# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Input methods shared data (fcitx5 addon set + hjem package).
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[liijar/inputmethods/shared.nix] =-=-=
# The fcitx5 addon list shared by both backends (HM: i18n.inputMethod.fcitx5
# .addons; hjem: the fcitx5-with-addons override in `packages`). The HM side
# gets its fcitx5 package from i18n.inputMethod itself, so it maps only
# `addons`; the hjem side maps `packages`.
# =-=-=[end liijar/inputmethods/shared.nix] =-=-=
{
  cfg,
  pkgs,
  lib,
  ...
}:

let
  # fcitx5 addons, gated per input method
  addons =
    with pkgs;
    [
      fcitx5-gtk # GTK IM module for fcitx5
      fcitx5-nord # Nord theme for fcitx5
    ]
    ++ (lib.optionals cfg.japanese.enable [
      fcitx5-mozc # Mozc input method for fcitx5
    ])
    ++ (lib.optionals cfg.korean.enable [
      fcitx5-hangul # Hangul input method for fcitx5
    ]);

  # the hjem-style fcitx5 package (HM uses i18n.inputMethod instead)
  fcitx5Package = pkgs.qt6Packages.fcitx5-with-addons.override { inherit addons; };
in
{
  inherit addons fcitx5Package;

  packages = [ fcitx5Package ];
}
