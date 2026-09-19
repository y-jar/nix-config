#!/usr/bin/env bash
set -eu

# gu: unpack a .bundle into a repo (clone if new, pull if it already exists).
# usage: gu <name>[.bundle] [dest]     (default dest: the bundle's name)
# note: a fresh clone's origin points at the bundle file itself; re-point it
# with `git remote set-url origin <url>` once the real remote is reachable.

# --[colors]--
R='\033[0;31m' G='\033[0;32m' Y='\033[1;33m' C='\033[0;36m' N='\033[0m'

# --[args]--
if [[ $# -lt 1 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "usage: gu <name>[.bundle] [dest]"
    exit 0
fi
BUNDLE="$1"
DEST="${2:-}"

# --[find the bundle]--
[[ "$BUNDLE" == *.bundle ]] || BUNDLE="$BUNDLE.bundle"
if [[ ! -f "$BUNDLE" ]]; then
    echo -e "${R}gu:${N} $BUNDLE not found" >&2
    exit 1
fi

# --[default dest = bundle name]--
if [[ -z "$DEST" ]]; then
    DEST=$(basename "$BUNDLE" .bundle)
fi

# --[check the bundle is healthy]--
# (a git bundle file always starts with a "# vN git bundle" header; deeper
# prerequisite checks happen naturally in clone/pull, which run in a repo)
if ! head -n1 "$BUNDLE" | grep -q "git bundle"; then
    echo -e "${R}gu:${N} $BUNDLE is not a git bundle" >&2
    exit 1
fi

# --[unpack]--
if [[ -e "$DEST/.git" ]]; then
    # existing repo: refresh it from the bundle
    # (absolute path: git -C resolves relatives against DEST, not the caller)
    git -C "$DEST" pull "$(readlink -f "$BUNDLE")"
    echo -e "${G}updated:${N} $DEST ${C}(pulled from $BUNDLE)${N}"
else
    if [[ -e "$DEST" ]]; then
        echo -e "${R}gu:${N} $DEST exists and is not a git repo" >&2
        exit 1
    fi
    git clone "$BUNDLE" "$DEST"
    echo -e "${G}unbundled:${N} $DEST ${C}(cloned from $BUNDLE)${N}"
fi
