{ ... }:
{
  security.polkit.enable = true;
  # Improve performance by allowing games to request CPU priority
  security.rtkit.enable = true;
}
