
#!/bin/bash

# Function to start VM
start_vm() {
    qemu-system-x86_64 -enable-kvm -vga virtio -m $1 -smp $2 -cpu host -drive file=vm_disk.img,format=qcow2 \
        -device intel-hda  \
        -chardev qemu-vdagent,id=ch1,name=vdagent,clipboard=on \
        -device virtio-serial-pci \
        -device virtserialport,chardev=ch1,id=ch1,name=com.redhat.spice.0 \
        -net nic -net user,hostfwd=tcp::2222-:22 \
        & VM_PID=$!
    wait $VM_PID
}

if [ -e vm_disk.img ]; then
    if [ ! -s vm_disk.img ]; then
        echo "Disk image exists but is empty. Exiting..."
        exit 1
    fi
    echo "Disk image found. Starting VM..."
    RAM=${1:-4G} 
    CPU=${2:-4}
    start_vm $RAM $CPU
else
    echo "Disk image not found. Exiting..."
    exit 1
fi
