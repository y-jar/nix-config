#!/usr/bin/env bash
# pull-models.sh — downloads models via ollama CLI

echo "Pulling Ollama models..."
ollama pull qwen3.5:9b
ollama pull qwen3.5:9b-mlx
ollama pull frob/ministral-3:14b
ollama pull frob/ministral-3:3b
ollama pull mistral:7b
ollama pull gemma4:latest

echo "Done! All models downloaded."
