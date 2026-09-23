# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: dev: per-sub-toggle toolchain packages.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.dev;

  # per-sub-toggle toolchain buckets; the python bucket carries the fuller
  # list (python3/uv/gcc + zlib/openssl/direnv)
  devPackages =
    lib.optionals (cfg.enable && cfg.python) [
      pkgs.python3 # python runtime
      pkgs.uv # rust based python package installer
      pkgs.gcc # compiler for native python deps
      pkgs.zlib # compression lib (native python deps)
      pkgs.openssl # tls lib (native python deps)
      pkgs.direnv # per-project environment switching
    ]
    ++ lib.optionals (cfg.enable && cfg.dotnet) [
      pkgs.dotnet-sdk_8 # C#/.NET SDK
    ]
    ++ lib.optionals (cfg.enable && cfg.node) [
      pkgs.nodejs # JS/TS runtime
    ]
    ++ lib.optionals (cfg.enable && cfg.cc) [
      pkgs.gcc # C/C++ compiler
    ]
    ++ lib.optionals (cfg.enable && cfg.go) [
      pkgs.go # go toolchain
    ]
    ++ lib.optionals (cfg.enable && cfg.nixTools) [
      pkgs.nixd # Nix language server
      pkgs.nixfmt # Nix formatter
      pkgs.nil # Nix language server
      pkgs.alejandra # alternate Nix formatter
      pkgs.noogle-search # search Nix functions from the CLI
      pkgs.nix-tree # visualize nix dependency tree
      pkgs.nurl # fetch a URL and output a nix hash
      pkgs.nix-init # generate a nix package from a repo URL
    ]
    ++ lib.optionals (cfg.enable && cfg.sqlTools) [
      pkgs.dbeaver-bin # universal SQL client
    ]; # end of devPackages
in
{
  config = {
    packages = devPackages; # end of packages
  }; # end of config
}
