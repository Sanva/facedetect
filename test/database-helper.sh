
# enable for loops over items with spaces in their name —thanks to 
# http://heath.hrsoftworks.net/archives/000198.html
IFS=$'\n'

for image in `ls "$1"`; do
	echo "$1/$image"
	gpicview "$1/$image" &
	sleep 1
	name=`zenity --entry --text="Name:"`
	kill $!
	mv -i "$1/$image" "$1/${name}_$image"
	convert "$1/${name}_$image" -resize 100x100! "$1/${name}_$image"
done