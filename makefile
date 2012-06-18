
facedetect: facedetect.cpp
	gcc -Wall ./facedetect.cpp -lopencv_core -lopencv_objdetect -lopencv_highgui -lopencv_imgproc -o ./facedetect