#!/bin/bash
# Procura por 'gemini' no nome da janela
if hyprctl clients | grep -i "class:.*gemini" >/dev/null; then
  echo "󰫢"
else
  echo ""
fi
