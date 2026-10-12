# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Always-on security baseline: polkit daemon + rtkit (no toggle).
# -=-=-=-=-=-=-=-=-=-=-=
{ ... }: {
  config = {
    security = {
      # polkit DAEMON is always on (many services need it); the gnome auth AGENT
      # is the optional part, see ../polkit (sysset.polkit.enable)
      polkit.enable = true;
      # Improve performance by allowing games to request CPU priority
      rtkit.enable = true;
    };
  }; # end of security config
}
