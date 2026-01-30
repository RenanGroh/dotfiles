#!/bin/bash

# Caminhos (Baseado na sua RX 6750 XT em card1)
usage_path="/sys/class/drm/card1/device/gpu_busy_percent"
temp_path="/sys/class/drm/card1/device/hwmon/hwmon*/temp1_input"

# Leitura segura (se o arquivo não existir, não quebra)
usage=$(cat "$usage_path" 2>/dev/null || echo "0")
temp_raw=$(cat $temp_path 2>/dev/null || echo "0")

# Matemática simples no Bash (divisão inteira)
temp_c=$((temp_raw / 1000))

# Saída Formatada: "GPU 45% 60°C"
echo "GPU $usage% $temp_c°C"
