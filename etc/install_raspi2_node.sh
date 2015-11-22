#!/bin/sh

# install node.js to rasberry pi 2
if [ $(which node | wc -l) -eq 0 ]; then
    wget http://node-arm.herokuapp.com/node_latest_armhf.deb
    sudo dpkg -i node_latest_armhf.deb
fi

# install check
node -v
npm --version

rm -f ./node_latest_armhf.deb

