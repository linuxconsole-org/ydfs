# Fast building

> Skip packages to build in packages/list-x86_64
```
#SKIP 
....
#STOP
```

# Makefile-Docker customs

> Modify kernel options

```
OPTION_BUILD=MENUCONFIG=YES
```

> Verbose build
```
OPTION_BUILD=DIBAB_VERBOSE_BUILD=YES
```

> Manualy build

```
OPTION_BUILD=BUILDME=OK
```

# Get latest arch release for a package

```
bash 2.12/scripts/echo-archpkg pipewire
```

