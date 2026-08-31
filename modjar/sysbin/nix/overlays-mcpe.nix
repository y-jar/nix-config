# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: mcpelauncher-client/ui-qt 1.6.4-qt6 -> 1.7.6-qt6 (Xbox Live websocket curl, upstream fixes).
# -=-=-=-=-=-=-=-=-=-=-=
{
  lib,
  pkgs,
  ...
}:
{
  config = {
    nixpkgs.overlays = [
      (final: prev: let
        curlWithWebsockets = prev.curl.override { websocketSupport = true; };
        patchCurl = map (pkg: if lib.getName pkg == "curl" then curlWithWebsockets else pkg);
      in {
        mcpelauncher-client = prev.mcpelauncher-client.overrideAttrs (old: {
          version = "1.7.6-qt6";
          src = prev.fetchFromGitHub {
            owner = "minecraft-linux";
            repo = "mcpelauncher-manifest";
            tag = "v1.7.6-qt6";
            fetchSubmodules = true;
            hash = "sha256-KAHAr1cAkG6B15CTwxRWZWT9IdTcvCSal3jrPe8C4wE=";
          };
          # 26.05's dont_download_glfw_client.patch targets the old glfw fork url
          # used by <=1.6.4; 1.7.6 bumped it, so use the vendored master patch.
          patches = [
            ./mcpe-patches/dont_download_glfw_client.patch
            ./mcpe-patches/fix-cmake4-build.patch
          ];
          buildInputs = patchCurl old.buildInputs;
        }); # end of mcpelauncher-client

        mcpelauncher-ui-qt = prev.mcpelauncher-ui-qt.overrideAttrs (old: {
          version = "1.7.6-qt6";
          src = prev.fetchFromGitHub {
            owner = "minecraft-linux";
            repo = "mcpelauncher-ui-manifest";
            tag = "v1.7.6-qt6";
            fetchSubmodules = true;
            hash = "sha256-Oibi7+LJK7K1a1fFN2SKy4XiA0gSC4u7Wmk0t86SHaw=";
          };
        }); # end of mcpelauncher-ui-qt
      })
    ]; # end of overlays
  }; # end of config
}