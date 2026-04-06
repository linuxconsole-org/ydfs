# rm /usr/bin/glade
for file in usr/share/desktop-directories/Install.directory usr/share/applications/install-firefox.desktop usr/share/pixmaps/firefox.png \
	usr/share/applications/steam.desktop usr/share/pixmaps/steam.png bin/steam
do
  dirname=$( dirname $file )
  basename=$( basename $file )
  cd /
  install -d $dirname
  # https://bitbucket.org/yourdistrofromscratch/ydfs/raw/master/2.8/
  wget -q http://opkg.linuxconsole.org/linuxconsole/2.10/$file
  mv $basename $dirname
done
