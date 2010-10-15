/*
 *  ofIphoneKeyboard.h
 *  iPhone UIKeyboard Example
 *
 *  Created by Zach Gage on 3/1/09.
 *  Copyright 2009 stfj. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "ofMain.h"
#import "ofxiPhoneExtras.h"
#pragma once

@interface ofxiPhoneKeyboardDelegate : NSObject <UITextFieldDelegate>
{
	UITextField*			_textField;
	bool					open;
	char *					_ctext;
	int						head, tail;
	char 					ringbuf[256];
}
- (id) init: (int)x y:(int)y width:(int)w height:(int)h;
- (void) showText;
- (void) hideText;
- (char *) getText;
- (void) setText: (NSString *)text;
- (void) setFontSize: (int)size;
- (void) setFontColorRed: (int)r green: (int)g blue:(int)b alpha:(int)a;
- (void) setBgColorRed: (int)r green: (int)g blue:(int)b alpha:(int)a;
- (bool) isKeyboardShowing;
- (void) setFrame: (CGRect) rect;
- (void) setPlaceholder: (NSString *)text;
- (void) openKeyboard;
- (void) addtobuf: (char) ch;
- (char) removefrombuf;
- (void) setTransform: (int) r;
@end

class ofxiPhoneKeyboard 
	{
		
	public:
		
		ofxiPhoneKeyboard(int _x, int _y, int _w, int _h);
		~ofxiPhoneKeyboard();
		
		void setVisible(bool visible);
		
		void setPosition(int _x, int _y);
		void setSize(int _w, int _h);
		void setFontSize(int ptSize);
		void setFontColor(int r, int g, int b, int a);
		void setBgColor(int r, int g, int b, int a);
		void setText(string _text);
		void setPlaceholder(string _text);
		void openKeyboard();
		string getText();
		char getRText();
		bool isKeyboardShowing();
		void addtobuf(char);
		void setTransform(int);
		
	protected:
		
		ofxiPhoneKeyboardDelegate *	keyboard;
		int x,y,w,h;
	};
