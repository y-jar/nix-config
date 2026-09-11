# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host yil01: browser apps treated as desktop apps (webapps) — hjem host.
# -=-=-=-=-=-=-=-=-=-=-=
# Hjem flavor of the webapp sheet. Same data shape as sysset.webapps so the
# shared system module (autostart) + juajar/liijar/webapps build launchers/entries.
# -=-=-=-=-=-=-=-=-=-=-=
{ lib, ... }:

{
  sysset.webapps = {
    enable = true;
    apps = [
      {
        name = "YouTube Music";
        url = "https://music.youtube.com";
        mode = "pwa";
        browser = "chromium";
      }
      {
        name = "Proton Mail";
        url = "https://mail.proton.me";
        mode = "app";
        browser = "chromium";
        autostart = true;
      }
    ]; # end of apps
  }; # end of sysset.webapps
}
