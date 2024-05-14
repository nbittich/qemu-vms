#!/bin/bash
set -xe

MEMORY=6G
CPU=4

qemu-img create -f qcow2 vm_disk.img 20G


# Start the virtual machine installation

qemu-system-x86_64 -m $MEMORY -smp $CPU -enable-kvm -cpu host -drive file=vm_disk.img,format=qcow2 -cdrom win10.iso

QEMU_PID=$!

wait $QEMU_PID

# Eject the CD-ROM using QEMU monitor command
qemu-system-x86_64 -drive eject=cdrom

# Remove the downloaded ISO file
#rm ubuntu.iso
