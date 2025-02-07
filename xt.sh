#!/bin/bash

TARGET_DIR=$(find /mnt -maxdepth 1 -type d -name "sd*3" | head -1)
if [ ! -f "$TARGET_DIR"/initrd-friend ] && [ ! -f "$TARGET_DIR"/bzImage-friend ]; then
  URL="https://github.com/PeterSuh-Q3/tcrpfriend/releases/latest/download/chksum"
  [ -n "$URL" ] && curl --connect-timeout 5 -s -k -L $URL -O

  if [ -f chksum ]; then
    FRIENDVERSION="$(grep VERSION chksum | awk -F= '{print $2}')"
    echo "bringing over friend version : $FRIENDVERSION "

    LATESTURL="`curl --connect-timeout 5 -skL -w %{url_effective} -o /dev/null "https://github.com/PeterSuh-Q3/tcrpfriend/releases/latest"`"
    FRTAG="${LATESTURL##*/}"
    echo "FRIEND TAG is ${FRTAG}"        
    curl -kLO# "https://github.com/PeterSuh-Q3/tcrpfriend/releases/download/${FRTAG}/chksum" \
    -O "https://github.com/PeterSuh-Q3/tcrpfriend/releases/download/${FRTAG}/bzImage-friend" \
    -O "https://github.com/PeterSuh-Q3/tcrpfriend/releases/download/${FRTAG}/initrd-friend"

    if ls *friend >/dev/null 2>&1; then
        echo "Bringing over my friend from github.com Done!!!!!!!!!!!!!!"
        if [ -n "$TARGET_DIR" ]; then
            cp -vpf --no-preserve=ownership *friend "$TARGET_DIR" && rm -f *friend
            #mv -vf --no-preserve=ownership *friend "$TARGET_DIR" 2>/dev/null
        else
            echo "Error: Target directory not found!"
        fi
    else
        echo "Download failed from github.com friend... !!!!!!!!"
        exit 99
    fi
  fi
else
  echo "friend kernel aleady exists !!!"
fi

echo "change grub boot entry to xTCRP !!!"
TARGET_DIR1=$(find /mnt -maxdepth 1 -type d -name "sd*1" | head -1)
curl -kL# https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/refs/heads/main/grub/grub.cfg -o "$TARGET_DIR1"/boot/grub/grub.cfg

curl -kL# https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/refs/heads/main/xtcrp.tgz -o "$TARGET_DIR"/xtcrp.tgz

#TAR_FILE=${TARGET_DIR}"/xtcrp.tgz"
#SOURCE_FILE="/home/tc/user_config.json"

# Check if the compressed file exists
#if [ -f "$TAR_FILE" ]; then

#    echo "add ${SOURCE_FILE} to ${TAR_FILE} !!!"

    # Decompress the existing archive
#    gunzip "$TAR_FILE"
#    TAR_UNZIPPED="${TAR_FILE%.*}"
    
    # Add the file to the archive
#    tar --append --file="$TAR_UNZIPPED" "$SOURCE_FILE"
    
    # Compress the archive again
#    gzip "$TAR_UNZIPPED"
#fi



