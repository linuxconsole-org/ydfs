RELEASE=24.2.7
LANGLO="_fr"

set -e

cd $HOME
URL=https://ftp.cc.uoc.gr/mirrors/tdf/libreoffice/stable/"$RELEASE"/deb/x86_64/LibreOffice_"$RELEASE"_Linux_x86-64_deb.tar.gz
[ ! -e libreoffice ] && install -d libreoffice 

cd libreoffice 
wget $URL 
tar xzvf LibreOffice_"$RELEASE"_Linux_x86-64_deb.tar.gz 

if [ ! -e opt ]
then
  for deb in `ls LibreOffice_"$RELEASE".2_Linux_x86-64_deb/DEBS/`; do dpkg -x LibreOffice_"$RELEASE".2_Linux_x86-64_deb/DEBS/$deb .; done
  [ ! -e $HOME/.local/bin/libreoffice24.2 ] && ln -s $HOME/libreoffice/opt/libreoffice24.2/program/soffice $HOME/.local/bin/libreoffice24.2
  cp -fR $HOME/libreoffice/opt/libreoffice24.2/share/* $HOME/.local/share/
fi

if [ "$LANG" == "fr_FR.UTF8" ]
then
  URL=https://download.documentfoundation.org/libreoffice/stable/"$RELEASE"/deb/x86_64/LibreOffice_"$RELEASE"_Linux_x86-64_deb_langpack$LANGLO.tar.gz
  wget $URL
  tar xzvf LibreOffice_"$RELEASE"_Linux_x86-64_deb_langpack$LANGLO.tar.gz
  for deb in `ls LibreOffice_"$RELEASE".2_Linux_x86-64_deb_langpack$LANGLO/DEBS/`; do dpkg -x LibreOffice_"$RELEASE".2_Linux_x86-64_deb_langpack$LANGLO/DEBS/$deb .; done

  URL=https://download.documentfoundation.org/libreoffice/stable/"$RELEASE"/deb/x86_64/LibreOffice_"$RELEASE"_Linux_x86-64_deb_helppack$LANGLO.tar.gz
  wget $URL
  tar xzvf LibreOffice_"$RELEASE"_Linux_x86-64_deb_helppack$LANGLO.tar.gz
  for deb in `ls LibreOffice_"$RELEASE".2_Linux_x86-64_deb_helppack$LANGLO/DEBS/`; do dpkg -x LibreOffice_"$RELEASE".2_Linux_x86-64_deb_helppack$LANGLO/DEBS/$deb .; done
fi

rm -fR LibreOffice_"$RELEASE".2_Linux_x86-64_deb*
rm *.gz

#./opt/libreoffice24.2/program/soffice
