{ ... }: {
  config = {
    security = {
      polkit.enable = true;
      # Improve performance by allowing games to request CPU priority
      rtkit.enable = true;
    };
    services = {
      udisks2.enable = true; # udisks2 service
    }; # end of services
  }; # end of security config
}
