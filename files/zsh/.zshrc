# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
source "$HOME/.config/bash/typewritten.zsh"

#ZSH_THEME="typewritten"
#ZSH_THEME="af-magic"

zstyle ':omz:update' mode reminder # just remind me to update when it's time

plugins=(git)

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='code'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

setopt extendedglob

# custom bash scripts

if [[ -f "$HOME/.config/bash/.bash_private" ]]; then
    source "$HOME/.config/bash/.bash_private"
fi

for file in $HOME/.config/bash/*.sh; do
    source "$file"
done

# export function for azure keys

function azconnect {
    if [[ -f "$HOME/keys/Az-terraform.sh" ]]; then
        source $HOME/keys/Az-terraform.sh && connect-azure-terraform
    else
        echo "Azure Key file not found"
    fi
}

# setting up NVM

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"

if [[ -f "$NVM_DIR/nvm.sh" ]]; then
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
fi

# adding $HOME/Apps folder to PATH

# if ! [[ -d "$HOME/Apps" ]]; then
#     mkdir $HOME/Apps
# fi
# export PATH="$HOME/Apps:$PATH"

function boot_windows() {
    windows_title=$(sudo grep -i windows /boot/grub/grub.cfg | cut -d "'" -f 2)
    sudo grub-reboot "$windows_title" && sudo reboot
}
alias boot_win='boot_windows'

#Spaceship config
source /opt/homebrew/opt/spaceship/spaceship.zsh
