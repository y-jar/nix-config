#!/usr/bin/env bash
# emoji_picker.sh
# Usage: jemoji
#
# A fuzzel-based emoji and kaomoji picker.
# Emoji are dynamically detected from the system's installed emoji font (Blobmoji)
# using fc-scan + python3. Kaomoji are hardcoded.
# Selected character is copied to clipboard via wl-copy.
# ref: modjar/sysbin/fonts&emoji/ for fontconfig setup

# =-=-=-=-=-=-=-=[ EMOJIS ]-=-=-=-=-=-=-=-=
# Search: EMOJI
# Dynamically reads the installed emoji font's supported codepoints via fc-scan,
# then uses python3's unicodedata to resolve each codepoint to a human-readable name.
# Prefers Blobmoji (blob-style emoji), falls back to any installed emoji font.
emoji_data=$(python3 << 'PYEOF'
import subprocess, unicodedata

# =-=[ Find the emoji font ]=-
# First try: query fontconfig for emoji-language fonts (und-zsye = emoji)
result = subprocess.run(
    ["fc-list", ":lang=und-zsye", "file"],
    capture_output=True, text=True
)
font_path = None
for line in result.stdout.strip().split("\n"):
    path = line.split(":")[0].strip()
    if not path:
        continue
    # Prefer Blobmoji over other emoji fonts
    if "blobmoji" in path.lower() or "Blobmoji" in path:
        font_path = path
        break
    if font_path is None:
        font_path = path

# Second try: search all fonts for anything emoji/blob related
if not font_path:
    result = subprocess.run(
        ["fc-list", "--format=%{file}\n"],
        capture_output=True, text=True
    )
    for line in result.stdout.strip().split("\n"):
        lower = line.lower()
        if "emoji" in lower or "blob" in lower:
            font_path = line.strip()
            break

if not font_path:
    print("# No emoji font found!")
    exit(0)

# =-=[ Get supported codepoints from the font ]=-
# fc-scan outputs the font's charset as hex ranges (e.g. "1f600-1f64f 2600-2604")
result = subprocess.run(
    ["fc-scan", font_path, "--format=%{charset}\n"],
    capture_output=True, text=True
)
charset_raw = result.stdout.strip()

# =-=[ Filter to emoji-only codepoints ]=-
# Only include codepoints in known Unicode emoji blocks.
# Excludes: variation selectors (FE00-FE0F), tag characters (E0020-E007F),
# invisible formatting chars, and anything below U+200D.
def is_emoji(cp):
    if cp < 0x200D:
        return False
    if 0xFE00 <= cp <= 0xFE0F:    # variation selectors
        return False
    if 0xE0020 <= cp <= 0xE007F:  # tag characters
        return False
    if cp in (0x2063, 0x20E3):    # invisible separator, combining Enclosing Keycap
        return False
    # Unicode emoji ranges
    if 0x203C <= cp <= 0x3299: return True  # misc symbols, CJK compat
    if 0x2300 <= cp <= 0x23FF: return True   # misc technical
    if 0x2500 <= cp <= 0x27BF: return True   # box drawing, geometric shapes, dingbats
    if 0x2900 <= cp <= 0x2B55: return True   # supplemental arrows, misc symbols
    if 0x1F000 <= cp <= 0x1FAFF: return True  # all modern emoji blocks
    return False

# =-=[ Parse "lo-hi" ranges into individual codepoints ]=-
codepoints = set()
for part in charset_raw.split():
    if '-' in part:
        lo, hi = part.split('-', 1)
        for cp in range(int(lo, 16), int(hi, 16) + 1):
            codepoints.add(cp)
    else:
        codepoints.add(int(part, 16))

# =-=[ Resolve codepoints to "emoji | Name" strings ]=-
# Skip non-emoji Unicode names (private use, surrogates, etc.)
SKIP = {'PRIVATE USE', 'NOT DEFINED', 'SURROGATE', 'INVISIBLE', 'SEPARATOR'}
results = []
for cp in sorted(codepoints):
    if not is_emoji(cp):
        continue
    char = chr(cp)
    try:
        name = unicodedata.name(char)
    except ValueError:
        continue
    if any(s in name for s in SKIP):
        continue
    results.append(f"{char} | {name.title()}")

for r in results:
    print(r)
PYEOF
)

