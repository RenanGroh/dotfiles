# --- Zsh Core ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# --- Dependency Injection (Plugins do Arch) ---
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# --- Prompt (Starship) ---
eval "$(starship init zsh)"

# --- Load dircolors ---
eval "$(dircolors ~/.dircolors)"

# --- Aliases (Atalhos Úteis) ---
alias ll='ls -la --color=auto'
alias c='clear'
alias update='yay -Syu'
alias vim='nvim'
alias vi='nvim'
alias v='nvim'


# --- Keybindings ---
bindkey "^[[1;5C" forward-word   # Ctrl+Seta Direita
bindkey "^[[1;5D" backward-word  # Ctrl+Seta Esquerda

# --- Modern LS (LSD) ---
# Substitui o ls padrão e agrupa pastas primeiro
alias ls='lsd --group-directories-first'

# Lista em formato de lista detalhada (permissions, size, date)
alias ll='lsd -l --group-directories-first'

# Lista tudo (incluindo ocultos .git, .config)
alias la='lsd -a --group-directories-first'

# O comando supremo (Lista Detalhada + Ocultos)
alias lla='lsd -la --group-directories-first'

# Visualização em Árvore (Excelente para ver estrutura de projetos)
alias tree='lsd --tree'

# --- Zsh Syntax Highlighting Custom Colors (Catppuccin Mocha) ---
# Sobrescreve as cores neon padrão do plugin

# Comando correto (Verde Pastel)
ZSH_HIGHLIGHT_STYLES[command]='fg=#a6e3a1,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#a6e3a1,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#a6e3a1,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=#a6e3a1,bold'

# Comando errado/desconhecido (Vermelho Suave)
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f38ba8,bold'

# Argumentos e Strings (Rosa/Pêssego)
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#f5c2e7'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#f5c2e7'
ZSH_HIGHLIGHT_STYLES[path]='fg=white,underline'
# Define prefixos de caminho (ex: /usr/...) como branco também
#ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=white'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#cba6f7'

# --- Configuração de Histórico (Clean & Unique) ---

# 1. Ignora duplicatas consecutivas (ex: ls, ls, ls -> salva apenas um ls)
setopt HIST_IGNORE_DUPS

# 2. Se você rodar um comando antigo de novo, remove a entrada velha e deixa só a nova
# (Isso mantém a lista limpa e sem repetições antigas)
setopt HIST_IGNORE_ALL_DUPS

# 3. Na busca (Seta pra cima), pula comandos duplicados mesmo que existam no histórico
setopt HIST_FIND_NO_DUPS

# 4. Remove linhas em branco do histórico
setopt HIST_REDUCE_BLANKS

### Lenguages PATHS ###

# --- Go Config ---
# Define o workspace padrão
export GOPATH=$HOME/go
# Adiciona os binários do Go ao PATH do sistema
export PATH=$PATH:$GOPATH/bin:$PATH

# --- Python Config ---
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# --- Cargo RUST ---

export PATH="$HOME/.cargo/bin:$PATH"

# --- ---

# Adicione no final:
# --- fnm (Node Manager) ---
eval "$(fnm env --use-on-cd)"

export PATH=$PATH:/home/renxn/.spicetify

# Created by `pipx` on 2025-12-22 20:37:21
export PATH="$PATH:/home/renxn/.local/bin"

# --- Android SDK ---
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/build-tools

# ---

setopt no_nomatch
