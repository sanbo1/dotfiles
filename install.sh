#!/bin/sh

DOTDIR="dotfiles"
DOTPATH="${HOME}/${DOTDIR}"
GITHUB_URL="https://github.com/sanbo1/${DOTDIR}"


#
# inner function
#
### command check
isExistsCmd () {
if type $1 > /dev/null 2>&1; then
    # found
    return 1
else
    # not found
    return 0
fi
}

### install command
insCmd () {
echo "install $1 ..."
if ! type $1 > /dev/null 2>&1; then
#if [ $(which $1 | wc -l) -eq 0 ]; then
    echo "install $1 ...."
    if type yum > /dev/null 2>&1; then
        `sudo yum install $1`
    elif type apt-get > /dev/null 2>&1; then
        `sudo apt-get install $1`
    else
        echo "error: failed install $1."
        exit
    fi
    echo "install $1 finish"
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
insCmd git


### get dotfiles dir
#if [ `ls -1 ${HOME} | grep '${DOTDIR}' | wc -l` -eq 1 ]; then
echo "git clone ${DOTPATH} ...";
if [ -d ${DOTPATH} ]; then
    # do nothing. go to next step.
    echo "already exsist '${DOTPATH}'"
#elif type git > /dev/null 2>&1; then
#elif [ $(which git | wc -l) -eq 0 ]; then
elif [ $(isExistsCmd git) -eq 1 ]; then
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
insCmd vim


### neobundle
#IS_VIM=$(which vim | wc -l)
#IS_GIT=$(which git | wc -l)
URL_NEOBUNDLE="https://github.com/Shougo/neobundle.vim"
#if [ (${IS_VIM} -eq 1) && (${IS_GIT} -eq 1) ]; then
#if [ ${IS_VIM} -a ${IS_GIT} ]; then
echo "install neobundle ..."
if [ $(isExistsCmd vim) -a $(isExistsCmd git) ]; then
    if [ ! -e "${HOME}/.vim/bundle" ]; then
        mkdir ${HOME}/.vim/bundle
        git clone ${URL_NEOBUNDLE} ${HOME}/.vim/bundle/neobundle.vim
        echo "install neobundle finish"
    fi
fi


### make synborick link
echo "make dotfiles synborick link"
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
echo "make dotfiles synborick link finish"

### Change Caps_Lock to Ctrl
#if type xmodmap > /dev/null 2>&1; then
    #xmodmap ~/.Xmodmap
#fi


### add alias
#echo "# some more ls aliases" >> ${HOME}/.bashrc
#echo "alias ll='ls -l'" >> ${HOME}/.bashrc
#echo "alias la='ls -A'" >> ${HOME}/.bashrc
#echo "alias l='ls -CF'" >> ${HOME}/.bashrc


### [Caps Lock] -> [Ctrl]
KEYFILE="/etc/default/keyboard"
echo "change caps -> ctrl"
if [ `cat ${KEYFILE} | grep 'XKBOPTIONS=""' | wc -l` -eq 1 ]; then
    sed -e 's/^XKBOPTIONS=""/XKBOPTIONS="ctrl:nocaps"/' ${KEYFILE} > ${DOTPATH}/keyboard
else
    sed -e 's/^XKBOPTIONS="\(..*\)"/XKBOPTIONS="\1,ctrl:nocaps"/g' ${KEYFILE} > ${DOTPATH}/keyboard
fi
if [ ! -e "${KEYFILE}_backup" ]; then
    sudo mv "${KEYFILE}" "${KEYFILE}_backup"
    sudo ln -snfv "${DOTPATH}/keyboard" "${KEYFILE}"
fi
echo "change caps -> ctrl finish"


### mongodb
echo "install mongodb"
#if [ $(which mongo | wc -l) -eq 1 ]; then
if [ $(isExistsCmd mongo) -eq 1 ]; then
    CURRENT_PATH=$(pwd)
    cd /usr/src
    sudo wget https://github.com/tjanson/mongodb-armhf-deb/releases/download/v2.1.1-1/mongodb_2.1.1_armhf.deb
    sudo aptitude install libboost-dev
    sudo dpkg -i mongodb_2.1.1_armhf.deb
    sudo rm -f mongodb_2.1.1_armhf.deb
    cd ${CURRENT_PATH}
    sudo /etc/init.d/mongodb start
fi
echo "install mongodb finish"


echo "install finish !!"
echo "optional installer [${DOTPATH}/etc/install_raspi2_node.sh]

