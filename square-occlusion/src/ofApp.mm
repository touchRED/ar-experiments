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
    
    img.load("OpenFrameworks.png");
    
    int fontSize = 8;
    if (ofxiOSGetOFWindow()->isRetinaSupportedOnDevice())
        fontSize *= 2;
    
    font.load("fonts/mono0755.ttf", fontSize);
    
    processor = ARProcessor::create(session);
    processor->setup();
    
    fbo.allocate(ofGetWindowWidth(), ofGetWindowHeight(), GL_RGBA);
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
            
            fbo.begin();
            ofBackground(0, 0, 0);
            camera.begin();
            processor->setARCameraMatrices();
            
            
            for (int i = 0; i < session.currentFrame.anchors.count; i++){
                ARAnchor * anchor = session.currentFrame.anchors[i];
                                
                // note - if you need to differentiate between different types of anchors, there is a 
                // "isKindOfClass" method in objective-c that could be used. For example, if you wanted to 
                // check for a Plane anchor, you could put this in an if statement.
                // if([anchor isKindOfClass:[ARPlaneAnchor class]]) { // do something if we find a plane anchor}
                // Not important for this example but something good to remember.
                
                ofPushMatrix();
                ofMatrix4x4 mat = ARCommon::convert<matrix_float4x4, ofMatrix4x4>(anchor.transform);
                ofMultMatrix(mat);
                ofRotate(90,0,0,1);
                
                ofFill();
                ofSetColor(0);
                float size = 0.07;
                ofDrawRectangle(-1 * size / 2, -1 * size / 2, size, size);

                ofNoFill();
                ofSetColor(255);
                ofDrawRectangle(-1 * size / 2, -1 * size / 2, size, size);
                
//                ofPoint p = mat.getTranslation();
//
//                ofFill();
//                ofSetColor(0);
//                ofDrawRectangle(p.x, p.y, p.z, 100, 100);
//
//                ofNoFill();
//                ofSetColor(255);
//                ofDrawRectangle(p.x, p.y, p.z, 100, 100);
                
                ofPopMatrix();
            }
            camera.end();
            fbo.end();
        }
        
        if(bTouching){
            ARFrame *currentFrame = [session currentFrame];
            
            matrix_float4x4 translation = matrix_identity_float4x4;
            translation.columns[3].z = -0.2;
            matrix_float4x4 transform = matrix_multiply(currentFrame.camera.transform, translation);
            
            // Add a new anchor to the session
            ARAnchor *anchor = [[ARAnchor alloc] initWithTransform:transform];
            
            [session addAnchor:anchor];
        }
    }
    
    ofDisableDepthTest();
    
    ofEnableBlendMode(OF_BLENDMODE_ADD);
    fbo.draw(0,0);
    ofDisableBlendMode();
    
    // ========== DEBUG STUFF ============= //
    processor->debugInfo.drawDebugInformation(font);
}

//--------------------------------------------------------------
void ofApp::exit() {
    //
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs &touch){
//    if (session.currentFrame){
//        ARFrame *currentFrame = [session currentFrame];
//
//        matrix_float4x4 translation = matrix_identity_float4x4;
//        translation.columns[3].z = -0.2;
//        matrix_float4x4 transform = matrix_multiply(currentFrame.camera.transform, translation);
//
//        // Add a new anchor to the session
//        ARAnchor *anchor = [[ARAnchor alloc] initWithTransform:transform];
//
//        [session addAnchor:anchor];
//    }
    
    bTouching = true;
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs &touch){
    
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs &touch){
    bTouching = false;
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


