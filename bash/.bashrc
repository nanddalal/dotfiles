# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

export BASHRC=1

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

case "$(uname)" in
    Darwin)
        HOST='nand'
        alias ll='ls -lahtr '
        ;;
    Linux)
        HOST=$(hostname)
        alias ls='ls --color '
        alias ll='ls -lahtr --color '
        ;;
    *)
        HOST=''
esac

function make_prompt ()
{
    echo '$HOST \w'
    if [ -e .git ]; then
        branch=$(git branch | grep '\*' | sed 's/\* *//')
        echo $branch
        if [ -e conf/.git ]; then
            confbranch=$(cd conf && git branch | grep '\*' | sed 's/\* *//')
            if [ "$branch" != "$confbranch" ]; then
                echo $confbranch
            fi
        fi
    fi
}

function join_prompt ()
{
    perl -e 'while (<>) { s/\s+/ /g; push @a, $_ } print join("| ", @a)'
}

PROMPT_COMMAND='PS1="(`basename \"$VIRTUAL_ENV\"`) $(make_prompt | join_prompt)$ "'

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

export DOTFILES_ROOT=$HOME/.dotfiles
export PATH=$DOTFILES_ROOT/bin:$PATH
export PATH=$DOTFILES_ROOT/bin/squashfs-root/usr/bin:$PATH
export PATH=$DOTFILES_ROOT/vim/.vim/bundle/fzf/bin:$PATH
if hash nvim 2>/dev/null; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

alias gpus="watch -n0.2 nvidia-smi"

alias ff='find . -name '

function __vim_find {
  $EDITOR $(ff $*)
}
alias vimf="__vim_find"

alias grep='grep --color '

function __extension_grep {
  ext=$1
  shift
  find . -name "*.$ext" | xargs grep $* --color
}
alias extgrep="__extension_grep"

alias pygrep="extgrep py "
alias portproc="sudo netstat -ntpl | grep "

function __kill_by_grep {
  patt=$1
  echo 'before'
  echo `ps aux | grep $patt | grep -v grep | awk '{print $2}'`
  kill -9 `ps aux | grep $patt | grep -v grep | awk '{print $2}'`
  echo 'after'
  echo `ps aux | grep $patt | grep -v grep | awk '{print $2}'`
}
alias grepkill="__kill_by_grep"

function __extract_func {
  if [ -f $1 ] ; then
    case $1 in
        *.7z)        7z x $1                        ;;
        *.Z)         uncompress $1                  ;;
        *.bz2)       bunzip2 $1                     ;;
        *.deb)       ar x $1                        ;;
        *.gz)        gunzip $1                      ;;
        *.rar)       unrar x $1                     ;;
        *.tar)       tar xvf $1                     ;;
        *.tar.bz2)   tar xvjf $1                    ;;
        *.tar.gz)    tar xvzf $1                    ;;
        *.tar.xz)    tar xf $1                      ;;
        *.tbz2)      tar xvjf $1                    ;;
        *.tgz)       tar xvzf $1                    ;;
        *.zip)       unzip $1                       ;;
        *)           echo "'$1' has unknown format" ;;
    esac
  else
    echo "'$1' does not exist"
  fi
}
alias extract="__extract_func"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -S "$SSH_AUTH_SOCK" ] && [ ! -h "$SSH_AUTH_SOCK" ]; then
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock

unset BASHRC