# =-=-=-=-=-=-=-=[ ASCII ART ]-=-=-=-=-=-=-=-=
# Search: ASCII
# Hardcoded kaomoji and ASCII art faces, organized by emotion/vibe.
# Format: "<character> | <description>"
ascii_data=$(cat <<'ASCII_EOF'
(╯°□°)╯︵ ┻━┻ | Table Flip
┬──┬ ノ( ゜-゜ノ) | Put Back Table
¯\_(ツ)_/¯ | Shrug
( ͡° ͜ʖ ͡°) | Lenny Face
ʕ•ᴥ•ʔ | Bear Face
(•_•) | Neutral
(•_•) >⌐■-■ | Sunglasses on
(⌐■_■) | Cool Guy
ಠ_ಠ | Disapproval
◉_◉ | Stare
(◕‿◕) | Happy
(◕‿◕✿) | Flower Happy
(︺︹︺) | Displeased
(╯°□°)╯ | Raised Arms
(╮°-°)╮ | Shrug Arms
(╥﹏╥) | Crying
(╥_╥) | Sad
(︺︹︺) | Meh
(｡◕‿◕｡) | Cute Happy
(｡◕‿‿◕｡) | Double Happy
(▰˘◡˘▰) | Blush
(◠‿◠✿) | Cute Flower
(¬‿¬) | Suspicious
(¬_¬) | Side Eye
(°ロ°) | Shocked
(°▽°) | Excited
(⊙_☉) | Wide Eye
(⊙_⊙) | O_O
(;;;・_・) | Nervous
(>_<) | Squeeze
(>_>) | Look Right
(<_<) | Look Left
ヾ( ́・ω・`) | Hidden Happy
(;′Д`) | Tear
(×_×) | X Eyes
(×﹏×) | Pain
(◕‿‿◕) | Close Happy
(｡◕‿◕｡) | Cute
(ｏ・_・)ノ | Wave
(ｏ・_・)ノﾞ | Big Wave
(￣▽￣) | Satisfied
(￣ω￣) | Complacent
(￣В￣) | Bashful
(￣^￣) | Proud
(￣‥￣) | Grumpy
(￣.￣) | Flat
(￣▽￣)ノ | Happy wave
(ノ°ο°)ノ | Panic
(˘_˘) | Dull
(˘̩‿˘̩) | Content
(˘⌣˘) | Mellow
(˘ε˘) | Frisky
(˘̩‿‿˘̩) | Content 2
(˘▽˘) | Happy
(˘ω˘) | Relax
(ฅ´ω`ฅ) | Cat happy
(ฅ·ω·ฅ) | Cat
(ฅ>ω<ฅ) | Cat excited
(ฅ^ω^ฅ) | Cat love
(´･ω･`) | Acknowledge
(´-ω-`) | Unfocus
(´∀`) | Acceptance
(´Д`) | Aghast
(´～`) | Sad
(´ο_｀) | Sleepy
(´；ω；`) | Tear
(´ゝω・) | Wink
(´ΘωΘ`) | Sleepy cat
(๑•̀ㅂ•́)و✧ | Determined
(๑>ᴗ<๑) | Cute happy
(๑◕‿◕๑) | Kind
(๑✧◡✧๑) | Starry
(๑´ㅂ`๑) | Blush
(๑´ڡ`๑) | Yum
(๑´•ω•) | Love
(๑¯ω¯๑) | Smug
(๑•̀ㅁ•́ฅ) | Cat determined
(๑ᵔ⌔ᵔ๑) | Soft happy
(๑•̀ω•́)ノ | Wave
(๑´ㅂ`๑) | Shy
(๑ᵔ⤙ᵔ๑) | Content
(ᵔᴥᵔ) | Doggy
(ᵒ̤̑ ₀̑ ᵒ̤̑) | Sad eyes
(ᵒ̤̑ɔɔɘ̑) | Cat curious
(◍•ᴗ•◍) | Shining
(◔_◔) | Susp
(◔‿◔) | Happy side
(◉‿◉) | Big happy
(◉ _ ◉) | Shock
(◕ᴗ◕) | Soft
(◕‿◕) | Standard happy
(◕‿◕)♡ | Heart happy
(◕★‿★◕) | Starry
(✿◠‿◠) | Flower cute
(✿◠‿◠✿) | Cute
(✿>‿✿) | Big cute
(✿^‿^) | Happy flower
(✿^‿^✿) | Double happy
(✿ᵔ‿ᵔ) | Soft flower
(✿□‿□) | Big eyes
(✿◕‿◕✿) | Flower happy
(✿◡‿◡) | Blush flower
(✿´‿`) | Content flower
(＞▽＜) | Happy
(＞▽＜)ノ | Happy wave
(＞ω<) | Squee happy
(＞ｗ＜) | Cute sq
(＞ωωω<) | Level 2 sq
(＾▽＾) | Big happy
(＾ω＾) | Soft happy
(＾▽＾)ノ | Wave happy
(＾∀＾) | Very happy
(＾○＾)○ | Zero happy
(＾▽＾)∼★ | Star!
(＾～＾) | Small happy
(＾◡＾) | Cute
(⊃ • ʖ • )⊃ | Hug
(⊃｡•́‿•̀｡)⊃ | Cosy hug
(⊃ ‿ ⊂) | Hug through
(⊃・ω・)⊃ | Comfy
(⊃。ω。)⊃ | Sleepy hug
(⊃❍‿❍)⊃ | Surprise hug
(⊃☉д☉)⊃ | Oh my!
(⊃*°▽°*)⊃ | Woah!
(⊃ಠ_ಠ)⊃ | Suspicious hug
(⊃◇◇)⊃ | Happy hug
~\(≧▽≦)/~ | Yay!
\o/ | Arms up
o/ | Half wave
\o | Half wave other
o7 | Salute
( ÒωÓ)ノ | Fist pump
( ╹▽╹ ) | Cute face
(⏓‿⏓) | Squish happy
(⏒‿⏒) | Content
(⏓‿‿⏓) | Squish double
(⏒ ⏒) | Sleepy
(⏒ᴗ⏒) | Sweet
(❤ω❤) | Heart eyes
(♥‿♥) | Love
(♡‿♡) | Love
(♡ω♡) | Weak
(♥_♥) | Love love
(♥‿｡) | Tender
(♥д♥) | Heart eyes
♡(◕ᴗ◕✿) | Cute love
♡(✿◕‿◕✿) | Double love
♥(✿◠‿◠) | Love flower
♡(˘▽˘) | Love happy
♡(◉ᴗ◉✿) | Starry love
♥(❤ω❤) | MAXIMUM
♡(♥ω♥✿) | Super love
♡(ᴗ◕✿) | Soft love
♥(◡‿◡✿) | Pink cute
♡(◠‿◠✿) | Happy love
♥(❁´◡`❁} | Blush love
♡(˙ᗜ˙✿) | Excited love
♥(✧ω✧) | Star love
⤜(◔‿‿◔)⤎ | Watcher
⤜(⏓‿⏓)⤎ | Squish watcher
⤜(♥ω♥)⤎ | Love watcher
⤜(◉‿‿◉)⤎ | Wide watcher
⤜(⏒ᴗ⏒)⤎❤ | Sweet watcher
⤜( ✧‿✧)⤎ | Starry watcher
⤜( ˘ ³ ˘)⤎ | Kissy watcher
⤜(⏒ ⏒)⤎ | Sleepy watcher
⤜(>ω<)⤎ | Cute watcher
⤜( ͡° ͜ʖ ͡°)⤎ | Lenny watcher
⤜(⌐■_■)⤎ | Cool watcher
⤜(◕‿◕)⤎ | Watcher
⤜(⚆_⚆)⤎ | Conscious watcher
ʎɐpǝp | Upside down
sʇᴉ lɐuoıʇɐu | Normal stuff
˙ʇı sʎɐʍʎlɐ | Upside down things
₃᷀ ᷁ ᷁ ᷁ ᷁ ᷁᷁᷁ ᷁ ﾊﾘ ハハ | Hug
⊂ ◉ ᴗ ◉ ⊂ ͜つ ッ "" | Boombox dance
ASCII_EOF
)

# =-=-=-=-=-=-=-=[ LAUNCHER ]-=-=-=-=-=-=-=-=
# Combine emoji + kaomoji, pipe into fuzzel's dmenu mode.
# User fuzzy-searches, picks one, and it gets copied to clipboard.
chosen=$(
  (echo "$emoji_data"; echo ""; echo "$ascii_data") \
    | fuzzel --dmenu --lines=15 --prompt="🔍 > " \
    | cut -d'|' -f1 \
    | sed 's/ *$//'
)

[ -n "$chosen" ] && wl-copy "$chosen"
