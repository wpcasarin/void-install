#!/bin/sh

REPO=https://repo-default.voidlinux.org/current/musl
ARCH=x86_64-musl
HOST=void
USER=void

# Core System Utilities
CORE_UTILS="
util-linux      # Set of system utilities for Linux
coreutils       # GNU core utilities
findutils       # GNU find Utilities
diffutils       # GNU diff utilities
grep            # GNU grep utility
gzip            # GNU compression utility
sed             # GNU stream editor
gawk            # GNU awk utility
tar             # GNU implementation of the tar archiver
bash            # GNU Bourne Again Shell
unzip           # List, test and extract compressed files
xz              # XZ compression utilities
less            # A terminal based program for viewing text files
which           # A utility to show the full path of commands
file            # File type identification utility
ncurses         # Curses emulation library
"

# Authentication and Security
AUTH_SECURITY="
pam             # Pluggable Authentication Modules
pam_rundir      # PAM Module to create and remove user runtime directories
shadow          # Password and account management tool suite
opendoas        # Execute commands as another user
ca-certificates # Common CA certificates for SSL/TLS
"

# System Information and Monitoring
SYS_INFO="
procps-ng       # Utilities for monitoring your system
iana-etc        # IANA protocol and port number assignments
tzdata          # Time zone and daylight-saving time data
man-db          # Man pages utility
"

# Network Tools
NETWORK="
dhcpcd          # DHCP client
openssh         # SSH client and server
curl            # Command line tool for transferring files
wget            # Network utility to retrieve files
"

# Development Tools
DEV_TOOLS="
git             # Distributed version control system
helix           # Post-modern modal text editor
"

# Boot, Init, and System Management
BOOT_INIT="
eudev           # Enhanced userland device daemon
e2fsprogs       # Ext2/3/4 Filesystem Utilities
efibootmgr      # UEFI Firmware Boot Manager tool
runit           # UNIX init scheme with service supervision
runit-void      # Void Linux runit scripts
base-files      # Void Linux base system files
xbps            # XBPS package system utilities
booster         # Fast and secure initramfs generator
kmod            # Linux kernel module handling
musl            # Musl C library
dbus            # Interprocess messaging system
acpid           # ACPI event delivery daemon
seatd           # Minimal seat management daemon
"

# Kernel and Firmware
KERNEL="
linux6.18           # Linux kernel 6.18
linux-firmware-amd  # AMD CPU/GPU firmware
"

# Graphics and Display
GRAPHICS="
mesa             # OpenGL and Vulkan implementation
mesa-dri         # Mesa DRI drivers
mesa-vaapi       # Mesa VA-API drivers
mesa-vdpau       # Mesa VDPAU drivers
amdvlk           # AMD Vulkan driver
fontconfig       # Font configuration library
dejavu-fonts-ttf # DejaVu TrueType fonts
"

# Wayland Compositor and Desktop
WAYLAND="
niri            # Wayland compositor
foot            # Wayland terminal emulator
fuzzel          # Application launcher
"

# Xorg Server
XORG="
xorg-server             # X11 server from X.org
xinit                   # X init program
xauth                   # X authentication utility
xf86-input-libinput     # Generic input driver for the X.Org server based on libinput
xf86-video-amdgpu       # Xorg AMD Radeon RXXX video driver (amdgpu kernel module) 
"

ALL_PACKAGES="$CORE_UTILS $AUTH_SECURITY $SYS_INFO $NETWORK $DEV_TOOLS $BOOT_INIT $KERNEL $GRAPHICS"

echo "Installing packages"
XBPS_ARCH=$ARCH xbps-install -S -r /mnt/void -R "$REPO" $(echo "$ALL_PACKAGES" | sed 's/#.*//; /^$/d')

xgenfstab -U /mnt/void > /mnt/void/etc/fstab

chmod +x $(pwd)/post_install.sh
cp $(pwd)/post_install.sh /mnt/void/tmp

xchroot /mnt/void /tmp/post_install.sh
