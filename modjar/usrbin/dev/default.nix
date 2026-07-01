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
      enable = pkgs.lib.mkOption {
        type = pkgs.lib.types.bool;
        default = false;
      };
    }; # end of usrSettings.dev
  }; # end of options
  config = {
    home.packages = lib.mkIf cfg.enable (
      with pkgs;
      [
        # [Development Essentials]
        dotnet-sdk_8 # Core functionality needed to create .NET Core projects, that is shared between Visual Studio and CLI (wrapper) (combined) (wrapper)
        python315 # latest i can get
        nodejs # Event-driven I/O framework for the V8 JavaScript engine
        gcc # GNU Compiler Collection, version 15.2.0 (wrapper script)
        go # Go Programming language

        # [Nix]
        nixd # Feature-rich Nix language server interoperating with C++ nix
        nixfmt # Nix formatter
        nil # Nix language server
        alejandra # formatter ~1.7mib

        # [rust]
        # rustc # Safe, concurrent, practical language (wrapper script)
        # rust-analyzer # Language server for the Rust language
        # rustfmt # Tool for formatting Rust code according to style guidelines
        # cargo # Downloads your Rust project's dependencies and builds your project

        # [Database GUI (optional but helpful for ERD work)]
        dbeaver-bin # Universal SQL Client for developers, DBA and analysts. Supports MySQL, PostgreSQL, MariaDB, SQLite, and more
      ]
    );
  };
}
