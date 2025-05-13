alias nv="nvim"
alias zshrc="nvim $HOME/.zshrc"
alias ohmyzsh="thunar $HOME/.oh-my-zsh"
alias bashrc="nvim $HOME/.bashrc"
alias ohmyzsh="nvim $HOME/.oh-my-zsh"
alias awrc="nvim $HOME/.config/awesome/rc.lua"
alias bashrc="nvim $HOME/.bashrc"
alias nvimrc="nvim $HOME/.config/nvim"
alias sz="source $HOME/.zshrc"

alias cls="clear"
alias ls="lsd"
alias ll='lsd -hAl --group-directories-first'
alias pac="sudo pacman"
alias update="sudo pacman -Sy"
alias upgrade="sudo pacman -Syyu --noconfirm && yay -Syyu --noconfirm"
alias b="light -S"
alias bx="xrandr --output eDP1  --brightness"

alias shutdown="shutdown now"
alias restart="reboot"
alias suspend="systemctl suspend"
alias logout_aw="pkill -KILL awesome"

alias mountd="sudo mount -t ntfs-3g /dev/sda1 $HOME/Mountpoint/Data"
alias mountc="sudo mount -t ntfs-3g /dev/sdb5 $HOME/Mountpoint/C/"
alias drive="ranger /run/media/$USER"
alias umount="sudo umount"

alias gc="git clone"
alias ga="git add --all"
alias gp="git push"
alias gs="git status"
alias ghc="gh repo create"
alias lg="lazygit"

alias ns="npm start"

alias dm="dmenu_run"
alias tkw="tmux kill-window"
alias tks="tmux kill-session"

alias cat="bat"

alias ovpn="sudo openvpn"

alias w="nitrogen --set-zoom-fill --random $HOME/Media/Wallpapers"

alias rcsyn="rclone sync -P pcloud: $HOME/RClone"
alias resync="rclone bisync $HOME/RClone pcloud: --resync -v"
alias bisync="rclone bisync $HOME/RClone pcloud: -v"

alias top="btop --utf-force"
alias tmux="tmux -u"
alias tsm="transmission-remote"

alias w="wal -q -i $HOME/Pictures/Wallpapers"

alias asconfig="nvim  $HOME/repos/ansible-system-init/files/aerospace/aerospace.toml"
alias syscon="nvim  $HOME/repos/ansible-system-init/"


function ff {
  aerospace list-windows --all | fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort'
}


function azc {
    if [[ -f "$HOME/keys/Az-terraform.sh" ]]; then
        source $HOME/keys/Az-terraform.sh && connect-azure-terraform
    else
        echo "Azure Key file not found"
    fi
}

function boot_win {
    windows_title=$(sudo grep -i windows /boot/grub/grub.cfg | cut -d "'" -f 2)
    sudo grub-reboot "$windows_title" && sudo reboot
}

function sc {
  ls $HOME/repos/ansible-system-init/files | fzf --bind 'enter:execute(bash -c "nvim $HOME/repos/ansible-system-init/files/{1}")+abort'
}

function bsi {
  brew search $1 | fzf --bind 'enter:execute(echo {1} && brew info {1} | grep -q /Casks/ && brew install --cask {1} || brew install {1})+abort'
}
