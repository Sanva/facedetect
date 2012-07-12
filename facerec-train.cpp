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

#include <giomm.h>

#include "opencv2/core/core.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/contrib/contrib.hpp"

#include <iostream>
#include <set>

using namespace cv;
using namespace std;

const string SOURCE_FACES_PATH = "./test/source_faces_with_name/";

static void import_images(string facesFolder, vector<Mat> &images, vector<int> &labels, map<string, int> &name2LabelMap) {
    
    Gio::init();

    set<string> fileNames;

    try {
        
        Glib::RefPtr<Gio::File> directory = Gio::File::create_for_path(facesFolder);
        if(!directory)
          std::cerr << "Gio::File::create_for_path() returned an empty RefPtr." << std::endl;

        Glib::RefPtr<Gio::FileEnumerator> enumerator = directory->enumerate_children();
        if(!enumerator)
          std::cerr << "Gio::File::enumerate_children() returned an empty RefPtr." << std::endl;
        
        Glib::RefPtr<Gio::FileInfo> file_info;
        while(file_info = enumerator->next_file()) {
            
            fileNames.insert(file_info->get_name());
            
        }
        
        

    } catch (const Glib::Exception& ex) {
        
        std::cerr << "Exception caught: " << ex.what() << std::endl;
        exit(-1);
        
    }
    
    int labelsCount = 0;
    for (set<string>::iterator it = fileNames.begin(); it != fileNames.end(); it++) {
        
        string personName = it->substr(0, it->find('_'));
        
        if (name2LabelMap.count(personName) == 0) {
            
            name2LabelMap[personName] = labelsCount;
            
            cout << labelsCount << '\t' << personName << endl;
            
            labelsCount++;
            
        }
        
        Mat img = imread(facesFolder + *it, CV_LOAD_IMAGE_GRAYSCALE);
        equalizeHist(img, img);
        
        images.push_back(img);
        labels.push_back(name2LabelMap[personName]);
        
    }
    
}

int main(int argc, const char *argv[]) {
    
    if (argc != 3) {
        
        cout << "usage: " << argv[0] << " <model.ext> <faces-folder>" << endl;
        exit(-1);
        
    }
    
    vector<Mat> images;
    vector<int> labels;
    map<string, int> name2LabelMap;
    
    import_images(argv[2], images, labels, name2LabelMap);
    
    Ptr<FaceRecognizer> model = createFisherFaceRecognizer();
    
    cout << "Training... " << endl;
    model->train(images, labels);
    cout << "\tDONE" << endl;
    
    model->save(argv[1]);
    
    return 0;
    
}
