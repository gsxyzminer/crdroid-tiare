#!/bin/bash
#links
export xml=https://tmpfiles.org/dl/16212780/roomservice.xml
export errorfix1=https://tmpfiles.org/dl/16212783/android.bp.txt
#tmpfs
mkdir /crdroid
mount /dev/sdc1 /crdroid
fallocate -l 48G /tmp/swap.img
chmod 0600 /tmp/swap.img
mkswap /tmp/swap.img
swapon /tmp/swap.img
#requirements
apt update && apt upgrade -y
apt install git git-lfs curl wget python-is-python3 sudo nano nload -y
sudo apt install bc bison build-essential ccache curl flex g++-multilib gcc-multilib git git-lfs gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses5 libncurses5-dev libsdl1.2-dev libssl-dev libwxgtk3.0-gtk3-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev -y
apt-get install git-core gnupg flex bison build-essential zip curl zlib1g-dev libc6-dev-i386 x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig -y
#repo
curl https://storage.googleapis.com/git-repo-downloads/repo > /bin/repo
chmod +x /bin/repo
git config --global color.ui true
git config --global user.name "Gokul Santhosh"
git config --global user.email "gokulsanthosh.xyz@gmail.com"
#repo init
cd /crdroid
repo init -u https://github.com/crdroidandroid/android.git -b 15.0 --git-lfs --depth=1
mkdir .repo/local_manifests
curl $xml -o .repo/local_manifests/roomservice.xml
#repo sync
rm -fr /crdroid/kernel/xiaomi/Tiare/techpack/camera-legacy
rm -fr /crdroid/kernel/xiaomi/Tiare/techpack/audio-legacy
rm -fr /crdroid/kernel/xiaomi/Tiare/techpack/camera-legacy-m
repo sync -j8
#error fixing
mkdir /crdroid/kernel/xiaomi/mithorium-4.19
ln -sf /crdroid/kernel/xiaomi/Tiare /crdroid/kernel/xiaomi/mithorium-4.19/kernel
ln -sf /crdroid/kernel/xiaomi/Tiare/techpack/camera-legacy /crdroid/kernel/xiaomi/mithorium-4.19/kernel/techpack/camera-legacy
ln -sf /crdroid/kernel/xiaomi/Tiare/techpack/audio-legacy /crdroid/kernel/xiaomi/mithorium-4.19/kernel/techpack/audio-legacy
ln -sf /crdroid/kernel/xiaomi/Tiare/techpack/camera-legacy /crdroid/kernel/xiaomi/mithorium-4.19/kernel/techpack/camera-legacy-m
curl $errorfix1 -o /crdroid/hardware/mithorium/display/LA.UM.9.6.4.r2-03900-89xx.QSSI13r2.0/hal/Android.bp
#build
export USE_CCACHE=1
. build/envsetup.sh
brunch Tiare_4_19
make clean
make -j8
