# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Webtoon downloader (webtoon-dl).
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrSettings.media;

  webtoon-dl = pkgs.buildGoModule {
    pname = "webtoon-dl";
    version = "latest";

    src = pkgs.fetchFromGitHub {
      owner = "robinovitch61";
      repo = "webtoon-dl";
      rev = "main";
      hash = "sha256-QS4cW12YsP2jsRmLUXYQwxLq/w3poTiWj0Dgmg3kzFQ=";
    };

    vendorHash = "sha256-TnorRfbxOK5MBQOVlUFOO77wZNyMK0CP+qeqDpZAnro=";
    # ^ paste the sha256-... hash you got from the nix-build run here

    env.CGO_ENABLED = 0;
    ldflags = [
      "-s"
      "-w"
    ];

    meta = with lib; {
      description = "A CLI for downloading webtoon.com comics as PDF or CBZ";
      homepage = "https://github.com/robinovitch61/webtoon-dl";
      license = licenses.mit;
      mainProgram = "webtoon-dl";
    };
  };
in
{
  config = lib.mkIf cfg.enable {
    home.packages = [ webtoon-dl ];
  };
}
