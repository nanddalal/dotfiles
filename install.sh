set -ex


export DOTFILES_ROOT=$HOME/.dotfiles


update_submodules() {
  cd $DOTFILES_ROOT
  git submodule update --init --recursive --remote

  cd vim/.vim/bundle/YouCompleteMe
  git submodule update --init --recursive
}


install_bash() {
  ln -s $DOTFILES_ROOT/bash/.bashrc $HOME/.bashrc
}


uninstall_bash() {
  rm -f $HOME/.bashrc
}


install_git() {
  ln -s $DOTFILES_ROOT/git/.gitconfig $HOME/.gitconfig
  ln -s $DOTFILES_ROOT/git/.gitignore $HOME/.gitignore
}


uninstall_git() {
  rm -f $HOME/.gitconfig
  rm -f $HOME/.gitignore
}


install_python() {
  ln -s $DOTFILES_ROOT/python/ipython_config.py $HOME/.ipython/profile_default/ipython_config.py
  ln -s $DOTFILES_ROOT/python/.pdbrc $HOME/.pdbrc
}


uninstall_python() {
  rm -f $HOME/.ipython/profile_default/ipython_config.py
  rm -f $HOME/.pdbrc
}


install_screen() {
  ln -s $DOTFILES_ROOT/screen/.screenrc $HOME/.screenrc
}


uninstall_screen() {
  rm -f $HOME/.screenrc
}


install_vim() {
  cd $DOTFILES_ROOT/vim/vim
  mkdir vim
  ./configure \
    --with-features=huge \
    --enable-multibyte \
    --enable-python3interp=yes \
    --with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \
    --enable-cscope \
    --prefix=$DOTFILES_ROOT/vim/vim/vim
  make install

  ln -s $DOTFILES_ROOT/vim/.vimrc $HOME/.vimrc
  ln -s $DOTFILES_ROOT/vim/.vim $HOME/.vim

  cd $DOTFILES_ROOT/vim/.vim/bundle/fzf
  ./install --bin

  cd $DOTFILES_ROOT/vim/.vim/bundle/YouCompleteMe
  python3 install.py --clang-completer # --gocode-completer
}


uninstall_vim() {
  cd $DOTFILES_ROOT/vim/vim
  rm -rf vim

  rm -f $HOME/.vimrc
  rm -rf $HOME/.vim
}


install_all() {
  install_bash
  install_git
  #install_python
  install_screen
  install_vim
}


uninstall_all() {
  uninstall_bash
  uninstall_git
  #uninstall_python
  uninstall_screen
  uninstall_vim
}


if [ $# -eq 0 ]; then
  echo "=============================================================================="
  echo "must specify function(s) to run"
  echo "=============================================================================="
else
  for func in "$@"
  do
    echo "=============================================================================="
    echo "starting install.sh $func"
    echo "=============================================================================="
    $func
    echo "=============================================================================="
    echo "finished install.sh: $func"
    echo "=============================================================================="
  done
fi
