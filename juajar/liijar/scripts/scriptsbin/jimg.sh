#!/usr/bin/env bash
set -eu

# jimg: ImageMagick preset menu (fuzzel) for one or more images.
# Usage:
#   jimg [file...]     # with a file-manager/yazi selection
#   jimg               # prompts for a directory, then acts on all images in it
# Env:
#   JIMG_WATERMARK  watermark png
#                   (default: Nix-injected resjar/scriptdepbin/watermark.png;
#                    falls back to ~/picjar/watermark.png when run outside the flake)

NOTIFY() { notify-send "jimg" "$1" -i image-x-generic 2>/dev/null || true; }

WATERMARK="${JIMG_WATERMARK:-$HOME/picjar/watermark.png}"

menu=(bw border wborder cropborder scale flip vflip png jpg watermark transparency)
choice="$(printf '%s\n' "${menu[@]}" | fuzzel --dmenu --prompt='ImageMagick > ' --lines=${#menu[@]})" || exit 0
[ -n "$choice" ] || exit 0

files=("$@")
if [ "${#files[@]}" -eq 0 ]; then
  dir="$(printf '' | fuzzel --dmenu --prompt='Directory > ' --lines=0)" || exit 0
  [ -n "$dir" ] || exit 0
  [ -d "$dir" ] || {
    NOTIFY "not a directory: $dir"
    exit 1
  }
  mapfile -t files < <(find "$dir" -maxdepth 1 -type f -iregex '.*\.\(png\|jpe\?g\|webp\|bmp\|tiff\?\)' | sort)
fi
[ "${#files[@]}" -gt 0 ] || {
  NOTIFY "no images"
  exit 1
}

for f in "${files[@]}"; do
  case "$choice" in
    bw) magick "$f" -colorspace Gray "$f.bw" ;;
    border) magick "$f" -bordercolor black -border 50x50 "$f.border" ;;
    wborder) magick "$f" -bordercolor white -border 50x50 "$f.wborder" ;;
    cropborder)
      magick "$f" -fill black -stroke none -draw "rectangle 0,0 %[fx:w],%[fx:h*0.05] rectangle 0,0 %[fx:w*0.05],%[fx:h] rectangle %[fx:w-w*0.05],0 %[fx:w],%[fx:h] rectangle 0,%[fx:h-h*0.05] %[fx:w],%[fx:h]" "$f.cropborder"
      ;;
    scale) magick "$f" -scale 50% "$f.scale" ;;
    flip) magick "$f" -flop "$f.flip" ;;
    vflip) magick "$f" -flip "$f.vflip" ;;
    png) magick "$f" "${f%.*}.png" ;;
    jpg) magick "$f" "${f%.*}.jpg" ;;
    watermark)
      [ -f "$WATERMARK" ] || {
        NOTIFY "no watermark at $WATERMARK"
        exit 1
      }
      magick composite -compose overlay -gravity center -dissolve 40% "$WATERMARK" "$f" "$f.watermark"
      ;;
    transparency)
      magick "$f" -alpha off -fuzz 10% -fill none -draw "alpha 0,0 floodfill" \( +clone -alpha extract -blur 0x2 -level 50x100% \) -alpha off -compose copy_opacity -composite "$f.trnsprnt"
      ;;
  esac
done

NOTIFY "$choice done (${#files[@]} file(s))"
