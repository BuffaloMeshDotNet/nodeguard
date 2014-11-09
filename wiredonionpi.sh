#!/bin/bash

#################################################################
#
# Wired OnionPi build script
#       vr 0.6
#
# Written by Corey Reichle
# 11/06/2014
# Copyright (c) 2014 by Corey Reichle.  Released under GPL 3 or later.
#
# Based on:
#       https://web.archive.org/web/20131109030345/http://learn.adafruit.com/onion-pi/overview
#       https://web.archive.org/web/20130904194049/http://learn.adafruit.com/setting-up-a-raspberry-pi-as-a-wifi-access-point
#
#################################################################

cat << '_EOF'
This is the OnionPi build script.  It's designed to completely automate turning
your Raspberry Pi into a wired router, that tunnels all traffic over the TOR
network.

Special thanks goes to Ladyada for her tutorials on adafruit.com, and SirLagz
for his package list of non-required packages.

For this script to run correctly, it must be executed as root, or with sudo.  It
cannot be ran as a non-privileged user.  It also presumes you have wlan0 as your
wifi card, and eth0 as the onboard NIC.

You must also configure your SSID and WPA passphrase.  Or, whatever the setup
for your private wifi network.
_EOF

read -p "Press [Enter] key to start install, or CTRL-C to exit..."

echo "Setting up environment:"
cd /home/pi

echo "Getting files:"

echo "Installing required programs via apt..."
apt-get update

apt-get -y install wget isc-dhcp-server tor &>/dev/null

