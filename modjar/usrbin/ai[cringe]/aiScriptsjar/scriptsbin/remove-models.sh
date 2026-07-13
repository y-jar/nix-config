#!/usr/bin/env bash
# remove-models.sh — removes models from ollama

echo "=== Ollama Models ==="
ollama list
echo ""
read -p "Remove all Ollama models? [y/N] " ollama_confirm
if [[ "$ollama_confirm" =~ ^[Yy]$ ]]; then
  ollama rm qwen3.5:9b
  ollama rm qwen3.5:9b-mlx
  ollama rm frob/ministral-3:14b
  ollama rm frob/ministral-3:3b
  ollama rm mistral:7b
  ollama rm gemma4:latest
fi

echo "Done!"
