FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

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
         tidy \
         unzip

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update && apt-get install -y nodejs

RUN mkdir -p /root/.dotfiles/bin

WORKDIR /root/.dotfiles/bin
RUN curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
RUN chmod u+x nvim.appimage
RUN ./nvim.appimage --appimage-extract

WORKDIR /root/.dotfiles
ADD ./ ./

RUN bash install.sh uninstall_all

RUN bash install.sh install_bash
RUN bash install.sh install_python
RUN bash install.sh install_vim

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
