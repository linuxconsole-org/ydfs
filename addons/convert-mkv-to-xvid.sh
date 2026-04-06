find mkv  -iname "*.mkv" -execdir basename {} .mkv ';' | while read file
do
	[ -e xvid/"$file".avi ] && continue
	echo "$file".mkv
	ls -l "$file".mkv
        ffmpeg -i "mkv/$file.mkv" -c:v libxvid -q:v 5 -q:a 5 xvid/"$file".avi
done
