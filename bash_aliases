###############################################################################
# SHORTCUTS
###############################################################################
alias h=hg
# Assumes conda is installed there.
alias enter_conda='source ${HOME}/local/anaconda3/etc/profile.d/conda.sh'


###############################################################################
# VIM
###############################################################################

# Set the name of vim session the terminal is tied up to.
vsset() {
  export VI_SERVER=$1
}

# Fire up a new server according to the argument supplied.
vs() {
  vsset $1
  vim --servername $VI_SERVER
}

# Fire up a new (graphical) server according to the argument supplied.
gvs() {
  vsset $1
  gvim --servername $VI_SERVER
}

# Open up the files in the environment Vim server.
es() {
  vim --servername $VI_SERVER --remote-silent $*
}

# Open up the files in the (graphical) environment Vim server.
ges() {
  gvim --servername $VI_SERVER --remote-silent $*
}

###############################################################################
# NAVIGATION TRICKS
###############################################################################
# Navigate back to google3 directory.
alias g3='cd $(pwd | sed "s/google3.*/google3/")'
alias ggg=g3

# Go to directory relative to google3
function cdg() {
  ggg
  cd $1
}

export EXPERIMENTAL=experimental/users/islijepcevic
alias g3e="cdg $EXPERIMENTAL"
alias ggge=g3e

function bb() {
 if [[ "${PWD/*\/google3\/blaze-bin*}" ]]
    then cd "${PWD/\/google3//google3/blaze-bin}" > /dev/null
    else cd "${PWD/\/google3\/blaze-bin//google3}" > /dev/null
 fi
}

function b3() {
 if [[ "${PWD/*\/google3\/blaze-out\/k8*}" ]]
    then cd "${PWD/\/google3//google3/blaze-out/k8-py3-fastbuild/bin}" > /dev/null
    else cd "${PWD/\/google3\/blaze-out\/k8-py3-fastbuild\/bin//google3}" > /dev/null
 fi
}

function tt() {
 if [[ "${PWD/*\/google3\/javatests*}" ]]
    then cd "${PWD/\/google3\/java//google3\/javatests}" > /dev/null
    else cd "${PWD/\/google3\/javatests//google3\/java}" > /dev/null
 fi
}

function bgf() {
 if [[ "${PWD/*\/google3\/blaze-genfiles*}" ]]
    then cd "${PWD/\/google3//google3/blaze-genfiles}" > /dev/null
    else cd "${PWD/\/google3\/blaze-genfiles//google3}" > /dev/null
 fi
}