# And, for security, and science...  You monster.
echo "Removing un-needed programs..."
apt-get -y purge alsa-base alsa-utils aptitude aspell-en blt console-setup console-setup-linux consolekit cups-bsd dbus dbus-x11 \
debian-reference-common debian-reference-en desktop-base desktop-file-utils dictionaries-common dillo dpkg-dev fakeroot fontconfig \
fontconfig-config fonts-droid fuse galculator gconf2 gconf2-common gdb gksu gnome-accessibility-themes gsfonts gsfonts-x11 idle idle-python2.7 \
lesstif2:armhf libarchive12:armhf libasound2:armhf libaspell15 libasyncns0:armhf libatasmart4:armhf libatk1.0-0:armhf libaudit0 libavahi-client3:armhf \
libavahi-common3:armhf libavahi-glib1:armhf libbluetooth3:armhf libbluray1:armhf libboost-iostreams1.46.1 libboost-iostreams1.48.0 \
libboost-iostreams1.49.0 libboost-iostreams1.50.0 libcaca0:armhf libcairo-gobject2:armhf libcairo2:armhf libcdio-cdda1 libcdio-paranoia1 \
libcdio13 libck-connector0:armhf libcolord1:armhf libcroco3:armhf libcups2:armhf libcupsimage2:armhf libcwidget3 libdaemon0 libdatrie1:armhf \
libdbus-glib-1-2:armhf libdconf0:armhf libdevmapper-event1.02.1:armhf libdirectfb-1.2-9:armhf libdrm2:armhf libept1.4.12 libexif12:armhf \
libffi5:armhf libflac8:armhf libfltk1.3:armhf libfm-data libfm-gtk-bin libfm-gtk1 libfm1 libfontconfig1:armhf libfontenc1:armhf libfreetype6:armhf \
libfuse2:armhf libgail-3-0:armhf libgail18:armhf libgconf-2-4:armhf libgd2-xpm:armhf libgdk-pixbuf2.0-0:armhf libgdu0 libgeoclue0 libgfortran3:armhf \
libgif4 libgksu2-0 libgl1-mesa-glx:armhf libglade2-0 libglapi-mesa:armhf libglib2.0-0:armhf libgnome-keyring0:armhf libgphoto2-2:armhf \
libgphoto2-port0:armhf libgs9 libgstreamer-plugins-base0.10-0:armhf libgstreamer0.10-0:armhf libgtk-3-0:armhf libgtk-3-bin libgtk-3-common \
libgtk2.0-0:armhf libgtk2.0-common libgtop2-7 libgudev-1.0-0:armhf libhunspell-1.3-0:armhf libice6:armhf libicu48:armhf libid3tag0 libident \
libijs-0.35 libimlib2 libimobiledevice2 libjasper1:armhf libjavascriptcoregtk-1.0-0 libjavascriptcoregtk-3.0-0 libjbig0:armhf libjbig2dec0 \
libjson0:armhf liblapack3 liblcms1:armhf liblcms2-2:armhf liblightdm-gobject-1-0 libltdl7:armhf liblvm2app2.2:armhf libmad0 libmagic1:armhf \
libmenu-cache1 libmikmod2:armhf libmng1:armhf libmtdev1:armhf libnettle4:armhf libnih-dbus1 libnih1 libnotify4:armhf libobrender27 libobt0 \
libogg0:armhf libopenjpeg2:armhf liborc-0.4-0:armhf libpango1.0-0:armhf libpaper1:armhf libpci3:armhf libpciaccess0:armhf libpixman-1-0:armhf \
libplist1 libpng12-0:armhf libpolkit-agent-1-0:armhf libpolkit-backend-1-0:armhf libpolkit-gobject-1-0:armhf libpoppler19:armhf libportmidi0 \
libproxy0:armhf libpulse0:armhf libpython2.7 libqt4-network:armhf libqt4-svg:armhf libqt4-xml:armhf libqtcore4:armhf libqtdbus4:armhf \
libqtgui4:armhf libqtwebkit4:armhf libraspberrypi0 librsvg2-2:armhf libsamplerate0:armhf libsdl-image1.2:armhf libsdl-mixer1.2:armhf \
libsdl-ttf2.0-0:armhf libsdl1.2debian:armhf libsgutils2-2 libsm6:armhf libsmbclient:armhf libsmpeg0:armhf libsndfile1:armhf libsoup-gnome2.4-1:armhf \
libsoup2.4-1:armhf libsqlite3-0:armhf libstartup-notification0 libsystemd-login0:armhf libthai0:armhf libtiff4:armhf libts-0.0-0:armhf libunique-1.0-0 \
libusbmuxd1 libvorbis0a:armhf libvorbisenc2:armhf libvorbisfile3:armhf libvte9 libwayland0:armhf libwebkitgtk-1.0-0 libwebkitgtk-3.0-0 libwebp2:armhf \
libwnck22 libx11-6:armhf libx11-xcb1:armhf libxapian22 libxau6:armhf libxaw7:armhf libxcb-glx0:armhf libxcb-render0:armhf libxcb-shape0:armhf \
libxcb-shm0:armhf libxcb-util0:armhf libxcb-xfixes0:armhf libxcb1:armhf libxcomposite1:armhf libxcursor1:armhf libxdamage1:armhf libxdmcp6:armhf \
libxext6:armhf libxfixes3:armhf libxfont1 libxft2:armhf libxi6:armhf libxinerama1:armhf libxkbcommon0:armhf libxkbfile1:armhf libxklavier16 \
libxml2:armhf libxmu6:armhf libxmuu1:armhf libxp6:armhf libxpm4:armhf libxrandr2:armhf libxrender1:armhf libxres1:armhf libxslt1.1:armhf \
libxss1:armhf libxt6:armhf libxtst6:armhf libxv1:armhf libxxf86dga1:armhf libxxf86vm1:armhf lightdm lightdm-gtk-greeter lxappearance lxde-common \
lxde-icon-theme lxmenu-data lxpolkit lxrandr lxtask lxterminal menu menu-xdg midori mime-support mountall netsurf-gtk obconf omxplayer openbox \
pciutils pcmanfm plymouth policykit-1 poppler-data python python-support python2.7 python2.7-minimal python3 python3.2 python3.2-minimal scratch \
sgml-base shared-mime-info squeak-vm tasksel tcl8.5 tk8.5 tsconf udisks update-inetd weston wpagui x11-common x11-utils x11-xserver-utils xarchiver \
xfonts-utils xinit xml-core xpdf xserver-xorg xserver-xorg-core idle-python3.2 idle3 ifplugd info leafpad &>/dev/null

