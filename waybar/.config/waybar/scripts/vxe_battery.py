#!/usr/bin/env python3
import hid
import json
import sys
import time

# IDs do VXE R1
VENDOR_ID = 0x373b
PRODUCT_ID = 0x1085


def get_battery():
    found_any = False

    # Varre os dispositivos
    for d in hid.enumerate(VENDOR_ID, PRODUCT_ID):
        if d['interface_number'] == 0:
            continue

        try:
            h = hid.device()
            h.open_path(d['path'])
            h.set_nonblocking(1)

            # Tenta ler o relatório
            try:
                buf = h.get_feature_report(0x06, 9)
            except:
                # Se falhar, tenta dar um "cutucão" e ler de novo
                try:
                    h.write([0x06])
                    time.sleep(0.05)
                    buf = h.get_feature_report(0x06, 9)
                except:
                    h.close()
                    continue

            h.close()

            # LÓGICA CORRIGIDA:
            # O array é: [ID, 0, 0, 0, Val1, 0, Val2, ...]
            # Val1 (index 4) era 230 (90%) -> Ignorar
            # Val2 (index 6) era 155 (60%) -> É esse que queremos!

            if buf and len(buf) > 6:
                raw_val = buf[6]  # Mudamos para o índice 6

                # Cálculo de porcentagem (0-255 -> 0-100%)
                percent = int((raw_val / 255) * 100)

                # Correção de segurança
                if percent > 100:
                    percent = 100
                if percent < 0:
                    percent = 0

                # Se o valor for válido (diferente de 0), mostramos
                if raw_val > 0:
                    print_json(percent, raw_val)
                    return

        except Exception:
            continue

    # Se nada funcionar
    print(json.dumps({"text": "", "tooltip": "VXE: Sleep/Err"}))


def print_json(p, raw):
    if p >= 90:
        icon = ""
    elif p >= 60:
        icon = ""
    elif p >= 40:
        icon = ""
    elif p >= 10:
        icon = ""
    else:
        icon = ""

    print(json.dumps({
        "text": f"{icon} {p}%",
        # No tooltip deixei o valor Raw (bruto) para caso precisemos conferir de novo
        "tooltip": f"VXE R1: {p}% (Raw: {raw})"
    }))


if __name__ == "__main__":
    get_battery()
