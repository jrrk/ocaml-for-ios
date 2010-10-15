/*
 *  ofxiPhoneKeyboard.cpp
 *  iPhone UIKeyboard Example
 *
 *  Created by Zach Gage on 3/1/09.
 *  Copyright 2009 stfj. All rights reserved.
 *
 */

#import "ofxiPhoneKeyboard.h"

//C++ class implementations

//--------------------------------------------------------------
ofxiPhoneKeyboard::ofxiPhoneKeyboard(int _x, int _y, int _w, int _h)
{
	keyboard = [[ofxiPhoneKeyboardDelegate alloc] 
				init:	_x 
				y:		_y 
				width:	_w 
				height:	_h];
	x=_x;
	y=_y;
	w = _w;
	h = _h;
}

//--------------------------------------------------------------
ofxiPhoneKeyboard::~ofxiPhoneKeyboard()
{
	[keyboard release];
}


//--------------------------------------------------------------
void ofxiPhoneKeyboard::setVisible(bool visible)
{
	if(visible)
	{
		[keyboard showText];
	}
	else
	{
		[keyboard hideText];
	}
	
}

//--------------------------------------------------------------
void ofxiPhoneKeyboard::setPosition(int _x, int _y)
{
	x=_x;
	y=_y;
	[keyboard setFrame: CGRectMake(x,y,w,h)];
}

//--------------------------------------------------------------
void ofxiPhoneKeyboard::setSize(int _w, int _h)
{
	w = _w;
	h = _h;
	[keyboard setFrame: CGRectMake(x,y,w,h)];
}

//--------------------------------------------------------------
void ofxiPhoneKeyboard::setFontSize(int ptSize)
{
	[keyboard setFontSize: ptSize];
}

//--------------------------------------------------------------
void ofxiPhoneKeyboard::setFontColor(int r, int g, int b, int a)
{
	[keyboard setFontColorRed: r 
						green: g 
						 blue: b 
						alpha: a];
}

//--------------------------------------------------------------
void ofxiPhoneKeyboard::setBgColor(int r, int g, int b, int a)
{
	[keyboard setBgColorRed: r 
					  green: g 
					   blue: b 
					  alpha: a];
}

//--------------------------------------------------------------
void ofxiPhoneKeyboard::setText(string _text)
{
	NSString * text = [[[NSString alloc] initWithCString: _text.c_str()] autorelease];
	[keyboard setText:text];
}

//--------------------------------------------------------------
void ofxiPhoneKeyboard::setPlaceholder(string _text)
{
	NSString * text = [[[NSString alloc] initWithCString: _text.c_str()] autorelease];
	[keyboard setPlaceholder:text];
}

//--------------------------------------------------------------
string ofxiPhoneKeyboard::getText()
{
	if([keyboard getText] == nil)
	{
		return "";
	}
	else
	{
		return string([keyboard getText]);
	}
}

//--------------------------------------------------------------
char ofxiPhoneKeyboard::getRText()
{
	return [keyboard removefrombuf];
}

void ofxiPhoneKeyboard::openKeyboard()
{
	[keyboard openKeyboard];
}

bool ofxiPhoneKeyboard::isKeyboardShowing()
{
	return [keyboard isKeyboardShowing];
}

//--------------------------------------------------------------
void ofxiPhoneKeyboard::setTransform(int r)
{
	[keyboard setTransform:(int)r];
}

// CLASS IMPLEMENTATIONS--------------objc------------------------
//----------------------------------------------------------------
@implementation ofxiPhoneKeyboardDelegate

- (void) addtobuf: (char) ch
{
	ringbuf[head] = ch;
	head = (head+1)&255;	
	ofGetAppPtr()->wakethread();
}

- (char) removefrombuf
{
	if (tail != head)
	{
		char tmp = ringbuf[tail];
		tail = (tail+1)&255;
		return tmp;
	}
		else {
			return -1;
		}	
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	ofGetAppPtr()->update();
	textField.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;	// don't capitalize
	open = true;
}

//--------------------------------------------------------------
- (void)textFieldDidEndEditing:(UITextField *)textField             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
{
	delete[] _ctext;
	_ctext = new char[[[textField text] length]+1];
	[[textField text] getCString:_ctext maxLength:[[textField text] length]+1 encoding:NSASCIIStringEncoding];
	ofGetAppPtr()->update();
	open = false;
}

