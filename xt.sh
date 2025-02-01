#!/bin/bash


if [ ! -f /home/tc/sd*3/initrd-friend ] && [ ! -f /home/tc/sd*3/bzImage-friend ]; then

  URL="https://github.com/PeterSuh-Q3/tcrpfriend/releases/latest/download/chksum"
  [ -n "$URL" ] && curl --connect-timeout 5 -s -k -L $URL -O

  if [ -f chksum ]; then
    FRIENDVERSION="$(grep VERSION chksum | awk -F= '{print $2}')"
    echo "bringing over friend version : $FRIENDVERSION \n"

    LATESTURL="`curl --connect-timeout 5 -skL -w %{url_effective} -o /dev/null "https://github.com/PeterSuh-Q3/tcrpfriend/releases/latest"`"
    FRTAG="${LATESTURL##*/}"
    echo "FRIEND TAG is ${FRTAG}"        
    curl -kLO# "https://github.com/PeterSuh-Q3/tcrpfriend/releases/download/${FRTAG}/chksum" \
    -O "https://github.com/PeterSuh-Q3/tcrpfriend/releases/download/${FRTAG}/bzImage-friend" \
    -O "https://github.com/PeterSuh-Q3/tcrpfriend/releases/download/${FRTAG}/initrd-friend"

    if [ $? -ne 0 ]; then
        msgalert "Download failed from github.com friend... !!!!!!!!"
    else
        msgnormal "Bringing over my friend from github.com Done!!!!!!!!!!!!!!"            
    fi
  fi  
fi

echo "change grub boot entry to xTCRP !!!"
curl -kL# https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/refs/heads/main/grub/grub.cfg -o /mnt/sd*1/boot/grub/grub.cfg
