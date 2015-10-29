#!/bin/sh

DOTDIR="dotfiles"
DOTPATH="${HOME}/${DOTDIR}"
GITHUB_URL="https://github.com/sanbo1/${DOTDIR}"
#ORGDIR="org_dotfiles"

### get os type
OS=""
if [ $(expr substr $(uname -s) 1 5) = "Linux" ]; then
    OS="linux"
elif [ "$(uname)" = "Darwin" ]; then
    OS="mac"
    echo "Your platform (mac) is not supported."
    exit 1
elif [ "$(expr substr $(uname -s) 1 10)" == 'MINGW32_NT' ]; then
    OS='cygwin'
    echo "Your platform (cygwin) is not supported."
    exit 1
else
    echo "Your platform ($(uname -a)) is not supported."
    exit 1
fi

### install
if ! type git > /dev/null 2>&1; then
    # git install
    if type yum > /dev/null 2>&1; then
        `yum install git`
    elif type apt-get > /dev/null 2>&1; then
        `apt-get install git`
    else
        echo "error: not install git."
        exit
    fi
fi

### get dotfiles dir
#if [ `ls -1 ${HOME} | grep '${DOTDIR}' | wc -l` -eq 1 ]; then
if [ -d ${DOTDIR} ]; then
    # do nothing. go to next step.
    echo "already exsist '${DOTDIR}'"
elif type git > /dev/null 2>&1; then
    echo "down load ${DOTDIR}"
    git clone --recursive "${GITHUB_URL}" "${DOTPATH}"
else
    echo "error: not found git."
    exit
fi

### change dotfiles
cd ${DOTPATH}
if [ $? -ne 0 ]; then
    echo "not found: ${DOTPATH}"
    exit
fi

### make synborick link
for f in .??*; do
    [ "${f}" = ".git" ] && continue
    #[ "${f}" = ".DS_Store" ] && continue    # for MAC

    #cp -ap --no-dereference "${HOME}/${f}" "${DOTPATH}/${ORGDIR}/."
    mv "${HOME}/${f}" "${HOME}/${f}_backup"
    ln -snfv "${DOTPATH}/${f}" "${HOME}/${f}"
done


