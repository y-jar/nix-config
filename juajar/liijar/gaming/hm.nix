# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Gaming: prism launcher + heroic imports.
# -=-=-=-=-=-=-=-=-=-=-=
# The shared prismlauncher/heroic packages live in ./shared.nix (hjem side);
# the home-manager side keeps its richer per-game modules below.
{
  ...
}:
{
  imports = [
    ./heroic.nix
    ./prism.nix
  ]; # end of imports
}
