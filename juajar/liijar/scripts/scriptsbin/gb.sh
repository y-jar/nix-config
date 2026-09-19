#!/usr/bin/env bash
set -eu

# gb: pack the current repo into a <name>.bundle (all refs) for offline carrying.
# usage: gb [name]     (default: the repo's folder name; ".bundle" suffix optional)
# the bundle lands in the current directory.

# --[colors]--
R='\033[0;31m' G='\033[0;32m' Y='\033[1;33m' C='\033[0;36m' N='\033[0m'

# --[args]--
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    echo "usage: gb [name]    (default: the repo's folder name)"
    exit 0
fi
NAME="${1:-}"

# --[must be inside a repo]--
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo -e "${R}gb:${N} not inside a git repo" >&2
    exit 1
fi

# --[default name = repo folder]--
if [[ -z "$NAME" ]]; then
    NAME=$(basename "$(git rev-parse --show-toplevel)")
fi
NAME="${NAME%.bundle}" # allow passing foo.bundle too

# --[pack]--
OUT="$NAME.bundle"
git bundle create "$OUT" --all

# --[done]--
SIZE=$(du -h "$OUT" | cut -f1)
echo -e "${G}bundled:${N} $OUT ${C}($SIZE, all refs)${N}"
echo -e "${Y}unbundle with:${N} gu $OUT"
