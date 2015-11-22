#!/bin/sh

# install node.js to rasberry pi 2
if [ $(which node | wc -l) -eq 0 ]; then
    wget http://node-arm.herokuapp.com/node_latest_armhf.deb
    sudo dpkg -i node_latest_armhf.deb
    rm -f ./node_latest_armhf.deb
fi


# upgrade node.js & npm
if [ $(which npm | wc -l) -eq 1 ]; then
    # npm upgrade
    sudo npm install -g npm

    # node.js upgrade
    sudo npm install -g n
    sudo n latest
fi

# install check
node -v
npm --version


# install yeaman
if [ $(which npm | wc -l) -eq 1 ]; then
    sudo npm install -g yo grunt-cli bower
fi


# install angular-fullstack
if [ $(which npm | wc -l) -eq 1 ]; then
    sudo npm install -g generator-angular-fullstack
fi

