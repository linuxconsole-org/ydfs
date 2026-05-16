# About Your Distro From Scratch 2026

This branch is designed to build LinuxConsole 2026 ISO, modules and packages
![logo](/2.12/logos/linuxconsole.png)

> Using Docker for the full build is highly recommended, building whithout official docker image will need your hacks

# Fast build (makes Iso)

> With this mode, pre-build files for the core module and kernel are downloaded before building "update module" and build ISO

```
make fast-iso
```

# Building All (makes Iso)

> You will have to wait for hours or days !

```
make 
```

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

# News
[todo](/NEWS.md)

# Todo
[todo](/TODO.md)

