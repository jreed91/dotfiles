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


echo "Install nvm"
brew install nvm

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
git clone https://github.com/lukechilds/zsh-better-npm-completion ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-better-npm-completion
brew install zsh-syntax-highlighting
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters

echo "Installing Powerlevel10k ZSH theme"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

echo "Creating Projects folder inside Home"
cd ~ && mkdir Projects

echo "Done, now you need to logout from your user and log back again"
