
function setup_ubuntu() {
    sudo apt upgrade && sudo apt update

    git clone https://github.com/emilioziniades/dotfiles

    sudo add-apt-repository ppa:neovim-ppa/stable -y
    sudo apt update

    sudo apt install -y neovim

    sudo apt install -y zsh
    chsh $(which zsh)

}

function setup_macos() {
    touch ~/.hushlogin
}

function setup() {
    echo "hi"
}

if test -f /etc/os-release 
then
    os_type=$(grep -oP '^NAME="\K\w*' /etc/os-release)
else
    os_type="MacOS"
fi

echo $os_type
