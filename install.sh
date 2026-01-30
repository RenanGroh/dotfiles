#!/bin/bash
# De permissão ao install.sh
# chmod +x ~/dotfiles/install.sh

# 1. Instalar pacotes essenciais (Lista gerada antes)
echo "📦 Instalando pacotes..."
sudo pacman -S --needed - <pkglist.txt

# 2. Aplicar configs de usuário (Stow)
echo "🔗 Linkando dotfiles..."
stow hypr nvim kitty zsh waybar local

# 3. Instalar o tema do SDDM (A parte do sistema)
echo "🖥️ Configurando SDDM..."
# Copia o tema para a pasta do sistema
sudo cp -r sddm-theme/vitreous /usr/share/sddm/themes/
# Copia a config
sudo cp sddm-theme/sddm.conf /etc/
# Habilita o serviço
sudo systemctl enable sddm

echo "✅ Instalação Concluída! Reinicie o PC."
