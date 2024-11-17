#!/bin/bash

set -u # Unbound variable errors are not allowed

##### INCLUDES ######################################################################################
. /home/tc/functions.sh
#####################################################################################################

function check_internet() {
  ping -c 1 -W 1 8.8.8.8 > /dev/null 2>&1
  return $?
}

function gitclone() {
    git clone -b master --single-branch --depth=1 https://github.com/PeterSuh-Q3/redpill-load.git
    if [ $? -ne 0 ]; then
        git clone -b master --single-branch --depth=1 https://gitea.com/PeterSuh-Q3/redpill-load.git
    fi    
}

function gitdownload() {

    cd /home/tc
    git config --global http.sslVerify false    
    if [ -d /home/tc/redpill-load ]; then
        echo "Loader sources already downloaded, pulling latest"
        cd /home/tc/redpill-load
        git pull
        if [ $? -ne 0 ]; then
           cd /home/tc
           rploader clean
           gitclone    
        fi   
        cd /home/tc
    else
        gitclone
    fi
    
}

getloaderdisk

if [ -z "${loaderdisk}" ]; then
    echo "Not Supported Loader BUS Type, program Exit!!!"
    exit 99
fi

getBus "${loaderdisk}" 

[ "${BUS}" = "nvme" ] && loaderdisk="${loaderdisk}p"
[ "${BUS}" = "mmc"  ] && loaderdisk="${loaderdisk}p"
[ "${BUS}" = "block"  ] && loaderdisk="${loaderdisk}p"

tcrppart="${loaderdisk}3"

if [ -d /mnt/${tcrppart}/redpill-load/ ] && [ -d /mnt/${tcrppart}/tcrp-addons/ ] && [ -d /mnt/${tcrppart}/tcrp-modules/ ]; then
    echo "Repositories for offline loader building have been confirmed. Copy the repositories to the required location..."
    echo "Press any key to continue..."    
    read answer
    cp -rf /mnt/${tcrppart}/redpill-load/ ~/
    mv -f /mnt/${tcrppart}/tcrp-addons/ /dev/shm/
    mv -f /mnt/${tcrppart}/tcrp-modules/ /dev/shm/
    echo "Go directly to the menu. Press any key to continue..."
    read answer
else
    while true; do
      if check_internet; then
        getlatestmshell "noask"
        break
      fi
      sleep 5
      echo "Waiting for internet connection in menu.sh..."
    done
    gitdownload
fi

if [ -z "${1-}" ]; then
  [ -f /tmp/test_mode ] && rm /tmp/test_mode
else
  touch /tmp/test_mode
fi

/home/tc/menu_m.sh
exit 0
