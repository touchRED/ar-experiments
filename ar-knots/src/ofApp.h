#pragma once

#include "ofxiOS.h"
#include <ARKit/ARKit.h>
#include "ofxARKit.h"

class Knot{
public:
    float beta = 0;
    vector<ofPoint> vertices;
    Knot(){
    }
    virtual void update(){
        if(this->beta > PI + 0.01) {return;}
        
        float r = 0.8 + 1.6 * sin(6 * this->beta);
        r *= 0.1;
        float theta = 2 * this->beta;
        float phi = 0.6 * PI * sin(12 * this->beta);
        
        float x = r * cos(phi) * cos(theta);
        float y = r * cos(phi) * sin(theta);
        float z = r * sin(phi);

        
        this->vertices.push_back(ofPoint(x, y, z));
        
        this->beta += 0.01;
    }
};

class Trefoil : public Knot{
public:
    Trefoil(){
    }
    void update(){
        if(beta > 2 * PI + 0.02) {return;}
        
        float x = 41 * cos(beta) - 18 * sin(beta) - 83 * cos(2*beta) - 83 * sin(2*beta) - 11 * cos(3*beta) + 27 * sin(3*beta);
        x *= 0.001;
        float y = 36 * cos(beta) + 27 * sin(beta) - 113 * cos(2 * beta) + 30 * sin(2 * beta) + 11 * cos(3 * beta) - 27 * sin(3 * beta);
        y *= 0.001;
        float z = 45 * sin(beta) - 30 * cos(2 * beta) + 113 * sin(2 * beta) - 11 * cos(3 * beta) + 27 * sin(3* beta);
        z *= 0.001;
        
        vertices.push_back(ofPoint(x, y, z));
        
        beta += 0.03;
    }
};

class FigureEight : public Knot{
public:
    FigureEight(){
    }
    void update(){
        if(beta > 2 * PI + 0.02) {return;}
        
        float x = 10 * (cos(beta) + cos(3 * beta)) + cos(2 * beta) + cos(4 * beta);
        float y = 6 * sin(beta) + 10 * sin(3 * beta);
        float z = 4 * sin(3 * beta) * sin(5 * beta / 2) + 4 * sin(4 * beta) - 2 * sin(6 * beta);
        
        x *= 0.01;
        y *= 0.01;
        z *= 0.01;
        
        vertices.push_back(ofPoint(x, y, z));
        
        beta += 0.03;
    }
};

class Granny : public Knot{
public:
    Granny(){
    }
    void update(){
        if(beta > 2 * PI + 0.02) {return;}
        
        float x = -22 * cos(beta) - 128 * sin(beta) - 44 * cos(3 * beta) - 78 * sin(3 * beta);
        float y = -10 * cos(2 * beta) - 27 * sin(2 * beta) + 38 * cos(4 * beta) + 46 * sin(4 * beta);
        float z = 70 * cos(3 * beta) - 40 * sin(3 * beta);
        
        x *= 0.001;
        y *= 0.001;
        z *= 0.001;
        
        vertices.push_back(ofPoint(x, y, z));
        
        beta += 0.03;
    }
};

class Torus : public Knot{
public:
    int nlongitude;
    int nmeridian;
    Torus(int nmeridian_ = 3, int nlongitude_ = 4){
        nlongitude = nlongitude_;
        nmeridian = nmeridian_;
    }
    void update(){
        if(beta > 2 * PI * nmeridian + 0.1) {return;}
        
        float x = cos(beta) * (1 + cos(nlongitude*beta/(double)nmeridian) / 2.0);
        float y = sin(beta) * (1 + cos(nlongitude*beta/(double)nmeridian) / 2.0);
        float z = sin(nlongitude*beta/(double)nmeridian) / 2.0;
        
        x *= 0.1;
        y *= 0.1;
        z *= 0.1;
        
        vertices.push_back(ofPoint(x, y, z));
        
        beta += 0.1;
    }
};

class ofApp : public ofxiOSApp {
    
public:
    
    ofApp (ARSession * session);
    ofApp();
    ~ofApp ();
    
    void setup();
    void update();
    void draw();
    void exit();
    
    void touchDown(ofTouchEventArgs &touch);
    void touchMoved(ofTouchEventArgs &touch);
    void touchUp(ofTouchEventArgs &touch);
    void touchDoubleTap(ofTouchEventArgs &touch);
    void touchCancelled(ofTouchEventArgs &touch);
    
    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);
    
    vector < matrix_float4x4 > mats;
    vector<ARAnchor*> anchors;
    ofCamera camera;
    ofTrueTypeFont font;
    
    vector<Knot*> knots;
    
    float beta = 0;

    // ====== AR STUFF ======== //
    ARSession * session;
    ARRef processor;

    
};


