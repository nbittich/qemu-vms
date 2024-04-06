#!/bin/bash
set -xe

MEMORY=4G
CPU=4
UBUNTU_ISO_URL="https://releases.ubuntu.com/22.04/ubuntu-22.04.4-desktop-amd64.iso"

qemu-img create -f qcow2 vm_disk.img 20G

if [ ! -e ubuntu.iso ]; then
    wget -O ubuntu.iso $UBUNTU_ISO_URL
fi

# Start the virtual machine installation

qemu-system-x86_64 -m $MEMORY -smp $CPU -enable-kvm -cpu host -drive file=vm_disk.img,format=qcow2 -cdrom ubuntu.iso

QEMU_PID=$!

wait $QEMU_PID

# Eject the CD-ROM using QEMU monitor command
qemu-system-x86_64 -drive eject=cdrom

# Remove the downloaded ISO file
rm ubuntu.iso
