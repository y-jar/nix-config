# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Hardening / security baseline.
# -=-=-=-=-=-=-=-=-=-=-=
{ ... }: {
  config = {
    security = {
      polkit.enable = true;
      # Improve performance by allowing games to request CPU priority
      rtkit.enable = true;
    };
  }; # end of security config
}
