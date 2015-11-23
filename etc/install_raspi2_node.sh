#!/bin/sh

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


# install node.js to rasberry pi 2
echo "install node.js"
#if [ $(which node | wc -l) -eq 0 ]; then
if [ $(isExistsCmd node) -eq 0 ]; then
    wget http://node-arm.herokuapp.com/node_latest_armhf.deb
    sudo dpkg -i node_latest_armhf.deb
    rm -f ./node_latest_armhf.deb
fi
echo "install node.js finish"


# upgrade node.js & npm
echo "upgrade node.js & npm"
#if [ $(which npm | wc -l) -eq 1 ]; then
if [ $(isExistsCmd npm) -eq 1 ]; then
    # npm upgrade
    sudo npm install -g npm

    # node.js upgrade
    sudo npm install -g n
fi
#if [ $(which n | wc -l) -eq 1 ]; then
if [ $(isExistsCmd n) -eq 1 ]; then
    sudo n latest
fi
echo "upgrade node.js & npm finish"

# install check
echo "print version [node.js]"
node -v
echo "print version [npm]"
npm --version


# install yeoman
echo "install yeoman"
#if [ $(which npm | wc -l) -eq 1 ]; then
if [ $(isExistsCmd npm) -eq 1 ]; then
    sudo npm install -g yo grunt-cli bower
fi
echo "install yeoman finish"


echo "install raspi2 finish !!"


