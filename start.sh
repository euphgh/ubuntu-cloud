#!/run/current-system/sw/bin/bash

# 获取脚本所在目录的绝对路径
SCRIPT_DIR=/home/hgh/.local/etc/ubuntu-cloud

DISK_IMG=$SCRIPT_DIR/jammy-server-cloudimg-amd64-disk-kvm.img
SEED_IMG=$SCRIPT_DIR/seed.img
LOG_FILE=$SCRIPT_DIR/outputs.log
QEMU_BIN=/home/hgh/.nix-profile/bin/qemu-system-x86_64

if [ $? -eq 0 ]; then
$QEMU_BIN \
    -cpu host \
    -enable-kvm \
    -smp 64 \
    -m 64G \
    -nographic \
    -device virtio-net-pci,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::20143-:22 \
    -drive if=virtio,format=qcow2,file=$DISK_IMG\
    -drive if=virtio,format=raw,file=$SEED_IMG >> $LOG_FILE 2>&1
else
echo not find avaliable tcp port
fi

