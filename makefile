all: facedetect facerec-train facerec

facedetect: facedetect.cpp
	gcc -Wall ./facedetect.cpp -lopencv_core -lopencv_objdetect -lopencv_highgui -lopencv_imgproc -o ./facedetect

facerec-train: facerec-train.cpp
	gcc -Wall ./facerec-train.cpp `pkg-config --cflags --libs giomm-2.4` -lopencv_core -lopencv_highgui -lopencv_contrib -o ./facerec-train

facerec: facerec.cpp
	gcc -Wall ./facerec.cpp -lopencv_core -lopencv_highgui -lopencv_contrib -o ./facerec
