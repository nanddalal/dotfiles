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
  mkdir -p $HOME/.ipython/profile_default
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

  PYTHON_CONFIGURE_FLAGS=""
  if [[ ${PYTHON_VERSION} == "python2.7" ]]; then
    PYTHON_CONFIGURE_FLAGS+=" --enable-pythoninterp=yes "
    PYTHON_CONFIGURE_FLAGS+=" --with-python-command=python2.7 "
  elif [[ ${PYTHON_VERSION} == "python3.5" ]]; then
    PYTHON_CONFIGURE_FLAGS+=" --enable-python3interp=yes "
    PYTHON_CONFIGURE_FLAGS+=" --with-python3-command=python3.5 "
  else
    echo "Unsupported python version : ${PYTHON_VERSION}"
    echo "Compiling vim without python support"
  fi

  rm -f src/auto/config.cache
  ./configure \
    --with-features=huge \
    --enable-multibyte \
    $PYTHON_CONFIGURE_FLAGS \
    --enable-cscope \
    --prefix=$DOTFILES_ROOT/vim/vim/vim
  make install

  ln -s $DOTFILES_ROOT/vim/.vimrc $HOME/.vimrc
  ln -s $DOTFILES_ROOT/vim/.vim $HOME/.vim

  cd $DOTFILES_ROOT/vim/.vim/bundle/fzf
  ./install --bin

  cd $DOTFILES_ROOT/vim/.vim/bundle/YouCompleteMe
  $PYTHON_VERSION install.py --clang-completer # --gocode-completer
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
  install_python
  install_screen
  install_vim
}


uninstall_all() {
  uninstall_bash
  uninstall_git
  uninstall_python
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
