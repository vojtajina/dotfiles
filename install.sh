#!/bin/bash

dotfiles="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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


# Clean existing ~/bin
# - copy regular files to $dotfiles/bin
# - ignore symlinks to $dotfiles/bin
# - copy other symlinks
if [ -d "$HOME/bin" ]; then
  for file in $HOME/bin/*; do
    if [ -h $file ]; then
      realpath=$(readlink $file)
      if [[ $realpath = $dotfiles/bin/* ]]; then
        : # Symlink to existing dotfiles, ignoring...
      else
        ln -s $realpath $dotfiles/bin/
      fi
    else
      cp -r $file $dotfiles/bin/
    fi
  done
  rm -rf $HOME/bin
fi

link "$dotfiles/bin/" "$HOME/bin"

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

# Install .lesskey
lesskey

unset link
