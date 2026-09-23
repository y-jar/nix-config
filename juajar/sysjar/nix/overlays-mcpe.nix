# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: mcpelauncher-client/ui-qt 1.6.4-qt6 -> 1.8.4-qt6 (26.50-series game support, upstream fixes).
# docs: ../../../resjar/docbin/mcpelauncher.md  [version-bump + crash-repair runbook]
# -=-=-=-=-=-=-=-=-=-=-=
{
  lib,
  ...
}:
{
  config = {
    nixpkgs.overlays = [
      (
        _final: prev:
        let
          curlWithWebsockets = prev.curl.override { websocketSupport = true; };
          patchCurl = map (pkg: if lib.getName pkg == "curl" then curlWithWebsockets else pkg);
        in
        {
          mcpelauncher-client = prev.mcpelauncher-client.overrideAttrs (old: {
            version = "1.8.4-qt6";
            src = prev.fetchFromGitHub {
              owner = "minecraft-linux";
              repo = "mcpelauncher-manifest";
              tag = "v1.8.4-qt6";
              fetchSubmodules = true;
              hash = "sha256-F54XFbXB0dkssva95pmKwPjmmnjupBHCxShySClFUgY=";
            };
            # 26.05's dont_download_glfw_client.patch targets the old glfw fork url
            # used by <=1.6.4; 1.7.6 bumped it, so use the vendored master patch.
            patches = [
              ./mcpe-patches/dont_download_glfw_client.patch
              ./mcpe-patches/fix-cmake4-build.patch
            ];
            buildInputs = patchCurl old.buildInputs;
          }); # end of mcpelauncher-client

          mcpelauncher-ui-qt = prev.mcpelauncher-ui-qt.overrideAttrs (_old: {
            version = "1.8.4-qt6";
            src = prev.fetchFromGitHub {
              owner = "minecraft-linux";
              repo = "mcpelauncher-ui-manifest";
              tag = "v1.8.4-qt6";
              fetchSubmodules = true;
              hash = "sha256-AFQEcSLcjuPZJI/w9LI0/Y/lrPpPXVqgAIULqToCqu8=";
            };
          }); # end of mcpelauncher-ui-qt
        }
      )
    ]; # end of overlays
  }; # end of config
}
