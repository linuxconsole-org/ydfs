cd $HOME
URL=https://ftp.cc.uoc.gr/mirrors/tdf/libreoffice/stable/24.2.7/deb/x86_64/LibreOffice_24.2.7_Linux_x86-64_deb.tar.gz
[ ! -e libreoffice ] && install -d libreoffice && cd libreoffice && wget $URL && tar xzvf LibreOffice_24.2.7_Linux_x86-64_deb.tar.gz && cd ..
cd libreoffice
if [ ! -e opt ]
then
  for deb in `ls LibreOffice_24.2.7.2_Linux_x86-64_deb/DEBS/`; do dpkg -x LibreOffice_24.2.7.2_Linux_x86-64_deb/DEBS/$deb .; done
  rm -fR LibreOffice_24.2.7.2_Linux_x86-64_deb
  rm *.gz
fi
./opt/libreoffice24.2/program/soffice
