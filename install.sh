#!/bin/bash

dotfiles="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
bin="$HOME/bin"

link() {
  from="$1"
  to="$2"
  echo "Linking '$to' -> '$from'"
  rm -f $to
  ln -s "$from" "$to"
}


for location in $dotfiles/home/*; do
  file="${location##*/}"
  file="${file%.*}"
  link "$location" "$HOME/.$file"
done

# Create $bin folder if not exist
mkdir -p "$bin"
for location in $dotfiles/bin/*; do
  file="${location##*/}"
  file="${file%.*}"
  # only executable files, ignore directories
  if [ -x "$location" ] && [ ! -d "$location" ]; then
    link "$location" "$bin/$file"
  fi
done

link "$dotfiles/completion/" "$HOME/.completion"

# link vim
link "$dotfiles/vim/vimrc" "$HOME/.vimrc"
link "$dotfiles/vim/gvimrc" "$HOME/.gvimrc"
link "$dotfiles/vim/" "$HOME/.vim"

# Install NPM dependencies
cd $dotfiles/bin
npm install

# Install OS specific stuff
OS=$(uname -s)
[[ $OS = "Darwin" ]] && $dotfiles/install/osx.sh
[[ $OS = "Linux" ]] && $dotfiles/install/linux.sh

unset link
