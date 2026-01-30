#!/bin/bash

# --- PREPARAÇÃO ---
echo "🛠️ Preparando o terreno..."
# Garante que git, stow e base-devel (necessário para compilar o yay) estejam instalados
sudo pacman -S --needed --noconfirm git base-devel stow

# --- INSTALAÇÃO DO YAY (AUR Helper) ---
# Verifica se o yay já existe. Se não, instala.
if ! command -v yay &>/dev/null; then
  echo "⬇️ Yay não encontrado. Instalando..."
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
else
  echo "✅ Yay já está instalado."
fi

# --- INSTALAÇÃO DE PACOTES ---
echo "📦 Instalando pacotes oficiais..."
if [ -f "pkglist.txt" ]; then
  sudo pacman -S --needed --noconfirm - <pkglist.txt
else
  echo "⚠️ pkglist.txt não encontrado! Pular."
fi

echo "📦 Instalando pacotes do AUR..."
if [ -f "aurlist.txt" ]; then
  yay -S --needed --noconfirm - <aurlist.txt
else
  echo "⚠️ aurlist.txt não encontrado! Pular."
fi

# --- STOW (LINKAR CONFIGURAÇÕES) ---
echo "🔗 Linkando dotfiles..."

# AQUI ESTÁ A CORREÇÃO: Adicionei as pastas novas (ui, dev, games, system, starship)
# O "-R" (Restow) é bom para forçar a atualização dos links
stow -R hypr nvim kitty zsh waybar local ui dev games system starship gamemode

# --- CONFIGURAÇÃO DO SHELL ---
echo "🐚 Mudando shell padrão para Zsh..."
# Troca o shell do usuário atual para zsh (se já não for)
if [ "$SHELL" != "/usr/bin/zsh" ]; then
  chsh -s /usr/bin/zsh
fi

# --- CONFIGURAÇÃO DO SDDM ---
echo "🖥️ Configurando SDDM..."
# Garante que a pasta de temas existe
sudo mkdir -p /usr/share/sddm/themes/

# Copia o tema 'vitreous' (conforme seu código)
if [ -d "sddm-theme/vitreous" ]; then
  sudo cp -r sddm-theme/vitreous /usr/share/sddm/themes/
  echo "✅ Tema copiado."
else
  echo "⚠️ Pasta do tema vitreous não encontrada no repo!"
fi

# Copia a config
if [ -f "sddm-theme/sddm.conf" ]; then
  sudo cp sddm-theme/sddm.conf /etc/
  echo "✅ Config copiada."
fi

# Habilita o serviço
sudo systemctl enable sddm

echo "✅ Instalação Concluída! Reinicie o PC para ver a mágica."
