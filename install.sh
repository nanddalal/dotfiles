set -ex


export DOTFILES_ROOT=$HOME/.dotfiles


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
  pip3 install black==18.9b0 pylint==2.1.1 pynvim==0.4.0
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
  ln -s $DOTFILES_ROOT/vim/.vimrc $HOME/.vimrc
  ln -s $DOTFILES_ROOT/vim/.vim $HOME/.vim

  mkdir -p $HOME/.config/nvim
  ln -s $DOTFILES_ROOT/vim/init.vim $HOME/.config/nvim/init.vim

  cd $DOTFILES_ROOT/vim/.vim/bundle/fzf
  ./install --bin

  cd $DOTFILES_ROOT/vim/.vim/bundle/YouCompleteMe
  $PYTHON_VERSION install.py --clang-completer # --gocode-completer
}


uninstall_vim() {
  rm -f $HOME/.vimrc
  rm -rf $HOME/.vim
  rm -f $HOME/.config/nvim/init.vim
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
