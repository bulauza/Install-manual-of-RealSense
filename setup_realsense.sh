#!/bin/bash
source ./check.sh

echo $(colored $cyan "Start")
#check pip3 install -r requirements.txt
check sudo apt-key adv --keyserver keys.gnupg.net --recv-key C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C8B3A55A6F3EFCDE

# if ubuntu16 LTS
sudo add-apt-repository "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo xenial main" -u

# if ubuntu18 LTS
#sudo add-apt-repository "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo bionic main" -u

# Install the libraries
check sudo apt install librealsense2-dkms
sudo apt install librealsense2-utils

# Optionally install the developer and debug packages
sudo apt install librealsense2-dev
sudo apt install librealsense2-dbg
g++ -std=c++11 filename.cpp -lrealsense2

# Remove all RealSense SDK-related package
#dpkg -l | grep "realsense" | cut -d " " -f 3 | xargs sudo dpkg --purge

echo $(colored $cyan "Finished")
