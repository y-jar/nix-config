#!/usr/bin/env bash
# updatejar the one-command host update.
# -=-=-=-=-=-=-=-=-=-=-=
# does what you'd do by hand:
#   1. cd into the repo + pull latest (jars)
#   2. test the current host's config (nht activates without touching the bootloader)
#   3. if the test passed, ask whether to make it permanent (nhs bootloader)
#   4. print the jar
# -=-=-=-=-=-=-=-=-=-=-=
set -euo pipefail

# [repo + host]
REPO="${JAR_REPO:-$HOME/nix-config}"
HOST="$(hostname)"

cd "$REPO" || {
    echo "updatejar: no repo at $REPO (set JAR_REPO to override)"
    exit 1
}

# [1] pull the latest jar (jars)
echo "==> pulling the latest jar (jars)..."
git pull --rebase origin main

# [2] test the host config (nht)
echo "==> testing $HOST (nht)..."
nh os test --accept-flake-config "$REPO#$HOST"

# [3] test passed offer to deploy to the bootloader (nhs)
deploy=false
if command -v gum >/dev/null 2>&1; then
    if gum confirm "test passed deploy to the bootloader too? (nhs)"; then
        deploy=true
    fi
else
    read -r -p "test passed deploy to the bootloader too? (nhs) [y/N] " reply || true
    if [[ "$reply" =~ ^[Yy]$ ]]; then
        deploy=true
    fi
fi
if [ "$deploy" = true ]; then
    echo "==> deploying $HOST (nhs)..."
    nh os switch --accept-flake-config "$REPO#$HOST"
else
    echo "==> staying on the test config run nhs whenever you're ready"
fi

# [4] the jar
cat <<'JART'
╃
 .▀▀█▀▀ .
   :▓.:
. ▀▀ : ╃
JART
