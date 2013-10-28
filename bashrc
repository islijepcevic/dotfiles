#!/bin/bash
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
#HISTSIZE=1000
#HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

## -- FROM UBUNTU BASHRC FOUND AT EPFL GR LABS
# set a fancy prompt (non-color, unless we know we "want" color)
case "$term" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# we have color support; assume it's compliant with ecma-48
	# (iso/iec-6429). (lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='[\[\033[01;30m\]\u@\h\[\033[00m\] \[\033[01;32m\]\W\[\033[00m\]]\$ '
    #PS1='[\[\e[0;92m\]\u@\h\[\033[00m\] \[\033[01;34m\]\W\[\033[00m\]]\$ '
              
else
    #ps1='\u@\h:\w\$ '
    PS1='[\u@\h \W]\$ '
fi
unset color_prompt force_color_prompt

# if this is an xterm set the title to user@host:dir
case "$term" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac
## -- END -- FROM UBUNTU BASHRC FOUND AT EPFL GR LABS 

# ORIGINAL FROM ARCH
#alias ls='ls --color=auto' # (added by Arch)
#PS1='[\u@\h \W]\$ ' # this is how bash prompt looks like (added by Arch)

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias rgrep='grep -R --color=auto'
fi

# some more ls aliases
alias ll='ls -lh'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


# ADDED MANUALLY
export VISUAL="/usr/bin/vim -p -X"

# dummy eth0 for matlab
# ~/dotfiles/dummy_eth0.sh will be executed only when running matlab
touch ~/bin/dummy_not_set
### very cool tutorial for sudo calls in script: http://bit.ly/13vTuo1

if [ "$TERM" == "xterm" ]; then
    export TERM=xterm-256color
fi

export PATH=${PATH}:${HOME}/bin:/opt/epsxe

export WEBOTS_HOME=/home/ivan/Dropbox/EPFL/courses/semester_3/distributed_intelligent_systems/webots
export PATH=${PATH}:${HOME}/bin:/opt/webots

# sudo wpa_supplicant -c /etc/wpa_supplicant/wpa_supplicant.conf -i wlp3s0

# DUAL SCREEN
#xrandr --output DisplayPort-0 --mode 1920x1080 --right-of LVDS
