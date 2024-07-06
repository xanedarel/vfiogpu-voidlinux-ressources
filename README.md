# vfiogpu-voidlinux-ressources
Scripts and tools to drive  voidlinux system with Qemu/KVM GPU passthrough
Installing and setting up qemu/kvm, libvirt, and virt-manager can be done through ./gettingstarted.md

# setting up vfio
copy the `./20-vfio.conf` file into `/etc/dracut.conf.d/20-vfio.conf`
or edit the file with 
```
force_drivers+=" vfio_pci vfio vfio_iommu_type1 "
```
regenerate the initramfs using dracut:
```
# dracut -f
```
or run 
```
# xbps-reconfigure linux<x.x>
```
(replace <x.x> with version number ie : 6.6)

# create a custom 40_custom grub entry file
