# ---------- POWERLEVEL10K INSTANT PROMPT ----------
# Must be at the very top — enables instant prompt before shell fully loads
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Suppress warnings during instant prompt initialization
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# ---------- BASE ----------
# Disable insecure directory warnings for completion
export ZSH_DISABLE_COMPFIX=true

# ---------- ZINIT ----------
# Auto-install zinit if not present
if [[ ! -f ~/.zinit/bin/zinit.zsh ]]; then
  mkdir -p ~/.zinit/bin
  git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin
fi

source ~/.zinit/bin/zinit.zsh

# ---------- PLUGINS ----------
zinit light zsh-users/zsh-autosuggestions    # suggest commands from history
zinit light zsh-users/zsh-completions        # extra completion definitions
zinit light zsh-users/zsh-syntax-highlighting # highlight commands as you type

# Load powerlevel10k theme (use zinit light, not source)
zinit ice depth=1
zinit light romkatv/powerlevel10k

# ---------- COMPLETION ----------
# Initialize completion system (-C skips security check for speed)
autoload -Uz compinit && compinit -C
zstyle ':completion:*' menu select  # interactive menu for completions
zmodload zsh/complist               # enables menuselect keymap

# ---------- SETTINGS ----------
export KEYTIMEOUT=1                              # faster key sequence timeout (vi mode)
bindkey '^K' autosuggest-accept                 # Ctrl+K accepts autosuggestion
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan'       # autosuggestion color

# ---------- HISTORY ----------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt sharehistory        # share history between all sessions
setopt hist_ignore_dups    # don't record duplicate consecutive commands
setopt hist_ignore_space   # don't record commands starting with a space
setopt inc_append_history  # append to history immediately, not on shell exit
setopt hist_reduce_blanks  # remove extra blanks from commands before saving

# ---------- VARIABLES ----------
# Current wallpaper path (used by wallpaper scripts)
WALLPAPER=$(cat ~/scripts/current-path.txt 2>/dev/null)

# ---------- ZOXIDE ----------
# Smarter cd — learns your most-used directories
eval "$(zoxide init zsh)"
alias cd='z'      # replace cd with zoxide
alias zcd='z -i'  # interactive directory picker

# ---------- FZF ----------
# Fuzzy finder — source keybindings and completions
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Default fzf options: preview files with bat, fallback to cat
export FZF_DEFAULT_OPTS="
  --height 40%
  --layout=reverse
  --border
  --preview 'bat --style=numbers --color=always {} 2>/dev/null || cat {}'
  --preview-window=right:60%
"

# ---------- NVM ----------
# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"                   # load nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # load nvm completions

# ---------- ALIASES ----------

# Navigation
alias ..='cd ..'
alias ...='cd ../..'

# Dotfiles — stage all tracked changes, commit with today's date, push
alias dotpush='yadm add -u && yadm commit -m "update $(date +%F)" && yadm push'

# lsd — modern ls replacement
alias ls='lsd'
alias ll='lsd -lah'   # long list with hidden files
alias la='lsd -A'     # list all except . and ..
alias l='lsd -CF'     # compact columns

# Other file tools
alias ex='eza'        # eza file explorer
alias wcp='wl-copy'   # copy to Wayland clipboard
alias man="tldr"      # use tldr instead of man pages

# Safer defaults
alias rm='rm -i'      # prompt before delete
alias cp='cp -r'      # copy recursively by default

# Python virtualenvs
alias da='deactivate'
alias lib='source .lib/bin/activate'               # activate local .lib venv
alias mvenv="source ~/python-main-lib/bin/activate" # activate main shared venv

# Rust
alias crun='cargo run'

# Python shorthand
alias p='python'

# Git
alias s='git status'
alias gl='git log --oneline --graph --decorate'
alias gp='git push'
alias gco='git checkout'

# Misc
alias h='history'
alias j='jobs -l'
alias c='clear'
alias view='kitty +kitten icat'  # display images in kitty terminal
alias untar='tar -xvf'
alias x='aunpack'                # universal archive extractor

# ---------- FUNCTIONS ----------

# f — fuzzy find a file and open it in nvim
f() {
  local file
  file=$(fd --type f --hidden . 2>/dev/null | fzf) && nvim "$file"
}

# fdcd — fuzzy find a directory and cd into it
fdcd() {
  local dir
  dir=$(fd --type d --hidden . 2>/dev/null | fzf) && cd "$dir"
}

# ---------- POWERLEVEL10K CONFIG ----------
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ---------- PATH ----------
export PATH=$PATH:$HOME/.spicetify
