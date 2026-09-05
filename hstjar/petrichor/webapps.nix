# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host petrichor: browser apps treated as desktop apps (webapps).
# -=-=-=-=-=-=-=-=-=-=-=
# Each entry becomes a fuzzel/rofi-searchable app.
# mode = tabbed (tab in normal browser) | app (standalone window) | pwa (isolated app)
# browser = "chromium" | "firefox" | "librewolf" (null = default; app/pwa default chromium)
# autostart = true -> launch at WM session start. icon null -> JarOnPar default.
# -=-=-=-=-=-=-=-=-=-=-=
{ lib, ... }:

{
  sysSettings.webapps = {
    enable = true;
    apps = [
      {
        name = "YouTube";
        url = "https://www.youtube.com";
        mode = "pwa";
        browser = "chromium";
      }
      {
        name = "Gmail";
        url = "https://mail.google.com";
        mode = "tabbed";
      }
      {
        name = "Proton Mail";
        url = "https://mail.proton.me";
        mode = "app";
        browser = "chromium";
        autostart = true;
      }
    ]; # end of apps
  }; # end of sysSettings.webapps
}
