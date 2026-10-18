# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Cross-module sanity assertions (no options, no config besides assertions).
# -=-=-=-=-=-=-=-=-=-=-=
# A check that only concerns ONE module lives in that module. Checks that compare
# two or more modules (so neither owns them) live here: desktop exclusivity, port
# clashes between services, a service that needs another one.
{ config, lib, ... }:
let
  s = config.sysset;

  # [desktop environments] one DE per host (compositors like niri/mango/hyprland
  # may sit next to one DE, they are not DEs)
  desktops = lib.filterAttrs (_: enabled: enabled) {
    gnome = s.gnome.enable;
    cosmic = s.cosmic.enable;
    cinnamon = s.cinnamon.enable;
  };

  # [service ports] every enabled service that binds a fixed port on the host
  services = [
    {
      name = "komga";
      enable = s.server.komga.enable;
      port = 25600;
    }
    {
      name = "jellyfin";
      enable = s.server.jellyfin.enable;
      port = 8096;
    }
    {
      name = "nixdraw";
      enable = s.server.nixdraw.enable;
      port = s.server.nixdraw.port;
    }
    {
      name = "outline";
      enable = s.server.outline.enable;
      port = s.server.outline.port;
    }
    {
      name = "authentik";
      enable = s.server.authentik.enable;
      port = s.server.authentik.port;
    }
    {
      name = "webjar";
      enable = s.server.webjar.enable;
      port = s.server.webjar.port;
    }
    {
      name = "cockpit";
      enable = s.server.cockpit.enable;
      port = s.server.cockpit.port;
    }
    {
      name = "ai (llama.cpp)";
      enable = s.ai.enable && s.ai.llama.enable;
      port = s.ai.port;
    }
    {
      name = "ai (ollama)";
      enable = s.ai.enable && s.ai.ollama.enable;
      port = s.ai.port;
    }
    {
      name = "ai (open webui)";
      enable = s.ai.enable && s.ai.webui.enable;
      port = s.ai.webui.port;
    }
  ];
  active = lib.filter (x: x.enable) services;
  clashes = lib.filterAttrs (_: names: lib.length names > 1) (
    lib.groupBy' (acc: x: acc ++ [ x.name ]) [ ] (x: toString x.port) active
  );
in
{
  assertions = [
    {
      assertion = lib.length (lib.attrNames desktops) <= 1;
      message = "only one desktop environment per host, but these are enabled: ${toString (lib.attrNames desktops)}";
    }
    {
      assertion = clashes == { };
      message = "two services want the same port: ${
        lib.concatStringsSep "; " (lib.mapAttrsToList (port: names: "${port} <- ${toString names}") clashes)
      }";
    }
    {
      assertion = !(s.ai.enable && s.ai.webui.enable) || (s.ai.llama.enable || s.ai.ollama.enable);
      message = "sysset.ai.webui needs a local AI backend: set sysset.ai.llama.enable or sysset.ai.ollama.enable = true.";
    }
    {
      assertion = !(s.ai.llama.enable && s.ai.ollama.enable);
      message = "sysset.ai: enable only one of llama or ollama at a time.";
    }
  ];
}
