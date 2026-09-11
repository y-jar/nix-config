# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Dev shared data: per-sub-toggle toolchain packages.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[liijar/dev/shared.nix] =-=-=
# Union of the old usrbin + hjmbin dev buckets: the python bucket carries
# the fuller hjem list (python3/uv/gcc + zlib/openssl/direnv) so both
# backends get the same toolchain, each bucket still gated per-sub-toggle.
# =-=-=[end liijar/dev/shared.nix] =-=-=
{
  cfg,
  pkgs,
  lib,
  ...
}:
{
  packages =
    lib.optionals (cfg.enable && cfg.python) (
      with pkgs;
      [
        python3 # python runtime
        uv # rust based python package installer
        gcc # compiler for native python deps
        zlib # compression lib (native python deps)
        openssl # tls lib (native python deps)
        direnv # per-project environment switching
      ]
    )
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
    ++ lib.optionals (cfg.enable && cfg.nixTools) (
      with pkgs;
      [
        nixd # Nix language server
        nixfmt # Nix formatter
        nil # Nix language server
        alejandra # alternate Nix formatter
      ]
    )
    ++ lib.optionals (cfg.enable && cfg.sqlTools) [
      pkgs.dbeaver-bin # universal SQL client
    ]; # end of packages
}
