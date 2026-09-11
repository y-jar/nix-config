# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: nix repl entry for the jar flake.
# -=-=-=-=-=-=-=-=-=-=-=
# Usage (see the `repl` zsh alias):
#   nix repl --file ~/nix-config/juajar/liijar/shell/repl.nix
# Then poke around:
#   jar.calender.config.hjem
#   cfg "ziiemar".config.sysset
# -=-=-=-=-=-=-=-=-=-=-=
let
  flake = builtins.getFlake (toString ../../..);
  cfg = name: flake.nixosConfigurations.${name}.config;
in
{
  inherit flake;
  jar = flake.nixosConfigurations;
  inherit cfg;
}
