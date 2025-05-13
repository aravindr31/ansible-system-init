# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

#source "$HOME/.config/bash/typewritten.zsh"

#ZSH_THEME="typewritten"
#ZSH_THEME="af-magic"

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
autoload -U compinit && compinit

zstyle ':completion:*' menu select # tab opens cmp menu
zstyle ':completion:*' special-dirs true # force . and .. to show in cmp menu
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=0\;33 # colorize cmp menu
# zstyle ':completion:*' file-list true # more detailed list
zstyle ':completion:*' squeeze-slashes false # explicit disable to allow /*/ expansion

# main opts
setopt append_history inc_append_history share_history # better history
# on exit, history appends rather than overwrites; history is appended as soon as cmds executed; history shared across sessions
setopt auto_menu menu_complete # autocmp first menu match
setopt autocd # type a dir to cd
setopt auto_param_slash # when a dir is completed, add a / instead of a trailing space
setopt no_case_glob no_case_match # make cmp case insensitive
setopt globdots # include dotfiles
setopt extended_glob # match ~ # ^
setopt interactive_comments # allow comments in shell
unsetopt prompt_sp # don't autoclean blanklines
stty stop undef # disable accidental ctrl s

zstyle ':omz:update' mode reminder # just remind me to update when it's time

source <(fzf --zsh)

plugins=(
    git
    zsh-autosuggestions
    zsh-history-substring-search
    zsh-syntax-highlighting
    )

source $ZSH/oh-my-zsh.sh

bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^J" history-search-forward
bindkey "^K" history-search-backward
bindkey '^R' fzf-history-widget

#zoxide
eval "$(zoxide init zsh)"


# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='code'
fi

setopt extendedglob

# custom bash scripts

if [[ -f "$HOME/.config/bash/.bash_private" ]]; then
    source "$HOME/.config/bash/.bash_private"
fi

for file in $HOME/.config/bash/*.sh; do
    source "$file"
done

# setting up NVM

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"

if [[ -f "$NVM_DIR/nvm.sh" ]]; then
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
fi

export PATH="$PATH:/Users/aravind/.local/bin"
export LS_COLORS="$HOME/.cache/wal/colors.sh"

#Starship Config
export STARSHIP_CONFIG=$HOME/.config/bash/starship.toml
eval "$(starship init zsh)"
