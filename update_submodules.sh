cd $DOTFILES_ROOT
git submodule update --init --recursive --remote

cd vim/.vim/bundle/YouCompleteMe
git submodule update --init --recursive
