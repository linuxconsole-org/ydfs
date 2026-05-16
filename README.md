# About Your Distro From Scratch 2026

This branch is designed to build LinuxConsole 2026 ISO, modules and packages
![logo](/2.12/logos/linuxconsole.png)

# Using Docker is highly recommended, building whithout official docker image will need your hacks

# Fast build (makes Iso)
```
make fast-iso
```

# Building All (makes Iso)

```
make 
```
> Wait some long hours !

# Build manualy if last failed

```
make buildme
```

> Try building manualy, report issue on https://github.com/linuxconsole-org/ydfs/issues


# Building - Step by step

> Activate local folder rights to be used with docker containers
```
make prepare
```

> Build Docker image

```
make docker
```

> Build iso
```
make iso
```

> Verbose build iso
```
make verbose-iso
```

# Tips
[tips](/TIPS.md)

# News - 1.12

## Kernel config based on Arch linux

> To improve hardware compatilibity

## Kernel module on initramfs

> Previously all kernel modules needed for booting were building in the kernel

## Pivot-root / Flatpak

> On early booting, pivot root is enabled on tmpfs. This makes possible using Flatpak

## Auto connect wireless

> By writing a /ydfs/wireless.cfg file on the USB key, Wireless network will be up at statup

Reduce size for firmares modules 

## WSL Build

I works ! (Make fast-iso)

![wslbuild](/img/ydfs-2.12-WSL.png)

# Todo
[todo](/TODO.md)
