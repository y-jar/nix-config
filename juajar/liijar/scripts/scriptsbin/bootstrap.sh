#!/usr/bin/env bash
set -eu

# bootstrap: interactive project-folder wizard (name, language, git skeleton).
# Usage: bootstrap

GRN=$'\033[0;32m'
YLW=$'\033[0;33m'
RED=$'\033[0;31m'
BLD=$'\033[1m'
RST=$'\033[0m'

while true; do
  read -r -p "Project name: " proj_name
  if [ -z "$proj_name" ]; then
    printf '%sname required, try again%s\n' "$YLW" "$RST"
  elif [ -e "$proj_name" ]; then
    printf '%s"%s" already exists, pick another name%s\n' "$RED" "$proj_name" "$RST"
  else
    break
  fi
done

printf '\n%sLanguages%s\n  1) python   2) node   3) web\n' "$BLD" "$RST"
while true; do
  read -r -p "Choice [1-3]: " choice
  case "$choice" in
    1 | 2 | 3) break ;;
    *) printf '%sinvalid choice, try again%s\n' "$RED" "$RST" ;;
  esac
done

mkdir -p "$proj_name"

case "$choice" in
  1)
    lang_full=Python
    cat >"$proj_name/.gitignore" <<'EOF'
__pycache__/
*.py[cod]
*.egg-info/
.venv/
venv/
.env
EOF
    if command -v python3 >/dev/null 2>&1 && python3 -m venv "$proj_name/.venv" >/dev/null 2>&1; then
      printf '%screated .venv%s\n' "$GRN" "$RST"
    else
      printf '%svenv skipped%s\n' "$YLW" "$RST"
    fi
    ;;
  2)
    lang_full=Node
    cat >"$proj_name/.gitignore" <<'EOF'
node_modules/
dist/
coverage/
.env
npm-debug.log*
EOF
    ;;
  3)
    lang_full=Web
    cat >"$proj_name/index.html" <<'EOF'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>New Project</title>
    <link rel="stylesheet" href="style.css" />
  </head>
  <body>
    <script src="script.js"></script>
  </body>
</html>
EOF
    cat >"$proj_name/style.css" <<'EOF'
:root {
  --bg: #1d2021;
  --fg: #ebdbb2;
  --accent: #98971a;
}

* {
  box-sizing: border-box;
}

body {
  margin: 0;
  font-family: sans-serif;
  background: var(--bg);
  color: var(--fg);
}
EOF
    cat >"$proj_name/script.js" <<'EOF'
console.log("ready");
EOF
    cat >"$proj_name/.gitignore" <<'EOF'
node_modules/
dist/
.DS_Store
EOF
    ;;
esac

cat >"$proj_name/README.md" <<EOF
# $proj_name

A ${lang_full} project.
EOF

if command -v git >/dev/null 2>&1; then
  if git -C "$proj_name" init -q; then
    printf '%sgit initialized%s\n' "$GRN" "$RST"
  else
    printf '%sgit init failed%s\n' "$RED" "$RST"
  fi
else
  printf '%sgit not found, skipping init%s\n' "$YLW" "$RST"
fi

printf '%s%s ready (%s)%s\n' "$GRN" "$proj_name" "$lang_full" "$RST"
