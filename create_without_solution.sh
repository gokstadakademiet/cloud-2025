#!/bin/bash

# Check if a file is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <file>"
  exit 1
fi

# Use sed to remove everything inside <details><summary>Løsning></summary> tags
sed '/<details><summary>Løsning<\/summary>/,/<\/details>/d' "$1" > "${1%.md}_no_solution.md"

echo "Cleaned content saved to ${1%.md}_no_solution.md"