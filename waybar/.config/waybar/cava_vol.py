import sys
import subprocess
import time
import os

# --- Configuração ---
CAVA_CONFIG = "/home/renxn/.config/cava/config_waybar"
BARS = " ▂▃▄▅▆▇█"

# 1. BOOST DO SISTEMA (Sensibilidade ao volume do Windows/Linux)
# Quanto volume do sistema é necessário para liberar o visualizador?
# 1.5 = Com 66% de volume, o visualizador já está liberado no máximo.
VOLUME_BOOST = 1.5 

# 2. GANHO DO SINAL (ISSO AQUI É O QUE "ESTOURA" AS BARRAS)
# Multiplica o valor que vem do Cava.
# 1.0 = Original.
# 2.0 = Dobra a altura de todas as barras.
# 3.0 = Deixa tudo super alto/estourado.
SIGNAL_GAIN = 2.0

def get_volume():
    """Pega o volume do sistema via wpctl"""
    try:
        output = subprocess.check_output(["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]).decode().strip()
        if "MUTED" in output: return 0.0
        vol = float(output.split(":")[1].strip())
        
        # Aplica o Boost do Volume
        vol = vol * VOLUME_BOOST
        if vol > 1.0: vol = 1.0
        return vol
    except:
        return 1.0

proc = subprocess.Popen(
    ["cava", "-p", CAVA_CONFIG], 
    stdout=subprocess.PIPE, 
    stderr=subprocess.DEVNULL, 
    text=True
)

current_vol = get_volume()
last_check = 0

while True:
    line = proc.stdout.readline()
    if not line: break

    # Checa volume a cada 0.5s
    now = time.time()
    if now - last_check > 0.5:
        current_vol = get_volume()
        last_check = now

    line = line.strip().replace(";", "")
    output_str = ""
    
    for char in line:
        if char.isdigit():
            val = int(char)
            
            # 1. Aplica o Ganho no Sinal (Deixa a barra mais alta artificialmente)
            val = val * SIGNAL_GAIN
            
            # 2. Aplica o Volume do Sistema (Corta se o volume estiver baixo)
            scaled_val = int(val * current_vol)
            
            # Garante que não passe do limite (7)
            idx = min(scaled_val, len(BARS) - 1)
            
            # Espessura da barra
            output_str += BARS[idx] * 2
            
    print(output_str)
    sys.stdout.flush()