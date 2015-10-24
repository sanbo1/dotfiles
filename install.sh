#!/bin/sh

DOTDIR="dotfiles"
DOTPATH="~/${DOTDIR}"
GITHUB_URL="https://github.com/sanbo1/${DOTDIR}"

### get dotfiles dir
if [ `ls -1 ~ | grep '${DOTDIR}' | wc -l` -eq 1 ]; then
    # do nothing. go to next step.
    echo "already exsist '${DOTDIR}'"
elif [ `which 'git' | wc -l` -eq 1 ]; then
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

    echo "link ${f}"
    cp -ap "${HOME}/${f}" "${DOTPATH}/backup/."
    ln -snfv "${DOTPATH}/${f}" "${HOME}/${f}"
done




