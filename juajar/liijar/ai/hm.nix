# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: User-level AI tools (opencode, LM Studio).
# -=-=-=-=-=-=-=-=-=-=-=
# Fine toggles: ai.enable (master), ai.opencode.enable, ai.lmstudio.enable,
# so you can keep opencode (non-local models) while skipping LM Studio's ~2.3GiB.
# Packages come from ./shared.nix; the opencode config (programs.opencode)
# lives in the ./opencode*.nix siblings.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.ai;
  shared = import ./shared.nix { inherit cfg pkgs lib; };
in
{
  imports = [
    ./opencode.nix # the config for opencode
  ]; # end of imports

  config = lib.mkIf cfg.enable {
    # programs.opencode (opencode.nix) provides the opencode TUI binary, so
    # the raw pkgs.opencode from shared.nix is filtered out here to avoid a
    # wrapped/unwrapped buildEnv collision. hjem has no programs.opencode and
    # takes the shared list as-is.
    home.packages = lib.filter (p: p != pkgs.opencode) shared.packages;
  }; # end of config
}
