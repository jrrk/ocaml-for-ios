#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"

class testApp : public ofxiPhoneApp {
	
public:
	void setup();
	void update();
	void draw();
	void wakethread();
	void exit();
	int load_of_font(const char *);
	
	void touchDown(ofTouchEventArgs &touch);
	void touchMoved(ofTouchEventArgs &touch);
	void touchUp(ofTouchEventArgs &touch);
	void touchDoubleTap(ofTouchEventArgs &touch);
	
	void lostFocus();
	void gotFocus();
	void gotMemoryWarning();
	void deviceOrientationChanged(int newOrientation);

	ofTrueTypeFont  franklinBook;
	ofTrueTypeFont	verdana;

	struct fontcache {
		ofTrueTypeFont myfont;
		const char *name;
	} myfonts[20];
		
//	std::string text1, text2, text3;
};