echo "Making system configuration changes:"
echo "Modifying sysctl.conf..."
cat > /etc/sysctl.conf <<'_EOF'
kernel.printk = 3 4 1 3
net.ipv4.ip_forward=1
vm.swappiness=1
vm.min_free_kbytes = 8192
_EOF

echo "Writing new torrc file..."
cat > /etc/tor/torrc <<'_EOF'

Log notice file /var/log/tor/notices.log
VirtualAddrNetwork 172.16.0.0/12
AutomapHostsSuffixes .onion,.exit
AutomapHostsOnResolve 1
TransPort 9040
TransListenAddress 192.168.42.1
DNSPort 53
DNSListenAddress 192.168.42.1
_EOF

echo "Writing wpa supplicant file..."
#You can get the below information using wpa_passphrase command on any machine
cat > /etc/wpa_supplicant/wpa_supplicant.conf <<'_EOF'
network={
	ssid="YOUR SSID GOES HERE"
	#psk="Your ASCII Passphrase here"
	psk=The encyrpted form goes here
}
_EOF

echo "Writing new network interfaces file..."
cat > /etc/network/interfaces <<'_EOF'
auto lo
auto eth0

iface lo inet loopback

allow-hotplug wlan0
iface wlan0 inet dhcp
	wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf

iface eth0 inet static
 address 192.168.42.1
 netmask 255.255.255.0
 up iptables-restore < /etc/iptables.ipv4.nat

_EOF

echo "writing new dhcp files..."
cat > /etc/default/isc-dhcp-server <<'_EOF'
INTERFACES="eth0"
_EOF

cat > /etc/dhcp/dhcpd.conf <<'_EOF'
ddns-update-style none;
default-lease-time 600;
max-lease-time 7200;
authoritative;
log-facility local7;

subnet 192.168.42.0 netmask 255.255.255.0 {
range 192.168.42.10 192.168.42.50;
option broadcast-address 192.168.42.255;
option routers 192.168.42.1;
default-lease-time 600;
max-lease-time 7200;
option domain-name "local";
option domain-name-servers 8.8.8.8, 8.8.4.4;
}
_EOF


echo "Making iptables rules, and saving them:"
cat > /etc/iptables.ipv4.nat <<'_EOF'
#iptables-save v1.4.14 on Tue Jan 01 00:00:50 2013
*nat
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
-A PREROUTING -i eth0 -p tcp -m tcp --dport 22 -j REDIRECT --to-ports 22
-A PREROUTING -i eth0 -p udp -m udp --dport 53 -j REDIRECT --to-ports 53
-A PREROUTING -i eth0 -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j REDIRECT --to-ports 9040
-A POSTROUTING -o wlan0 -j MASQUERADE
COMMIT
# Completed on Tue Jan 01 00:00:50 2013
# Generated by iptables-save v1.4.14 on Tue Jan 01 00:00:50 2013
*filter
:INPUT ACCEPT [1:40]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A FORWARD -i wlan0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
-A FORWARD -i eth0 -o wlan0 -j ACCEPT
COMMIT
# Completed on Tue Jan 01 00:00:50 2013


_EOF

echo "Ensuring all required files are present and with proper permissions..."
touch /var/log/tor/notices.log
chown debian-tor /var/log/tor/notices.log
chmod 644 /var/log/tor/notices.log

echo "Ensuring services start..."
update-rc.d isc-dhcp-server enable
update-rc.d tor enable

read -p "Hit [ENTER] to reboot your Pi, or CTRL-C to cancel reboot."
reboot
