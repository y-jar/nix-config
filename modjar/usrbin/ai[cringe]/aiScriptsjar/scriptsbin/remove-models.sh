#!/usr/bin/env bash
# remove-models.sh — interactively remove ollama models

MODELS=(
  "qwen3.5:9b"
  "qwen3.5:9b-mlx"
  "qwen3.6:27b"
  "frob/ministral-3:14b"
  "frob/ministral-3:3b"
  "mistral:7b"
  "gemma4:latest"
  "minicpm-v4.6:1b"
)

# only show models that are actually installed
INSTALLED=$(ollama list 2>/dev/null | awk 'NR>1 {print $1}')
AVAILABLE=()
for model in "${MODELS[@]}"; do
  if echo "$INSTALLED" | grep -qx "$model"; then
    AVAILABLE+=("$model")
  fi
done

if [ ${#AVAILABLE[@]} -eq 0 ]; then
  echo "No models installed."
  exit 0
fi

SELECTED=$(printf '%s\n' "${AVAILABLE[@]}" | fzf --multi \
  --header="┌──────────────────────────────
│  Ollama Model Remover
│
│  Select models to remove.
│  [Tab] toggle  [Ctrl-A] all  [Esc] quit
=-" \
  --prompt="Remove > " \
  --height=40% \
  --reverse)

if [ -z "$SELECTED" ]; then
  echo "Nothing selected."
  exit 0
fi

echo ""
echo "Removing:"
echo "$SELECTED" | sed 's/^/  /'
echo ""

read -p "Continue? [Y/n] " confirm
if [[ "$confirm" =~ ^[Nn]$ ]]; then
  echo "Cancelled."
  exit 0
fi

echo ""
while IFS= read -r model; do
  echo "Removing $model..."
  ollama rm "$model"
done <<< "$SELECTED"

echo "Done!"
