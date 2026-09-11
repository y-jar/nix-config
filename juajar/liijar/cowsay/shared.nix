# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: REFERENCE EXAMPLE app: cowsay. Copy this dir for new apps.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[liijar/cowsay/shared.nix] =-=-=
# WHAT THIS FILE IS:
#   The single source of truth for the app's DATA. Pure nix no module
#   options, no backend anything. Both hm.nix and hjem.nix import it and
#   map its return value into their own option sets. If you change a
#   package or a generated file HERE, both backends get the change.
#
# THE CONTRACT:
#   Takes: cfg  -> config.usrset.<your-app> (the host sheet toggles)
#          lib  -> nixpkgs lib (optionals, optionalAttrs, ...)
#          pkgs -> the package set
#   Returns: {
#     packages = <list of derivations>;          # apps to install
#     files    = { "<home-path>" = <path-or-derivation>; };  # optional
#   }                                            # ^ dotfiles to write
#
# FOR A NEW APP:
#   1. copy this whole cowsay/ dir to liijar/<your-app>/
#   2. declare `usrset.<your-app>.enable` in liijar/options.nix (ONE place)
#   3. put your package list here, gated on cfg.enable (or sub-toggles)
#   4. does the app have a config file? build it with pkgs.writeText /
#      pkgs.formats.<ini/yaml/json>.generate and return it under `files`
#      (use HOME-RELATIVE paths like ".config/<app>/config.conf")
#   5. wire hm.nix + hjem.nix (they show the mapping)
#   6. that's it liijar/hm.nix + liijar/hjem.nix auto-import every
#      <app>/hm.nix and <app>/hjem.nix. no registration anywhere.
# =-=-=[end liijar/cowsay/shared.nix] =-=-=
{
  cfg,
  lib,
  pkgs,
  ...
}:
{
  # [packages] the whole point of this example: one bool (usrset.cowsay.enable,
  # default true so it's always installed unless a host says otherwise) gating
  # one package. lib.optionals keeps the list empty when the toggle is off.
  packages = lib.optionals cfg.enable [
    pkgs.cowsay # MOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
  ];

  # [files] (this example ships no config files, but this is how you'd do it)
  #
  # files = {
  #   ".config/cowsay/config".source = pkgs.writeText "cowsay-config" ''
  #     some app config here
  #   '';
  # };
  #
  # hm.nix maps these to home.file."<path>".source
  # hjem.nix maps these to files."<path>".source
  # (same keys, same values that's the whole trick)
}
