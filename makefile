all: facedetect facerec-train facerec

facedetect: facedetect.cpp
	g++ -Wall ./facedetect.cpp -lopencv_core -lopencv_objdetect -lopencv_highgui -lopencv_imgproc -o ./facedetect

facerec-train: facerec-train.cpp
	g++ -Wall ./facerec-train.cpp `pkg-config --cflags --libs giomm-2.4` -lopencv_core -lopencv_highgui -lopencv_contrib -lopencv_imgproc -o ./facerec-train

facerec: facerec.cpp
	g++ -Wall ./facerec.cpp -lopencv_core -lopencv_highgui -lopencv_contrib -lopencv_imgproc -o ./facerec
