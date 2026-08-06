{ config, ... }:

{
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    download = null;
    documents = null;
    music = null;
    pictures = null;
    videos = null;
    desktop = null;
    templates = null;
    publicShare = null;
  };

  home.activation.createUserDirs = config.lib.dag.entryAnywhere ''
    mkdir -p \
      ~/resjar \
      ~/rotjar \
      ~/picjar \
      ~/picjar/shotbin \
      ~/musicjar \
      ~/kilnjar \
      ~/artjar \
      ~/entjar \
      ~/docjar \
      ~/vidjar \
      ~/downloads
  '';
}
