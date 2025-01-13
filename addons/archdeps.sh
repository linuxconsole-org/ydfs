#!/bin/bash
donotbuild=('gtk-update-icon-cache' 'gcc-libs' 'sh' 'libsysprof-capture' 'util-linux-libs' 'systemd-libs' 'glibc')

export DIBAB_PREFIX=$HOME
export SRC_PATH=$PWD

export TMPDIR=$HOME/tmp

loop=0

function get_child_pkg
{
  depends=$@
	# echo "LEVEL : $LEVEL"
  	#echo "DEPS $depends"
  	   # [ ${#depends[@]} = 0 ] && echo "no deps 3" !
  	   ready_to_build $depends
	   if [ $? = 0 ]
	   then
  		echo "DEBUG $HOME_DIBAB/scripts/echo-archpkg $d"
  		PKGURL=`$HOME_DIBAB/scripts/echo-archpkg $d`
		echo
		export PACK=$d
		echo "Ready to build $PKGURL !"
		build_from_url 
	   fi

  	   for pkg in ${depends[@]}
	   do
		   export LEVEL=$loop
	     get_alias $pkg
	     d=$pkg
  	     [ -e $HOME/archpkg/$d ] && continue
	     get_special_pkg $d && continue 
	     # echo "Depends3: $d"; 
	     echo -n " $d"
	     if [ ! -e $HOME/archpkg/$d ]
	     then
  	      ./core/scripts/echo-archpkg $d >/dev/null
	     fi
  	     source $HOME/archpkg/$d
  	     get_child_pkg "${depends[@]}"
     	   done
  	new=`expr 1 + $loop`
  	loop=$new
	echo "LOOP : $loop"
	sleep 1
}

function get_alias
{
	[ "$1" = "libkeyutils.so" ] && pkg="keyutils"
	[ "$1" = "libcom_err.so" ] && pkg="e2fsprogs"
	[ "$1" = "libss.so" ] && pkg="e2fsprogs"
	[ "$1" = "libverto-module-base" ] && pkg="libverto"
	[ "$1" = "libverto.so" ] && pkg="libverto"
	[ "$1" = "libjpeg" ] && pkg="libjpeg-turbo"
	[ "$1" = "libjpeg.so" ] && pkg="libjpeg-turbo"
	[ "$1" = "libattr.so" ] && pkg="attr"
	[ "$1" = "libsysprof-capture" ] && pkg="sysprof"
	[ "$1" = "libidn2.so" ] && pkg="libidn2"
	[ "$1" = "gobject-introspection-runtime" ] && pkg="gobject-introspection"
	[ "$1" = "libreadline.so" ] && pkg="readline"
	[ "$1" = "libcups" ] && pkg="cups"
	[ "$1" = "libcolord" ] && pkg="colord"
	[ "$1" = "libncursesw.so" ] && pkg="ncurses"
	[ "$1" = "libexpat" ] && pkg="expat"
	[ "$1" = "libexpat.so" ] && pkg="expat"
	[ "$1" = "libldap" ] && pkg="openldap"
	[ "$1" = "libfreetype.so" ] && pkg="freetype2"
	[ "$1" = "util-linux-libs" ] && pkg="util-linux"
}

function ready_to_build
{
 depends=$@
#echo "DEPENDS : / $depends /"
for i in $depends
do
    for j in "${donotbuild[@]}"
    do
      notfound=1
      # echo " j -> $j / i-> $i ??"
      [ "$j" = "$i" ] && notfound=0 && break
    done
    [ "$notfound" = "1" ] && return 1
done

 [ "$notfound" = "1" ] && return 1
 return 0
}

function get_special_pkg
{
for i in "${donotbuild[@]}"
do
#    echo "$i / $1 ?"
    if [ "$i" = "$1" ] ; then
	    echo "Skip $1"
        return 0
    fi
done
 # echo "Pkg : $1"
 return 1
}

PKG="qt5-base"
PKG="gtk3"
PKG="gsettings-desktop-schemas"
PKG="$1"
# echo "Deps for $PKG"
source $HOME/archpkg/$PKG

for pkg in ${depends[@]} ${makedepends[@]}
do
	# echo $pkg
  	# ready_to_build $pkg || continue
	[ "$pkg" = "git" ] && continue

	[ -e $HOME/archpkg/$pkg ] && continue
	./core/scripts/echo-archpkg2 $pkg 2>/dev/null >/dev/null || continue
	# echo "$pkg missing"
	echo "archlinux:$pkg"
done


#get_child_pkg "${depends[@]}"
