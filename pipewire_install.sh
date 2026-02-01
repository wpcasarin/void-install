#!/bin/bash


xbps-install -S pipewire alsa-pipewire libjack-pipewire || exit


echo "Configuring Pipewire..."
mkdir -p /etc/pipewire/pipewire.conf.d

echo "Enabling wireplumber..."
ln -sf /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/

echo "Enabling PulseAudio interface..."
ln -sf /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/

echo "Enabling ALSA integration"
mkdir -p /etc/alsa/conf.d
ln -sf /usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d
ln -sf /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d

echo "Enabling JACK interface"
mkdir /etc/ld.so.conf.d
echo "/usr/lib/pipewire-0.3/jack" > /etc/ld.so.conf.d/pipewire-jack.conf

echo "DONE!"
