# dotfiles

```
sudo apt-get update && sudo apt-get install -y \
         build-essential \
         clang-format \
         cmake \
         exuberant-ctags \
         ncdu \
         ncurses-dev \
         python3-dev \
         silversearcher-ag \
         unzip

git clone --recursive git@github.com:nanddalal/dotfiles.git ~/.dotfiles

cd ~/.dotfiles

bash install.sh uninstall_all

# E.g. export PYTHON_VERSION=python3.5
export PYTHON_VERSION=...

bash install.sh install_all
```
