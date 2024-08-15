alias nv="nvim"
alias zshrc="nvim $HOME/.zshrc"
alias ohmyzsh="thunar $HOME/.oh-my-zsh"
alias bashrc="nvim $HOME/.bashrc"
alias zshconfig="nvim $HOME/.zshrc"
alias ohmyzsh="nvim $HOME/.oh-my-zsh"
alias awrc="nvim $HOME/.config/awesome/rc.lua"
alias bashrc="nvim $HOME/.bashrc"
alias nvimrc="nvim $HOME/.config/nvim"

alias cls="clear"
alias ls="lsd"
alias ll='lsd -hAl --group-directories-first'
alias pac="sudo pacman"
alias upgrade="sudo pacman -Syyu --noconfirm"
alias b="light -S"
alias bx="xrandr --output eDP1  --brightness"

alias shutdown="shutdown now"
alias restart="reboot"
#alias sleep="betterlockscreen -l &"
alias suspend="systemctl suspend"
#alias hibernate="betterlockscreen -l && sleep 0.5 && systemctl hibernate &"
#alias logout="pkill -KILL -u davidb"
alias logout_aw="pkill -KILL awesome"

alias mountd="sudo mount -t ntfs-3g /dev/sda1 $HOME/Mountpoint/Data"
alias mountc="sudo mount -t ntfs-3g /dev/sdb5 $HOME/Mountpoint/C/"
alias drive="ranger /run/media/davidb"
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

alias ovpn="sudo openvpn"

alias w="nitrogen --set-zoom-fill --random $HOME/Media/Wallpapers"

alias rcsyn="rclone sync -P pcloud: $HOME/RClone"
alias resync="rclone bisync $HOME/RClone pcloud: --resync -v"
alias bisync="rclone bisync $HOME/RClone pcloud: -v"

alias top="btop --utf-force"
alias tmux="tmux -u"
alias tsm="transmission-remote"
