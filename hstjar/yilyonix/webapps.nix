# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host yilyonix: browser apps treated as desktop apps (webapps).
# -=-=-=-=-=-=-=-=-=-=-=
# Each entry becomes a fuzzel/rofi-searchable app. Fill in real apps below.
#
# Fields per app:
#   name                      display name in launchers (becomes webapp-<slug>)
#   url                       the web address to open
#   mode = "tabbed" | "app" | "pwa"
#       tabbed -> open as a tab in the normal browser window
#       app    -> standalone frameless window (needs chromium for true --app)
#       pwa    -> app-mode + always-isolated profile (like an installed PWA)
#   browser  = "chromium" | "firefox" | "librewolf"   (null = default)
#   autostart = true          launch at WM session start (needs mode app/pwa)
#   isolate  = false          share browser profile instead of per-app isolation
#   icon     = "/path/to.png" (null = default JarOnPar icon)
#   category = "Network"      XDG category for grouping
#   extraArgs = [ "--start-maximized" ]
# -=-=-=-=-=-=-=-=-=-=-=
{ lib, ... }:

{
  sysSettings.webapps = {
    enable = false; # ship disabled by default; set true when you add apps below
    apps = [
      # EXAMPLE:
      # {
      #   name = "YouTube Music";
      #   url = "https://music.youtube.com";
      #   mode = "pwa";
      #   browser = "chromium";
      # }
      # {
      #   name = "Gmail";
      #   url = "https://mail.google.com";
      #   mode = "tabbed";
      # }
    ]; # end of apps
  }; # end of sysSettings.webapps
}
