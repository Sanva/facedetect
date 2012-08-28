Simple Face Detection & Recognition Test Suite using OpenCV
===========================================================

.. contents:: Table of Contents

----------
facedetect
----------

This is a tiny program that uses OpenCV to detect people faces in a photo and outputs its
geometries in a way that is easy to parse from other programs.

Note that this program has been created from some sample program which at this time is included in the official OpenCV source code releases —you can find it in /samples/c/facedetect.cpp.

Usage
-----

.. parsed-literal::
	
	./facedetect --cascade="<cascade_path>" --scale="<image scale greater or equal to 1, try 1.3 for example>" filename

Where

- <cascade_path> is the path to some OpenCV cascade XML file the program will use to achieve face detection.
- <image scale greater or equal to 1, try 1.3 for example> is the scale parameter to use.
- filename is the path to the file to process.
	
Printed Values
--------------

The program will print to the standar output one line per face detected, which will be of the form

.. parsed-literal::

	face;x=#&y=#&width=#&height=#

where the «#» are decimal numbers which are points expressed as percentual values.

If there is some warning the program wants to warn about, there could be some line of the form

.. parsed-literal::

	warning;#

where the «#» is a message that wont have line breaks.

If the is a critical error the program will output a single line of the form

.. parsed-literal::

	error;#

where the «#» is a message —that could contain line breaks.

Examples
~~~~~~~~

Command:

.. parsed-literal::

	./facedetect --cascade=./haarcascade_frontalface_alt2.xml --scale=1.4 '/home/valentin/Escritorio/Vala/OpenCV/faceTest.jpg'

Output:

.. parsed-literal::

	face;x=0.488616&y=0.220472&width=0.070053&height=0.104987
	face;x=0.598949&y=0.238845&width=0.073555&height=0.110236
	face;x=0.101576&y=0.249344&width=0.075306&height=0.112861
	face;x=0.315236&y=0.265092&width=0.068301&height=0.102362
	face;x=0.387040&y=0.278215&width=0.068301&height=0.102362
	face;x=0.194396&y=0.417323&width=0.084063&height=0.125984
	face;x=0.450088&y=0.477690&width=0.091068&height=0.136483
	face;x=0.781086&y=0.230971&width=0.078809&height=0.118110
	face;x=0.639229&y=0.401575&width=0.082312&height=0.123360
	face;x=0.322242&y=0.440945&width=0.103327&height=0.154856

Command:

.. parsed-literal::

	./facedetect --cascade=./haarcascade_frontalface_alt2.xml --scale=1.4 '/home/valentin/Escritorio/Vala/OpenCV/faceTest.jpg' --hola

Output:

.. parsed-literal::

	warning;Unknown option --hola
	face;x=0.488616&y=0.220472&width=0.070053&height=0.104987
	face;x=0.598949&y=0.238845&width=0.073555&height=0.110236
	face;x=0.101576&y=0.249344&width=0.075306&height=0.112861
	face;x=0.315236&y=0.265092&width=0.068301&height=0.102362
	face;x=0.387040&y=0.278215&width=0.068301&height=0.102362
	face;x=0.194396&y=0.417323&width=0.084063&height=0.125984
	face;x=0.450088&y=0.477690&width=0.091068&height=0.136483
	face;x=0.781086&y=0.230971&width=0.078809&height=0.118110
	face;x=0.639229&y=0.401575&width=0.082312&height=0.123360
	face;x=0.322242&y=0.440945&width=0.103327&height=0.154856

Command:

.. parsed-literal::
	
	./facedetect

Output:

.. parsed-literal::

	error;You must specify the cascade.
	Usage:
	./facedetect --cascade=<cascade_path> --scale=<image scale greater or equal to 1, try 1.3 for example> filename
	
	Example:
	./facedetect --cascade="./data/haarcascades/haarcascade_frontalface_alt.xml" --scale=1.3 ./photo.jpg
	
	Using OpenCV version 2.4.0

Dependencies
------------

You need OpenCV installed to compile —and run— this program. The installation of OpenCV may vary depending of your system. Please refer to http://opencv.willowgarage.com/ to get more info.

---------------------
/test/facedetect-test
---------------------

In /test/ folder there is a simple test suite to perform face detection on a set of files.

First you need to create a folder named /test/sources/ with the photos you want to process.

Then you can use facedetect-test to perform face detection —the program will create /test/detected_faces/ folder, wich will have one or more folders inside it with photos that will have detected faces marked with rectangles.

For example, calling the program this way

.. parsed-literal::
	
	./facedetect-test --cascade="../haarcascade_frontalface_alt.xml" --cascade="../haarcascade_frontalface_alt2.xml" --scale=1 --scale=1.2

it will perform 4 face detection tests, and you will have the results in detected_faces folder, like this:

