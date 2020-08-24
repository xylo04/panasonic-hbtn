#!/bin/bash
ISMOD=`lsmod|grep panasonic_hbtn`
ISMAKE=`which make`
ISXINPUT=`which xinput`
ISXRANDR=`which xrandr`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
if [ "$EUID" -ne 0 ]
  then printf "Please run as root\n"
  exit
fi
if [ -n "$ISMOD" ]
  then 
    printf "The panasonic_hbtn module is already installed.\n\n"
    printf "Copying the rotate script to /usr/local/bin \n\n"
    cp -i rotate /usr/local/bin
    chmod +x /usr/local/bin/rotate
  exit
fi
if [ -n "$ISMAKE" ]
    then
      printf "Installing Panasonic front panel button module...\n\n"
      make clean
      make
      insmod panasonic-hbtn.ko
      printf "Copying the rotate script to /usr/local/bin \n\n"
      cp -i rotate /usr/local/bin
      chmod +x /usr/local/bin/rotate
    else
      printf "\"make\" command not found!\n"
      printf "You need to have a valid compiler installed.\n"
      printf "You might need to install \"make\" or check to see if it's in your PATH.\n"
    exit
fi
if [ ! -n "$ISXINPUT" ]
    then  printf "You need to install \"xinput\" for the rotate script to work.\n"
fi
if [ ! -n "$ISXRANDR" ]
    then  printf "You need to install \"xrandr\" for the rotate script to work.\n"
fi

# For Ubuntu ~18, we need a different xinput for touchscreen calibration
sudo apt install xserver-xorg-input-evdev xinput-calibrator
sudo apt remove xserver-xorg-input-libinput

# Install GPSD options
sudo cp gpsd /etc/default/gpsd

