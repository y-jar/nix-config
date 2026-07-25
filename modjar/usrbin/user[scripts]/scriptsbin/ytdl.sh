#!/usr/bin/env bash
set -eu

# --[colors]--
R='\033[0;31m' G='\033[0;32m' Y='\033[1;33m' C='\033[0;36m' N='\033[0m'

# --[defaults]--
QUALITY="best"
FORCE_AUDIO=false
URL=""

# --[args]--
while [[ $# -gt 0 ]]; do
    case "$1" in
        --best)  QUALITY="best"; shift ;;
        --1080)  QUALITY="1080"; shift ;;
        --720)   QUALITY="720"; shift ;;
        --audio) FORCE_AUDIO=true; shift ;;
        -h|--help)
            echo "Usage: ytdl [OPTIONS] <URL>"
            echo ""
            echo "Options:"
            echo "  --best    Best available quality (default)"
            echo "  --1080    Cap at 1080p"
            echo "  --720     Cap at 720p"
            echo "  --audio   Audio only (mp3)"
            exit 0 ;;
        *)       URL="$1"; shift ;;
    esac
done

if [[ -z "$URL" ]]; then
    echo -e "${C}Paste a YouTube URL:${N}"
    read -r URL
fi

if [[ ! "$URL" =~ ^https?:// ]]; then
    echo -e "${R}Error:${N} Invalid URL. Make sure to quote it:"
    echo -e "  ${Y}dl \"https://youtube.com/playlist?list=...\"${N}"
    exit 1
fi

# --[helpers]--
sanitize() {
    echo "$1" | sed 's/[\/\\:*?"<>|]/-/g' | sed 's/  */ /g' | sed 's/^ *//;s/ *$//'
}

detect_season() {
    local title="$1"
    local num
    num=$(echo "$title" | grep -oP '(?i)(?:season|s)\s*(\d+)' | grep -oP '\d+' | head -1)
    if [[ -n "$num" ]]; then
        printf "S%02d" "$num"
    else
        echo "S01"
    fi
}

quality_fmt() {
    if $FORCE_AUDIO; then
        echo "bestaudio/best"
    else
        case "$QUALITY" in
            best) echo "bestvideo+bestaudio/best" ;;
            1080) echo "bestvideo[height<=1080]+bestaudio/best[height<=1080]/best" ;;
            720)  echo "bestvideo[height<=720]+bestaudio/best[height<=720]/best" ;;
        esac
    fi
}

dl_video() {
    local url="$1" out="$2" fmt="$3"
    yt-dlp -o "$out" -f "$fmt" \
        --embed-thumbnail --embed-metadata \
        --embed-subs --sub-langs "en,en-US,ja" \
        --convert-subs srt \
        --no-overwrites \
        "$url"
}

# --[main]--
PLAYLIST_TITLE=$(yt-dlp --flat-playlist --print "%(playlist_title)s" "$URL" 2>/dev/null | head -1)
ITEM_COUNT=$(yt-dlp --flat-playlist --print "%(playlist_count)s" "$URL" 2>/dev/null | head -1)

if [[ -z "$ITEM_COUNT" || "$ITEM_COUNT" == "NA" || "$ITEM_COUNT" -le 1 ]]; then
    VID_TITLE=$(yt-dlp --print "%(title)s" "$URL" 2>/dev/null | head -1)
    echo -e "${G}Downloading:${N} $VID_TITLE"
    dl_video "$URL" "$HOME/Downloads/%(title)s.%(ext)s" "$(quality_fmt)"
    echo -e "${G}Done!${N} Saved to ~/Downloads/"
    exit 0
fi

echo -e "${C}Playlist:${N} $PLAYLIST_TITLE ($ITEM_COUNT items)"

# --[type select]--
TYPE_MSG=$(echo -e "🎬 Series\n🎵 Music\n📋 Generic" \
    | fzf --prompt="Content type > " --height=10 --reverse \
        --header="How should this be formatted?" \
    || echo "📋 Generic")

# --[quality select]--
if ! $FORCE_AUDIO; then
    QUALITY_MSG=$(echo -e "⭐ Best quality\n📺 1080p\n🖥  720p\n🎵 Audio only" \
        | fzf --prompt="Quality > " --height=10 --reverse \
            --header="Select quality:" \
        || echo "⭐ Best quality")

    case "$QUALITY_MSG" in
        *"1080"*)  QUALITY="1080" ;;
        *"720"*)   QUALITY="720" ;;
        *"Audio"*) FORCE_AUDIO=true ;;
        *)         QUALITY="best" ;;
    esac
fi

# --[folder name]--
DEFAULT_FOLDER=$(sanitize "$PLAYLIST_TITLE")
echo -e "${C}Download folder:${N} ~/Downloads/$DEFAULT_FOLDER"
echo -ne "${Y}Press Enter to confirm, or type a custom name:${N} "
read -r CUSTOM
FOLDER_NAME=$( [[ -n "$CUSTOM" ]] && sanitize "$CUSTOM" || echo "$DEFAULT_FOLDER" )

# --[download]--
DL_DIR="$HOME/Downloads/$FOLDER_NAME"
mkdir -p "$DL_DIR"
FMT=$(quality_fmt)

case "$TYPE_MSG" in
    *"Series")
        SEASON=$(detect_season "$PLAYLIST_TITLE")
        echo -e "${G}Downloading series:${N} $PLAYLIST_TITLE [$SEASON]"
        dl_video "$URL" "$DL_DIR/${SEASON}%(playlist_index)02d - %(title)s.%(ext)s" "$FMT"
        ;;
    *"Music")
        FORCE_AUDIO=true
        FMT="bestaudio/best"
        echo -e "${G}Downloading album:${N} $PLAYLIST_TITLE"
        dl_video "$URL" "$DL_DIR/%(playlist_index)02d - %(title)s.%(ext)s" "$FMT"
        # convert to mp3
        for f in "$DL_DIR"/*.webm "$DL_DIR"/*.m4a "$DL_DIR"/*.opus; do
            [[ -f "$f" ]] && ffmpeg -i "$f" -q:a 0 "${f%.*}.mp3" -y && rm "$f" 2>/dev/null || true
        done
        ;;
    *)
        echo -e "${G}Downloading playlist:${N} $PLAYLIST_TITLE"
        dl_video "$URL" "$DL_DIR/%(playlist_index)02d - %(title)s.%(ext)s" "$FMT"
        ;;
esac

echo -e "${G}Done!${N} Saved to ~/Downloads/$FOLDER_NAME/"
