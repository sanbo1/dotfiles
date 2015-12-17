#!/bin/sh

#
# install library
#
sudo apt-get install libglib2.0-dev
sudo apt-get install libdbus-1-dev
sudo apt-get install libudev-dev
sudo apt-get install libical-dev
sudo apt-get install libreadline6-dev


#
# install bluez
#
wget https://www.kernel.org/pub/linux/bluetooth/bluez-5.30.tar.xz
tar xvJf bluez-5.30.tar.xz
cd bluuez-5.30

./configure --disable-systemd --enable-library

sudo make

sudo make install

# reboot raspberrypi
# set bluetooth addaptor
echo "please reboot."


