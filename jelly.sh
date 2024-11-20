#!bin/sh

mkdir -p /volume1/docker/jellyfin/config
mkdir -p /volume1/docker/jellyfin/cache

curl -kLO# https://github.com/jellyfin/jellyfin-ffmpeg/releases/download/v6.0.1-8/jellyfin-ffmpeg6_6.0.1-8-bookworm_amd64.deb
dpkg-deb -x jellyfin-ffmpeg*.deb temp_dir
mkdir -p /usr/lib/jellyfin-ffmpeg
rsync -av temp_dir/usr/lib/jellyfin-ffmpeg/ /usr/lib/jellyfin-ffmpeg/
cd /usr/lib/jellyfin-ffmpeg
./ffmpeg
