{ ... }:

{
  # This is where all background languages go :P
  environment.systemPackages = with pkgs; [
    # [Academic Project Stack]
    dotnet-sdk_8 # Core functionality needed to create .NET Core projects, that is shared between Visual Studio and CLI (wrapper) (combined) (wrapper)
    php # HTML-embedded scripting language
    mariadb # Enhanced, drop-in replacement for MySQL
    
    # [Development Essentials]
    python315 # latest i can get
    rustc # Safe, concurrent, practical language (wrapper script)
    cargo # Downloads your Rust project's dependencies and builds your project
    nodejs # Event-driven I/O framework for the V8 JavaScript engine
    gcc # GNU Compiler Collection, version 15.2.0 (wrapper script)
    go # Go Programming language
    nil # Yet another language server for Nix
    
    # [Technical Writing]
    pandoc # Conversion between documentation formats
    
    # [Database GUI (optional but helpful for ERD work)]
    dbeaver-bin # Universal SQL Client for developers, DBA and analysts. Supports MySQL, PostgreSQL, MariaDB, SQLite, and more
  ];
}