#ifndef _OF_BASE_APP
#define _OF_BASE_APP

#include "ofTypes.h"

class ofBaseApp{

	public:
        ofBaseApp() {
            mouseX = mouseY = 0;
        }

		virtual ~ofBaseApp(){}

		virtual void setup(){}
		virtual void update(){}
		virtual void draw(){}
		virtual void wakethread() {};
		virtual int load_of_font(const char *) {return 0;};
		virtual void mysetpixel(unsigned x, unsigned y, char colour) {};
		virtual void framebitmap(char *str, int wid, int hgt) {};
		virtual void exit(){}


		virtual void windowResized(int w, int h){}

		virtual void keyPressed( int key ){}
		virtual void keyReleased( int key ){}

		virtual void mouseMoved( int x, int y ){}
		virtual void mouseDragged( int x, int y, int button ){}
		virtual void mousePressed( int x, int y, int button ){}
		virtual void mouseReleased(){}
		virtual void mouseReleased(int x, int y, int button ){}

		virtual void audioReceived( float * input, int bufferSize, int nChannels ){}
		virtual void audioRequested( float * output, int bufferSize, int nChannels ){}


		int mouseX, mouseY;			// for processing heads
};

#endif


