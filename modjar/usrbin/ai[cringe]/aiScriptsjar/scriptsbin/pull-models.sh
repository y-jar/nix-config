#!/usr/bin/env bash
# pull-models.sh — interactively pull ollama models

MODELS=(
  "qwen3.5:9b"
  "qwen3.5:9b-mlx"
  "frob/ministral-3:14b"
  "frob/ministral-3:3b"
  "mistral:7b"
  "gemma4:latest"
)

SELECTED=$(printf '%s\n' "${MODELS[@]}" | fzf --multi \
  --header="┌──────────────────────────────
│  Ollama Model Installer
│
│  Select models to pull.
│  [Tab] toggle  [Ctrl-A] all  [Esc] quit
=-" \
  --prompt="Pull > " \
  --height=40% \
  --reverse)

if [ -z "$SELECTED" ]; then
  echo "Nothing selected."
  exit 0
fi

echo ""
echo "Pulling:"
echo "$SELECTED" | sed 's/^/  /'
echo ""

read -p "Continue? [Y/n] " confirm
if [[ "$confirm" =~ ^[Nn]$ ]]; then
  echo "Cancelled."
  exit 0
fi

echo ""
while IFS= read -r model; do
  echo "Pulling $model..."
  ollama pull "$model"
done <<< "$SELECTED"

echo "Done!"
