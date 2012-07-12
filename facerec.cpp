/*
 * This program was created from one sample you could find in the OpenCV C++ samples
 * folder, called "facerec_demo.cpp", by Valentín Barros. I retain the original
 * copyright notice:
 * 
 * Copyright (c) 2011. Philipp Wagner <bytefish[at]gmx[dot]de>.
 * Released to public domain under terms of the BSD Simplified license.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *   * Neither the name of the organization nor the names of its contributors
 *     may be used to endorse or promote products derived from this software
 *     without specific prior written permission.
 *
 *   See <http://www.opensource.org/licenses/bsd-license>
 */

#include "opencv2/core/core.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/contrib/contrib.hpp"

#include <iostream>

using namespace cv;
using namespace std;

int main(int argc, const char *argv[]) {
    
    if (argc != 3) {
        
        cout << "usage: " << argv[0] << " <model.ext> <face.ext>" << endl;
        exit(-1);
        
    }
    
    Ptr<FaceRecognizer> model = createFisherFaceRecognizer();
    model->load(argv[1]);
    
    Mat img = imread(argv[2], CV_LOAD_IMAGE_GRAYSCALE);
    equalizeHist(img, img);
    
    cout << model->predict(img) << endl;

    return 0;
    
}
