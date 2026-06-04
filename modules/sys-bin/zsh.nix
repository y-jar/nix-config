{ ... }:
{
  # NOTE: at a point i ran into a weird zsh error, run this if commands dont work
  #export PATH=/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:$HOME/.local/bin:$PATH
  programs.zsh.enable = true;
}