.. parsed-literal::
	
	detected_faces/
	\|-- haarcascade_frontalface_alt.xml
	\|   \`-- 1
	\|       \|-- photo with detected faces.png
	\|       \|-- ...
	\|       \`-- ...
	\|   \`-- 1.2
	\|       \|-- photo with detected faces.png
	\|       \|-- ...
	\|       \`-- ...
	\|-- haarcascade_frontalface_alt2.xml
	\|   \`-- 1
	\|       \|-- photo with detected faces.png
	\|       \|-- ...
	\|       \`-- ...
	\|   \`-- 1.2
	\|       \|-- photo with detected faces.png
	\|       \|-- ...
	\|       \`-- ...

This test program can also export detected faces as PNG images to later use as training faces-database for face recognition training stage —you will see a new folder called faces if you use the --export-faces option.

Usage
-----

.. parsed-literal::

	facedetect-test [OPTION...] 

	Help Options:
	  -h, --help                       Show help options

	Application Options:
	  -c, --cascade=<cascade_path>     Cascade file to use. Specify it more than one time to perform one test per cascade file.
	  -s, --scale=<image scale>        Scale to use. Specify it more than one time to perform one test per scale per cascade file.
	  -e, --export-faces               If used, the program will export detected faces as image files.

-------------
facerec-train
-------------

With facerec-train you can easily train a face recognition model.

I think that the easiest way to explain how to use the program is with an example, so here you have the steps to perform face recognition:

#) Create a folder where you are going to create your face-samples database. For example /test/source_faces_with_name/.

#) Put your face images in that folder. There should be image files with only the face of the person in it —you can use the files created by facedetect in /detected_faces/{cascade_file_name}/{scale_value}/faces/ if you use the --export-faces option. Each face file must have its name following this simple pattern: NAME_SOMETHING.EXT, where NAME is the name of the person, SOMETHING is some text to allow more than one person in the same folder, and EXT is the extension on the file —e.g. "png". So, two PNG files with my face on it could be named Valentín_0.png and Valentín_1.png. Please read the section about database-helper.sh if you want some scripting help to do this boring task.

#) Resize all those face-files —if you used database-helper.sh they are already resized—, they must have exactly the same size. You have an example script to do this at /test/resize.sh —it processes PNG files, and you must have imagemagick installed to use it.
   
   .. code:: bash
		
		for file in *.png; do convert "$file" -resize 100x100! "$file"; done

#) Now you can call facerec-train <model.ext> <faces-folder>, in this example it could be something like
   
   .. parsed-literal::
	
		./facerec-train ./testModel.xml ./test/source_faces_with_name/
	
   , and the program will output all people it will use to train the model, with the label asigned to each person.

So, following this example you will end with a file named testModel.xml, which is the trained model's data.

-------
facerec
-------

Now, perform face recognition is pretty simple:

#) First you need a face-sample —don't use one from your face-samples database, the program always guess who is the person in it. The image must have the same size of the face-sample images.

#) Call facerec <model.ext> <face.ext>, in this example it could be something like
   
   .. parsed-literal::
		
		./facerec ./testModel.xml /home/valentin/Escritorio/some_face.png

   , and the program will simply output the label of the person it thinks that face belongs to.

Since testing face recognition accuracy using this program would be really boring, you
have a helper script that is documented in the facerec-helper.sh section.

I've found that there are good results with people having more than 40 face-samples in the training step.

------------------------
/test/database-helper.sh
------------------------

Please note that to use this script you need to have gpicview, zenity and imagemagick installed.

The process of naming all the face-photos following the NAME_SOMETHING.EXT pattern could be really hard, so I've wrote this simple script to help in such process. The program only accepts one argument: The folder where there are the files to rename. For example, if you are in /test/ folder and have you images in /test/source_faces_with_name/, you can call the program this way

.. parsed-literal::
	
	./database-helper.sh ./source_faces_with_name/

, and it will show you each face-photo and a dialog to put the name of the person. The script will rename and resize it.

-----------------------
/test/facerec-helper.sh
-----------------------

Please note that to use this script you need to have gpicview and zenity installed.

The aim of this program is to help in the process of perform face recognition on a set of face-photos to see how accurate facerec is with a given model. It takes 3 arguments: The folder with the photos, the facerec binary and the model.

First of all, you need a set of face-photos —you can use, por example, the files created by facedetect in /detected_faces/{cascade_file_name}/{scale_value}/faces/ if you use the --export-faces option. Don't use face-photos that were included in the trained model, the program would always guess who are the people on them. These photos must have the same dimensions as those used to train the model —you can use /test/resize.sh to resize them.

Then, you could call facerec-helper.sh, for example this way:

.. parsed-literal::
	
	./facerec-helper.sh ./detected_faces/haarcascade_frontalface_alt.xml/1/faces/ ../facerec ../testModel.xml
	
, and it will show you each photo and a dialog with the predicted label. You should compare it with the people and labels list that facerec-train outputs just before training the model and press the dialog buttons accordingly. At the end of the process the script will output the accuracy, simply based on your answers about each photo.