# ── Oh My Zsh ────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# ── Starship ─────────────────────────────────────────────────────
eval "$(starship init zsh)"

# ── Java ─────────────────────────────────────────────────────────
export JAVA_HOME="$(brew --prefix openjdk@21)"
export PATH="$JAVA_HOME/bin:$PATH"

# ── NVM ──────────────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix nvm)/nvm.sh" ] && \. "$(brew --prefix nvm)/nvm.sh"

# ── Zoxide ───────────────────────────────────────────────────────
eval "$(zoxide init zsh)"

# ── Zsh Plugins ──────────────────────────────────────────────────
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_STYLES[command]='fg=#a6e3a1,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#a6e3a1,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#a6e3a1,bold'

# ── Completion (case-insensitive) ────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# ── EZA Aliases ──────────────────────────────────────────────────
alias ls='eza --icons --color=always --group-directories-first'
alias ll='eza --icons --color=always --group-directories-first --long'
alias la='eza --icons --color=always --group-directories-first --long --all'
alias lt='eza --icons --color=always --tree --level=2'
alias lta='eza --icons --color=always --tree --level=2 --all'
export EZA_CONFIG_DIR=~/.config/eza

# ── Other Aliases ─────────────────────────────────────────────────
alias cat="bat"
alias nanoz="nano ~/.zshrc"
alias nvimz="nvim ~/.zshrc"

# ── Misc ──────────────────────────────────────────────────────────
export SHELL=/usr/bin/zsh
export PATH=$PATH:~/.local/bin
