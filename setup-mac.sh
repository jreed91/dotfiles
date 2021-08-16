#!/bin/bash
declare file=""
declare i=""
declare -r -a FILES_TO_SOURCE=(
  "gitconfig"
  "bash_aliases"
  "bash_functions"
  "zshrc"
)

echo "Install homebrew"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor

echo "Install git"
brew install git

echo "Install zsh"
brew install zsh
zsh --version
sudo sh -c "echo $(which zsh) >> /etc/shells" && chsh -s $(which zsh)
Raw

echo "Install ohmyzsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Install basic dependencies"
sudo apt install -y git curl wget

echo "Copy config files"
# copy bash_files
for i in ${!FILES_TO_SOURCE[*]}; do
  file="$HOME/.${FILES_TO_SOURCE[$i]}"
  echo "Copying $file ..."
  cp -r ${FILES_TO_SOURCE[$i]} $file
done


echo "Installing Git Auto Completion"
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash


echo "Installing basic ZSH plugins"
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/supercrabtree/k $ZSH_CUSTOM/plugins/k

echo "Installing Powerlevel10k ZSH theme"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

echo "Creating Projects folder inside Home"
cd ~ && mkdir Projects

echo "Installing Docker & Docker Compose"
curl -fsSL https://get.docker.com -o ~/Downloads/get-docker.sh
sudo sh ~/Downloads/get-docker.sh
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Configuring Docker namespace files"
sudo rm /etc/subgid && sudo touch /etc/subgid
sudo rm /etc/subuid && sudo touch /etc/subuid
echo "$LOGNAME:1000:1" | sudo tee -a /etc/subgid /etc/subuid
echo "$LOGNAME:100000:65536" | sudo tee -a /etc/subgid /etc/subuid

sudo touch /etc/docker/daemon.json
echo "
{
	\"userns-remap\": \"$LOGNAME\"
}
" | sudo tee -a /etc/docker/daemon.json

sudo systemctl restart docker

echo "Done, now you need to logout from your user and log back again"
