MYDIR=$PWD
[ -e 2.12/data/list-pkg.txt ] && rm 2.12/data/list-pkg.txt
cd $HOME/2.12/ydfs/packages-x86_64/
for PKG in `ls`
do
  test -d $PKG || continue
  echo $PKG
  cd $PKG
  find | while read file
  do
    echo "$PKG:$file" >> $MYDIR/2.12/data/list-pkg.txt
  done
  cd .. 
  # sleep 1
done