//--------------------------------------------------------------
// Terminates the editing session
- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore.
{
	//Terminate editing
	// [textField resignFirstResponder];
	ringbuf[head] = '\n';
	head = (head+1)&255;	
	ofGetAppPtr()->wakethread();
	[_textField setText:nil];
	return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
{
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
{
	return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
{
	_ctext = new char[[[textField text] length]+1];
	char *rtext = new char[[string length]+1];
	[[textField text] getCString:_ctext maxLength:[[textField text] length]+1 encoding:NSASCIIStringEncoding];
	[string getCString:rtext maxLength:[string length]+1 encoding:NSASCIIStringEncoding];
	ringbuf[head] = rtext[0];
	head = (head+1)&255;	
	ofGetAppPtr()->wakethread();
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField;               // called when clear button pressed. return NO to ignore (no notifications)
{
	return NO;
}

//--------------------------------------------------------------
- (id) init:(int)x y:(int)y width:(int)w height:(int)h
{
	if(self = [super init])
	{			
		_textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, w, h)];

		[self setFrame:CGRectMake(x,y,w,h)];
		
		[_textField setDelegate:self];
		[_textField setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
		[_textField setTextColor:[UIColor whiteColor]];
		[_textField setFont:[UIFont fontWithName:@"Helvetica" size:16]];
		[_textField setPlaceholder:@""];	
	}
	return self;
}

//--------------------------------------------------------------
- (void)dealloc 
{ 
	[_textField release];
	delete[] _ctext;
	
	[super dealloc];
}

//--------------------------------------------------------------
- (char *) getText
{
	return _ctext;
}

//--------------------------------------------------------------
- (void) showText
{
	[ofxiPhoneGetUIWindow() addSubview:_textField];
}

//--------------------------------------------------------------
- (void) hideText
{
	[_textField endEditing:YES];
	[_textField removeFromSuperview];
}

//--------------------------------------------------------------
- (void) setText: (NSString *)text
{
	[_textField setText:text];
}

//--------------------------------------------------------------
- (void) setPlaceholder: (NSString *)text
{
	[_textField setPlaceholder:text];
}

//--------------------------------------------------------------
- (void) setFontSize: (int)size
{
	[_textField setFont:[UIFont fontWithName:@"Helvetica" size:size]];
}

//--------------------------------------------------------------
- (void) setFontColorRed: (int)r green: (int)g blue:(int)b alpha:(int)a
{
	[_textField setTextColor:[UIColor 
							  colorWithRed:	(float)r/255 
							  green:		(float)g/255 
							  blue:			(float)b/255 
							  alpha:		(float)a/255]];
}

//--------------------------------------------------------------
- (void) setBgColorRed: (int)r green: (int)g blue:(int)b alpha:(int)a
{
	[_textField setBackgroundColor:[UIColor 
									colorWithRed:	(float)r/255 
									green:			(float)g/255 
									blue:			(float)b/255 
									alpha:			(float)a/255]];
}

//--------------------------------------------------------------
- (bool) isKeyboardShowing
{
	return open;
}

//--------------------------------------------------------------
- (void) setFrame: (CGRect) rect
{

	CGSize s = [[[UIApplication sharedApplication] keyWindow] bounds].size;		

	switch (ofxiPhoneGetOrientation()) 
	{
		case OFXIPHONE_ORIENTATION_LANDSCAPE_LEFT:
			[_textField setFrame: CGRectMake(rect.origin.y-rect.size.height, s.height-rect.size.width-rect.origin.x, rect.size.height, rect.size.width)];
			break;
			
		case OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT:
			[_textField setFrame: CGRectMake(s.width-rect.origin.y , rect.origin.x, rect.size.height, rect.size.width)];
			break;
			
		default:
			[_textField setFrame: CGRectMake(rect.origin.x , rect.origin.y-rect.size.height, rect.size.width, rect.size.height)];
			break;
	}
}

//--------------------------------------------------------------
- (void) openKeyboard
{
	[_textField becomeFirstResponder];
}

//--------------------------------------------------------------
- (void) setTransform: (int) r
{
	_textField.transform = CGAffineTransformMakeRotation(r * M_PI / 180.0);
}

//--------------------------------------------------------------
@end
