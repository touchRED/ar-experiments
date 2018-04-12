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
    
//    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
//
////  setup horizontal plane detection
//    configuration.planeDetection = ARPlaneDetectionHorizontal;
//
//    [this->session runWithConfiguration:configuration];
    
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
    
//    img.load("OpenFrameworks.png");
    
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
                
                // note - if you need to differentiate between different types of anchors, there is a 
                // "isKindOfClass" method in objective-c that could be used. For example, if you wanted to 
                // check for a Plane anchor, you could put this in an if statement.
                // if([anchor isKindOfClass:[ARPlaneAnchor class]]) { // do something if we find a plane anchor}
                // Not important for this example but something good to remember.
                
//                ofPushMatrix();
                ofMatrix4x4 mat = ARCommon::convert<matrix_float4x4, ofMatrix4x4>(anchor.transform);
//                ofMultMatrix(mat);
//
                ofSetColor(255);
//                ofRotate(90,0,0,1);
//
//                img.draw(-0.025 / 2, -0.025 / 2,0.025,0.025);
//                ofDrawCircle(0,0,0,0.002);
                
//                for(unsigned j = 1; j < lines[i].size(); j++){
//                    ofSetLineWidth(5);
//
//                    //scale the distance between these two points using vector subtraction
//                    ofDrawLine(lines[i][j-1], lines[i][j]);
//                }
                
//                ofPopMatrix();
              
//                line.addVertex(0, 0, 0);
                ofPoint p = mat.getTranslation();
                
                if(i > 0){
                    ofMatrix4x4 prevMat = ARCommon::convert<matrix_float4x4, ofMatrix4x4>(session.currentFrame.anchors[i-1].transform);
                    ofPoint prevPoint = prevMat.getTranslation();

                    ofSetLineWidth(5);
                    ofDrawLine(prevPoint, p);
                }
                
            }
            camera.end();
        }
        
        if(bTouchDown){
            ARFrame *currentFrame = [session currentFrame];
            
            matrix_float4x4 translation = matrix_identity_float4x4;
            translation.columns[3].z = -0.2;
            matrix_float4x4 transform = matrix_multiply(currentFrame.camera.transform, translation);
            
            // Add a new anchor to the session
            ARAnchor *anchor = [[ARAnchor alloc] initWithTransform:transform];
            
            [session addAnchor:anchor];
        }
        
    }

//    processor->drawPointCloud();
//    processor->drawHorizontalPlanes();
    ofDisableDepthTest();
    // ========== DEBUG STUFF ============= //
//    processor->debugInfo.drawDebugInformation(font);
//    if(lines.size()){
//        for(unsigned j = 1; j < lines[0].size(); j++){
//            ofSetLineWidth(5);
//            ofDrawLine(lines[0][j-1], lines[0][j]);
//        }
//    }
}

//--------------------------------------------------------------
void ofApp::exit() {
    //
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs &touch){
    
    if (session.currentFrame){
        bTouchDown = true;
    }
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs &touch){
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs &touch){
    if(session.currentFrame){
        bTouchDown = false;
    }
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


