# vfiogpu-voidlinux-ressources
Scripts and tools to drive a voidlinux system with Qemu/KVM guest GPU passthrough
Installing and setting up qemu/kvm, libvirt, and virt-manager can be done through ./gettingstarted.md

# setting up vfio pci ids
run iommu.sh to display devices with IOMMU groups and their respective pci.ids.
```
$ bash ./iommu.sh
[...]
IOMMU Group 22 04:00.0 VGA compatible controller [0300]: NVIDIA Corporation GP107 [GeForce GTX 1050 Ti] [10de:1c82] (rev a1)
IOMMU Group 22 04:00.1 Audio device [0403]: NVIDIA Corporation GP107GL High Definition Audio Controller [10de:0fb9] (rev a1)
[...]
```
> All the devices in the IOMMU group of my target GPU need to be bound to the vfio driver during boot.
>
Take note of the pci.ids at the end of the lines of all devices in the target's IOMMU group, ie:
`[10de:1c82]` & `[10de:0fb9]`
# include those devices into the vfio-pci.ids kernel parameter
edit the `GRUB_CMDLINE_LINUX_DEFAULT=` line by adding `vfio-pci.ids=<ID>,<ID2>` for example:
```
GRUB_CMDLINE_LINUX_DEFAULT="vfio-pci.ids=10de:1c82,10de:0fb9 loglevel=4"
```
don't forget to update grub
```
# update-grub
```

# ensuring the vfio driver is loaded early at boot
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

#reboot your device to ensure that the GPU is bound to the VFIO drivers
```
# lspci -k | grep -E -A 2 'NVIDIA'
```
> replace 'NVIDIA' with 'AMD' or your GPU manufacturer.
> 
Expected output :
```
04:00.0 VGA compatible controller: NVIDIA Corporation GP107 [GeForce GTX 1050 Ti] (rev a1)
        Subsystem: PNY Device 11bf
        Kernel driver in use: vfio-pci
--
04:00.1 Audio device: NVIDIA Corporation GP107GL High Definition Audio Controller (rev a1)
        Subsystem: PNY Device 11bf
        Kernel driver in use: vfio-pci
--
```
> note that both devices `04:00.0` and `04:00.1` need to be bound to the VFIO driver, as well as any other device in the same IOMMU group as the target GPU when using iommu.sh
# create a custom 40_custom grub entry file
