#!/bin/sh

DOTDIR="dotfiles"
DOTPATH="${HOME}/${DOTDIR}"
GITHUB_URL="https://github.com/sanbo1/${DOTDIR}"
#ORGDIR="org_dotfiles"


### inner function
install_ () {
#if ! Type $1 > /dev/null 2>&1; then
if [ $(which $1 | wc -l) -eq 0 ]; then
    echo "install $1 ...."
    if type yum > /dev/null 2>&1; then
        `sudo yum install $1`
    elif type apt-get > /dev/null 2>&1; then
        `sudo apt-get install $1`
    else
        echo "error: failed install $1."
        exit
    fi
    echo "install $1 finish !!"
else
    echo "already install '$1'"
fi
}


### get os type
OS_TYPE=""
if [ $(expr substr $(uname -s) 1 5) = "Linux" ]; then
    OS_TYPE="linux"
elif [ "$(uname)" = "Darwin" ]; then
    OS_TYPE="mac"
    echo "Your platform (mac) is not supported."
    exit 1
elif [ "$(expr substr $(uname -s) 1 10)" == 'MINGW32_NT' ]; then
    OS_TYPE='cygwin'
    echo "Your platform (cygwin) is not supported."
    exit 1
else
    echo "Your platform ($(uname -a)) is not supported."
    exit 1
fi

### install git
install_ git


### get dotfiles dir
#if [ `ls -1 ${HOME} | grep '${DOTDIR}' | wc -l` -eq 1 ]; then
echo ${DOTPATH};
if [ -d ${DOTPATH} ]; then
    # do nothing. go to next step.
    echo "already exsist '${DOTPATH}'"
#elif type git > /dev/null 2>&1; then
elif [ $(which git | wc -l) -eq 0 ]; then
    echo "down load ${DOTPATH}"
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

### install vim
install_ vim


### make synborick link
for f in .??*; do
    [ "${f}" = ".git" ] && continue
    #[ "${f}" = ".DS_Store" ] && continue    # for MAC

    #cp -ap --no-dereference "${HOME}/${f}" "${DOTPATH}/${ORGDIR}/."
    if [ ! -e "${HOME}/${f}_backup" ]; then
        mv "${HOME}/${f}" "${HOME}/${f}_backup"
        ln -snfv "${DOTPATH}/${f}" "${HOME}/${f}"
        [ "${f}" = ".bashrc" ] && $(source ${HOME}/${f})
    fi
done

### Change Caps_Lock to Ctrl
#if type xmodmap > /dev/null 2>&1; then
    #xmodmap ~/.Xmodmap
#fi


### add alias
#echo "# some more ls aliases" >> ${HOME}/.bashrc
#echo "alias ll='ls -l'" >> ${HOME}/.bashrc
#echo "alias la='ls -A'" >> ${HOME}/.bashrc
#echo "alias l='ls -CF'" >> ${HOME}/.bashrc

