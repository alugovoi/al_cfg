#!/usr/bin/env bash
export LC_ALL=C
vm_name=$1
pool_size=10
# trusty-updates|trusty-updates
ubuntu_release=trusty-updates
current_dir=$(pwd)
echo "Default storage pool is $pool_name, pool-size is $pool_size"
echo "Preseed config $current_dir/preseed.cfg"

qemu-img create -f qcow2 -o preallocation=metadata /home/alugovoi/vms/${vm_name}.qcow2 ${pool_size}G

virt-install \
--connect qemu:///system \
--name $vm_name \
--ram 2048 \
--vcpus 2 \
--disk /home/alugovoi/vms/${vm_name}.qcow2,size=$pool_size,bus=virtio,sparse=false,format=qcow2 \
--network network=default,model=virtio \
--location http://ua.archive.ubuntu.com/dists/trusty-updates/main/installer-amd64/ \
--initrd-inject=$current_dir/preseed.cfg \
--extra-args="file=file:/preseed.cfg vga=788 quiet console=tty0 utf8 console=ttyS0,115200" \
--os-type=linux \
--os-variant=ubuntutrusty \
--virt-type kvm \
--video=vga \
--noreboot \
--cpu host \
--hvm

virsh start $vm_name
echo "Login to console"
virsh console $vm_name
