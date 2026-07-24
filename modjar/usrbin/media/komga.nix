{
  komgaEnable,
  pkgs,
  lib,
  ...
}:

lib.mkIf komgaEnable {
  # [KOMGA]
  home.packages = [ pkgs.komga ];

  systemd.user.services.komga = {
    Unit = {
      Description = "Komga - Media server for comics, manga, and other media";
      After = [ "network.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.komga}/bin/komga";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
