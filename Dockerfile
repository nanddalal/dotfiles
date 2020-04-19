FROM ubuntu:18.04

RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         ca-certificates \
         clang-format \
         cmake \
         curl \
         exuberant-ctags \
         git \
         ncdu \
         ncurses-dev \
         python3-dev \
         python3-pip \
         python3-setuptools \
         silversearcher-ag \
         sqlformat \
         unzip

RUN mkdir /root/.dotfiles
WORKDIR /root/.dotfiles
ADD ./ ./

WORKDIR /root/.dotfiles/bin
RUN curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
RUN chmod u+x nvim.appimage
RUN ./nvim.appimage --appimage-extract

WORKDIR /root/.dotfiles
RUN bash install.sh uninstall_all

RUN bash install.sh install_bash
RUN bash install.sh install_python
RUN PYTHON_VERSION=python3.6 bash install.sh install_vim

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
