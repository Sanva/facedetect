# $1 = Faces to recognize folder.
# $2 = Face recognition program.
# $3 = Face recognition model.

# enable for loops over items with spaces in their name —thanks to 
# http://heath.hrsoftworks.net/archives/000198.html
IFS=$'\n'

correct=0
wrong=0

for image in `ls "$1"`; do
	echo "$image"
	
	predicted=`"$2" "$3" "$1/$image"`
	
	gpicview "$1/$image" &
	sleep 1
	
	`zenity --question --text="Predicted label: $predicted" --ok-label="Success" --cancel-label="Error :("`
	fail=$?
	
	if [ $fail -eq 1 ]
	then
		wrong=`expr $wrong + 1`
	else
		correct=`expr $correct + 1`
	fi
	
	kill $!
done

accuracy=`echo "$correct / ($correct + $wrong) * 100" | bc -l`

echo "$accuracy accuracy"