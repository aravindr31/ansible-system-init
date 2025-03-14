#! /bin/bash

DOTFILES_DIR="$HOME/repos/dotfiles"

function arch_config() {
    echo "Refreshig package Database"
    sudo pacman -Sy --noconfirm

    if ! pacman -Q git >/dev/null 2>&1; then
        echo "Installing Git"
        sudo pacman -S --noconfirm git
    fi

    if ! pacman -Q python3 >/dev/null 2>&1; then
        echo "Installing Python3"
        sudo pacman -S --noconfirm python3
    fi

    if ! pacman -Q python-pip >/dev/null 2>&1; then
        echo "Installing Python3 Pip"
        sudo pacman -S --noconfirm python-pip
    fi

    if ! pacman -Q openssh >/dev/null 2>&1; then
        echo "Installing OpenSSH"
        sudo pacman -S --noconfirm openssh
    fi

    if ! [ -x "$(command -v ansible)" ]; then
        echo "Installing ansible"
        sudo pacman -S --noconfirm ansible
    fi
}

function debian_config() {
    echo "debian setup is not yet configured"

}

function redhat_config() {
    echo "redhat setup is not yet configured"

}

function sync_ansible-galaxy() {
    echo "Installing Ansible Galaxy Dependencies"
    ansible-galaxy install -r $DOTFILES_DIR/requirements.yml
}

function vault_key_check() {
    local vault_key_file=$(ANSIBLE_LOCALHOST_WARNING=False ANSIBLE_INVENTORY_UNPARSED_WARNING=False ansible localhost -m stat -a"path=$HOME/.ansible/vault/vault.yml" -u aravind -o | cut -d '>' -f 2)
    local file_exists=$(echo "$vault_key_file" | jq '.stat.exists')

    while true; do
        if [ "$file_exists" == "false" ]; then
            echo "Ansible Vault Master Key not found. Please place the key in $HOME/.ansible/vault/ and press any key"
            read -n 1 key

        else
            echo "Vault Master key found"
            return 0
        fi
    done
}

# Initialize variables
distro_name=""
os_family=""

# Parse command-line arguments
while getopts ":d:o:" opt; do
    case $opt in
    d)
        distro_name=$OPTARG
        ;;
    o)
        os_family=$OPTARG
        ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    :)
        echo "Option -$OPTARG requires an argument." >&2
        exit 1
        ;;
    esac
done

# Get OS Distribution type

if [ -z "$os_family" ]; then
    if [ -z "$ID_LIKE" ]; then
        os_family="$ID"
    else
        os_family="$ID_LIKE"
    fi
fi

if [ "$os_family" == "arch" ]; then
    arch_config
elif [ "$os_family" == "debian" ]; then
    debian_config
elif echo "$os_family" | grep -Eq 'fedora|rhel|rocky'; then
    redhat_config
else
    echo "Current OS is not in the configured list. Please run the script again with -o param, attaching the os_family"
    exit 1
fi

if ! [[ -d "$DOTFILES_DIR" ]]; then
    echo "Cloning System Config repository"
    git clone --quiet https://github.com/aravindr31/ansible-system-init.git $DOTFILES_DIR
else
    echo "Updating Config repo"
    git -C $DOTFILES_DIR pull --quiet
fi

pushd $DOTFILES_DIR 2>&1 >/dev/null

sync_ansible-galaxy

vault_key_check

ln -sf $DOTFILES_DIR/ansible.cfg $HOME/.ansible/ansible.cfg

ansible-playbook main.yml -u $USER

popd

sudo pacman -Syyu --noconfim
