#!/bin/bash

# 1. Mata silenciosamente (-q)
killall -q waybar

# 2. Loop de segurança: Espera até que o processo realmente suma
while pgrep -x waybar >/dev/null; do sleep 1; done

# 3. Inicia as barras
# O "> /dev/null 2>&1" joga o lixo do log fora para não travar o terminal
# O "& disown" garante que o processo sobreviva independente de quem chamou

waybar -c ~/.config/waybar/config_DP3.jsonc > /dev/null 2>&1 & disown

# Pequena pausa para não encavalar o CSS
sleep 0.2

waybar -c ~/.config/waybar/config_HDMI_1.jsonc > /dev/null 2>&1 & disown

echo "Waybar reiniciado!"
