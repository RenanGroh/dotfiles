#!/bin/bash

# Se achar qualquer coisa com "discord" (ignorando maiúsculas)
if hyprctl clients | grep -i "class:.*discord" >/dev/null; then
  echo ""
else
  echo ""
fi
