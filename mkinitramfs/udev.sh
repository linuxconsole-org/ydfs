dpkg -L udev |while read file; do test -h $file && link=$(ls -l $file | cut -d'>' -f2) && echo add_symlink $link $file; test -f $file && echo add_file $file; test -d $file && echo add_dir $file; done
