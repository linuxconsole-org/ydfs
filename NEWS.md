# YDFS - What is new in 2.12 relase

## Kernel config based on Arch linux

> To improve hardware compatilibity

## Kernel module on initramfs

> Previously all kernel modules needed for booting were building in the Kernel
> This will make possible to change initramfs without rebuilding the Kernel

## Pivot-root / Flatpak

> On early booting, pivot root is enabled on tmpfs. This makes possible using Flatpak
> It is possible to enable a loopback file on the USB Key to store Flatpak data

## Auto connect wireless

> By writing a /ydfs/wireless.cfg file on the USB key, Wireless network will be up at statup

Reduce size for firmares modules 

## WSL Build

I works ! (Make fast-iso)

![wslbuild](/img/ydfs-2.12-WSL.png)
