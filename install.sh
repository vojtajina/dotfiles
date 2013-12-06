#!/bin/bash

dotfiles="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
bin="/usr/local/bin"

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

for location in $dotfiles/bin/*; do
  file="${location##*/}"
  file="${file%.*}"
  if [ -x "$location" ]; then
    link "$location" "$bin/$file"
  fi
done

link "$dotfiles/completion/" "$HOME/.completion"

# link vim
link "$dotfiles/vim/vimrc" "$HOME/.vimrc"
link "$dotfiles/vim/gvimrc" "$HOME/.gvimrc"
link "$dotfiles/vim/" "$HOME/.vim"

# Install OS specific stuff
OS=$(uname -s)
[[ $OS = "Darwin" ]] && $dotfiles/install/osx.sh
[[ $OS = "Linux" ]] && $dotfiles/install/linux.sh

unset link
