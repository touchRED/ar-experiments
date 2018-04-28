#include "ofApp.h"



void logSIMD(const simd::float4x4 &matrix)
{
    std::stringstream output;
    int columnCount = sizeof(matrix.columns) / sizeof(matrix.columns[0]);
    for (int column = 0; column < columnCount; column++) {
        int rowCount = sizeof(matrix.columns[column]) / sizeof(matrix.columns[column][0]);
        for (int row = 0; row < rowCount; row++) {
            output << std::setfill(' ') << std::setw(9) << matrix.columns[column][row];
            output << ' ';
        }
        output << std::endl;
    }
    output << std::endl;
}

//--------------------------------------------------------------
ofApp :: ofApp (ARSession * session){
    this->session = session;
    
    cout << "creating ofApp" << endl;
}

ofApp::ofApp(){}

//--------------------------------------------------------------
ofApp :: ~ofApp () {
    cout << "destroying ofApp" << endl;
}

//--------------------------------------------------------------
void ofApp::setup() {
    
    ofBackground(127);
    
    int fontSize = 8;
    if (ofxiOSGetOFWindow()->isRetinaSupportedOnDevice())
        fontSize *= 2;
    
    font.load("fonts/mono0755.ttf", fontSize);
    
    processor = ARProcessor::create(session);
    processor->setup();
    
}



//--------------------------------------------------------------
void ofApp::update(){
    
    processor->update();
    
}

//--------------------------------------------------------------
void ofApp::draw() {
    ofEnableAlphaBlending();
    
    ofDisableDepthTest();
    processor->draw();
    ofEnableDepthTest();
    
    
    if (session.currentFrame){
        if (session.currentFrame.camera){
           
            camera.begin();
            processor->setARCameraMatrices();
            
            for (int i = 0; i < session.currentFrame.anchors.count; i++){
                ARAnchor * anchor = session.currentFrame.anchors[i];
                
                ofPushMatrix();
                ofMatrix4x4 mat = ARCommon::convert<matrix_float4x4, ofMatrix4x4>(anchor.transform);
                ofMultMatrix(mat);
                
                ofSetColor(255);
                ofNoFill();
                ofSetLineWidth(10);
                ofRotate(90,0,0,1);
                
                knots[i]->update();
                
//                ofBeginShape();
                for(unsigned j = 0; j < knots[i]->vertices.size(); j++){
                    ofPoint p = knots[i]->vertices[j];
                    ofSetColor(floor(ofMap(j, 0, knots[i]->vertices.size(), 100, 255)));
                    if(j > 0){
                        ofDrawLine(knots[i]->vertices[j-1], p);
                    }
//                    ofVertex(p);
                }
//                ofEndShape();
                ofPopMatrix();
            }
            camera.end();
        }
        
    }
    
    ofDisableDepthTest();
    // ========== DEBUG STUFF ============= //
//    processor->debugInfo.drawDebugInformation(font);
    ARTrackingStateReason s = session.currentFrame.camera.trackingStateReason;
    switch(s){
        case ARTrackingStateReasonNone:
            //Great
            ofSetColor(255);
            ofFill();
            ofDrawEllipse(15, 15, 20, 20);
            break;
            
        case ARTrackingStateReasonInitializing:
            //Init
            ofSetColor(0);
            ofFill();
            ofDrawEllipse(15, 15, 20, 20);
            break;
            
        case ARTrackingStateReasonExcessiveMotion:
            //Stop moving!
            ofSetColor(100);
            ofFill();
            ofDrawEllipse(15, 15, 20, 20);
            break;
            
        case ARTrackingStateReasonInsufficientFeatures:
            //Bad
            ofSetColor(191, 64, 68);
            ofFill();
            ofDrawEllipse(15, 15, 20, 20);
            break;
            
        case ARTrackingStateReasonRelocalizing:
            //Wait
            ofSetColor(113, 186, 208);
            ofFill();
            ofDrawEllipse(15, 15, 20, 20);
            break;
    }
}

//--------------------------------------------------------------
void ofApp::exit() {
    //
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs &touch){
    if (session.currentFrame){
        ARFrame *currentFrame = [session currentFrame];
        
        matrix_float4x4 translation = matrix_identity_float4x4;
        translation.columns[3].z = -0.2;
        matrix_float4x4 transform = matrix_multiply(currentFrame.camera.transform, translation);
        
        // Add a new anchor to the session
        ARAnchor *anchor = [[ARAnchor alloc] initWithTransform:transform];
        
        [session addAnchor:anchor];
        
        Knot *k;
        
        switch(knots.size() % 7){
            case 0:
                //trefoil
                k = new Trefoil();
                break;
            case 1:
                //figure 8
                k = new FigureEight();
                break;
            case 2:
                //granny
                k = new Granny();
                break;
            case 3:
                //first torus(3,4)
                k = new Torus(3, 4);
                break;
            case 4:
                //second (4,7)
                k = new Torus(4, 7);
                break;
            case 5:
                //third (6, 11)
                k = new Torus(6, 11);
                break;
            default:
                k = new Knot();
                break;
        }
        knots.push_back(k);
    }
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs &touch){
    
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs &touch){
    
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs &touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){
    
}

//--------------------------------------------------------------
void ofApp::gotFocus(){
    
}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){
    processor->updateDeviceInterfaceOrientation();
    processor->deviceOrientationChanged();
    
}


//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs& args){
    
}


