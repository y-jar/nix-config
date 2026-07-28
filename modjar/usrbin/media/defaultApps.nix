{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrSettings.media;
in
{
  config = lib.mkIf cfg.enable {
    # [default applications]
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        # [image viewer] loupe
        "image/png" = "org.gnome.Loupe.desktop";
        "image/jpeg" = "org.gnome.Loupe.desktop";
        "image/gif" = "org.gnome.Loupe.desktop";
        "image/webp" = "org.gnome.Loupe.desktop";
        "image/svg+xml" = "org.gnome.Loupe.desktop";
        "image/tiff" = "org.gnome.Loupe.desktop";
        "image/bmp" = "org.gnome.Loupe.desktop";
        "image/x-portable-pixmap" = "org.gnome.Loupe.desktop";

        # [video player] totem (GNOME Videos)
        "video/mp4" = "org.gnome.Totem.desktop";
        "video/x-matroska" = "org.gnome.Totem.desktop";
        "video/webm" = "org.gnome.Totem.desktop";
        "video/x-msvideo" = "org.gnome.Totem.desktop";
        "video/quicktime" = "org.gnome.Totem.desktop";
        "video/x-flv" = "org.gnome.Totem.desktop";
        "video/mpeg" = "org.gnome.Totem.desktop";

        # [audio player] mpv
        "audio/mpeg" = "mpv.desktop";
        "audio/flac" = "mpv.desktop";
        "audio/ogg" = "mpv.desktop";
        "audio/x-wav" = "mpv.desktop";
        "audio/aac" = "mpv.desktop";
        "audio/mp4" = "mpv.desktop";
        "audio/x-flac" = "mpv.desktop";

        # [text editor] neovim
        "text/plain" = "nvim.desktop";

        # [archive manager] file-roller (GNOME)
        "application/zip" = "org.gnome.FileRoller.desktop";
        "application/gzip" = "org.gnome.FileRoller.desktop";
        "application/x-tar" = "org.gnome.FileRoller.desktop";
        "application/x-bzip2" = "org.gnome.FileRoller.desktop";
        "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
        "application/x-rar" = "org.gnome.FileRoller.desktop";
        "application/x-xz" = "org.gnome.FileRoller.desktop";

        # [comic reader] yacreader
        "application/x-cbz" = "YACReader.desktop";
        "application/vnd.comicbook+zip" = "YACReader.desktop";
      };
    }; # end of default applications

    # [packages]
    home.packages = with pkgs; [
      loupe # image viewer (GTK4/Rust, Wayland-native)
      totem # video player (GNOME Videos)
      file-roller # archive manager (GNOME)
    ]; # end of packages
  }; # end of config
}
