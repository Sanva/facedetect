Simply Face Detection Program using OpenCV
==========================================

This is a tiny program that uses OpenCV to detect people faces in a photo and outputs its
geometries in a way that is easy to parse from other programs.

Note that this program has been created from some sample program which at this time is included in the official OpenCV source code releases —you can find it in /samples/c/facedetect.cpp.

.. contents:: Table of Contents

------------
Main Program
------------

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

------------
Test Program
------------

In /test/ folder there is a simple test suite to perform face detection on a set of files.

First you need to create a folder named /test/sources/ with the photos you want to process.

Then you can use facedetect-test to perform face detection —the program will create /test/detected_faces/ folder, wich will have one or more folders inside it with photos that will have detected faces marked with rectangles.

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