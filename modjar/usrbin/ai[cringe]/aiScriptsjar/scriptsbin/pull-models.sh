#!/usr/bin/env bash
# pull-models.sh — downloads LM Studio models via lms CLI

echo "Pulling LM Studio models..."

lms get zai-org/glm-4.6v-flash
lms get mistralai/ministral-3-14b-reasoning
lms get qwen/qwen3.5-9b

echo "Done! Models downloaded."
