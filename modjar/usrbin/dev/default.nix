# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Dev toolchain: dotnet/node/gcc/go + nix + sql tools.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.usrSettings.dev;
in
{
  options = {
    usrSettings.dev = {
      enable = lib.mkEnableOption "dev tools (master toggle)";
      dotnet = lib.mkEnableOption "dotnet (C#/.NET) SDK";
      node = lib.mkEnableOption "nodejs (JS/TS runtime)";
      cc = lib.mkEnableOption "gcc (C/C++ compiler)";
      go = lib.mkEnableOption "go toolchain";
      nixTools = lib.mkEnableOption "nix language servers + formatters";
      sqlTools = lib.mkEnableOption "dbeaver + sql clients";
    };
  };

  config = {
    home.packages = lib.mkIf cfg.enable (lib.mkMerge [
      (lib.mkIf cfg.dotnet (with pkgs; [
        dotnet-sdk_8
      ]))
      (lib.mkIf cfg.node (with pkgs; [
        nodejs
      ]))
      (lib.mkIf cfg.cc (with pkgs; [
        gcc
      ]))
      (lib.mkIf cfg.go (with pkgs; [
        go
      ]))
      (lib.mkIf cfg.nixTools (with pkgs; [
        nixd # Nix language server
        nixfmt # Nix formatter
        nil # Nix language server
        alejandra # alternate Nix formatter
      ]))
      (lib.mkIf cfg.sqlTools (with pkgs; [
        dbeaver-bin # universal SQL client
      ]))
    ]);
  };
}
