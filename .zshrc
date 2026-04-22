# ---------- ⚡ POWERLEVEL10K (САМОЕ ПЕРВОЕ) ----------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# ---------- ⚡ БАЗА ----------
export ZSH_DISABLE_COMPFIX=true

# ---------- 📦 ZINIT ----------
if [[ ! -f ~/.zinit/bin/zinit.zsh ]]; then
  mkdir -p ~/.zinit/bin
  git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin
fi

source ~/.zinit/bin/zinit.zsh

# ---------- 🔌 ПЛАГИНЫ ----------
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-syntax-highlighting

# тема (без source!)
zinit ice depth=1
zinit light romkatv/powerlevel10k

# ---------- ⚙️ COMPLETION ----------
autoload -Uz compinit && compinit -C
zstyle ':completion:*' menu select
zmodload zsh/complist

# ---------- ⚙️ НАСТРОЙКИ ----------
export KEYTIMEOUT=1
bindkey '^K' autosuggest-accept
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan'

# ---------- 📜 HISTORY ----------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt appendhistory
setopt sharehistory
setopt hist_ignore_dups
setopt hist_ignore_space
setopt inc_append_history
setopt hist_reduce_blanks

# ---------- 📁 ПЕРЕМЕННЫЕ ----------
WALLPAPER=$(cat ~/scripts/current-path.txt 2>/dev/null)

# ---------- 🚀 ZOXIDE ----------
eval "$(zoxide init zsh)"
alias cd='z'
alias zi='z -i'

# ---------- 🔍 FZF ----------
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# базовые опции
export FZF_DEFAULT_OPTS="
  --height 40%
  --layout=reverse
  --border
  --preview 'bat --style=numbers --color=always {} 2>/dev/null || cat {}'
  --preview-window=right:60%
"

# ---------- 📦 NVM ----------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# ---------- 🧹 АЛИАСЫ ----------
alias ..='cd ..'
alias ...='cd ../..'

alias ls='lsd'
alias ll='lsd -lah'
alias la='lsd -A'
alias l='lsd -CF'

alias ex='eza'
alias wcp='wl-copy'
alias man="tldr"

alias rm='rm -i'
alias cp='cp -r'

alias da='deactivate'
alias lib='source .lib/bin/activate'
alias mvenv="source ~/python-main-lib/bin/activate"
alias crun='cargo run'

alias p='python'

alias s='git status'
alias gl='git log --oneline --graph --decorate'
alias gp='git push'
alias gco='git checkout'

alias h='history'
alias j='jobs -l'
alias c='clear'

alias view='kitty +kitten icat'

alias untar='tar -xvf'
alias x='aunpack'

f() {
  local file
  file=$(fd --type f --hidden . 2>/dev/null | fzf) && nvim "$file"
}

fdcd() {
  local dir
  dir=$(fd --type d --hidden . 2>/dev/null | fzf) && cd "$dir"
}

# ---------- 🎨 P10K CONFIG ----------
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH=$PATH:/home/jayfaza/.spicetify
export PATH=$PATH:~/.spicetify
