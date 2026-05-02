{ ... }:

{
  # This is where all background languages go :P
  environment.systemPackages = with pkgs; [
    # [Academic Project Stack]
    dotnet-sdk_8
    php
    mariadb
    
    # [Development Essentials]
    python3
    rustc
    cargo
    nodejs
    
    # [Technical Writing]
    pandoc
    
    # [Database GUI (optional but helpful for ERD work)]
    dbeaver-bin 
  ];
}