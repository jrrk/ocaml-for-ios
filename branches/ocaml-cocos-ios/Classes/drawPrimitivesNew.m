//
// drawing primitives test
// a cocos2d example
// http://www.cocos2d-iphone.org
//

// cocos import
#import "cocos2d.h"

//enum {width = 81, height = 25};

// local import
#import "drawPrimitivesNew.h"
#include <unistd.h>
#import "glue.h"

#include <assert.h>
#include <pthread.h>
#include <fcntl.h>
#include <dirent.h>


static int sceneIdx=-1;
static NSString *transitions[] = {
	@"Test1",
	@"Test2",
};

typedef struct graphbuf {
	int x, y, siz;
	char *buf, *fnt;
} graphbuf_t;

enum {graph_siz=256};
static char stdoutbuf[height][width];
static graphbuf_t graphbuf[graph_siz];
static int row, col;
static int graph_head = 0, graph_tail = 0;
static pthread_mutex_t mut = PTHREAD_MUTEX_INITIALIZER;
static pthread_cond_t cond = PTHREAD_COND_INITIALIZER;

void DrawText(const char *str, const char *fnt, int len, int x, int y, int siz)
{
	graphbuf_t *crnt = graphbuf+graph_tail;
	crnt->fnt = fnt;
	crnt->siz = siz;
	crnt->x = x;
	crnt->y = y;
	crnt->buf = strdup(str);
	if (++graph_tail == graph_siz)
		graph_tail = 0;
}

Class nextAction()
{
	
	sceneIdx++;
	sceneIdx = sceneIdx % ( sizeof(transitions) / sizeof(transitions[0]) );
	NSString *r = transitions[sceneIdx];
	Class c = NSClassFromString(r);
	return c;
}

Class backAction()
{
	sceneIdx--;
	int total = ( sizeof(transitions) / sizeof(transitions[0]) );
	if( sceneIdx < 0 )
		sceneIdx += total;	
	
	NSString *r = transitions[sceneIdx];
	Class c = NSClassFromString(r);
	return c;
}

Class restartAction()
{
	NSString *r = transitions[sceneIdx];
	Class c = NSClassFromString(r);
	return c;
}


#pragma mark -
#pragma mark Base Class

@implementation TestDemo

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];

	[scene addChild: [nextAction() node]];
	
//	[[CCDirector sharedDirector] runWithScene: scene];
		
	// return the scene
	return scene;
}

static int gr_open_flag = 0, gr_close_flag = 0;
#if 0
- (id) initWithData:(const void*)data pixelFormat:(CCTexture2DPixelFormat)pixelFormat pixelsWide:(NSUInteger)width pixelsHigh:(NSUInteger)height contentSize:(CGSize)size
{
	if((self = [super init])) {
		glGenTextures(1, &name_);
		glBindTexture(GL_TEXTURE_2D, name_);

		ccTexParams texParams = { GL_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE };
		glBindTexture( GL_TEXTURE_2D, self.name );
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, texParams.minFilter );
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, texParams.magFilter );
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, texParams.wrapS );
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, texParams.wrapT );
		
		// Specify OpenGL texture image
		
		switch(pixelFormat)
		{
			case kCCTexture2DPixelFormat_RGBA8888:
				glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
				break;
			case kCCTexture2DPixelFormat_RGBA4444:
				glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_SHORT_4_4_4_4, data);
				break;
			case kCCTexture2DPixelFormat_RGB5A1:
				glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_SHORT_5_5_5_1, data);
				break;
			case kCCTexture2DPixelFormat_RGB565:
				glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_SHORT_5_6_5, data);
				break;
			case kCCTexture2DPixelFormat_A8:
				glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, width, height, 0, GL_ALPHA, GL_UNSIGNED_BYTE, data);
				break;
			default:
				[NSException raise:NSInternalInconsistencyException format:@""];
				
		}
		
		size_ = size;
		width_ = width;
		height_ = height;
		format_ = pixelFormat;
		maxS_ = size.width / (float)width;
		maxT_ = size.height / (float)height;
		
		hasPremultipliedAlpha_ = NO;
	}					
	return self;
}

- (id) initWithString:(NSString*)string dimensions:(CGSize)dimensions alignment:(CCTextAlignment)alignment fontName:(NSString*)name fontSize:(CGFloat)size
{
	NSUInteger width = ccNextPOT(dimensions.width);
	NSUInteger height = ccNextPOT(dimensions.height);
	unsigned char*			data;
	
	CGContextRef			context;
	CGColorSpaceRef			colorSpace;
	id						uifont;
	
	colorSpace = CGColorSpaceCreateDeviceGray();
	data = calloc(height, width);
	context = CGBitmapContextCreate(data, width, height, 8, width, colorSpace, kCGImageAlphaNone);
	
	if( ! context ) {
		free(data);
		[self release];
		return nil;
	}
	
	CGColorSpaceRelease(colorSpace);
	
	
	CGContextSetGrayFillColor(context, 1.0f, 1.0f);
	CGContextTranslateCTM(context, 0.0f, height);
	CGContextScaleCTM(context, 1.0f, -1.0f); //NOTE: NSString draws in UIKit referential i.e. renders upside-down compared to CGBitmapContext referential
	
	UIGraphicsPushContext(context);
	
        uifont = [UIFont fontWithName:name size:size];
		[string drawInRect:CGRectMake(0, 0, dimensions.width, dimensions.height) withFont:uifont lineBreakMode:UILineBreakModeWordWrap alignment:alignment];
	
	if( ! uifont )
		CCLOG(@"cocos2d: Texture2D: Font '%@' not found", name);
	UIGraphicsPopContext();
	
	self = [self initWithData:data pixelFormat:kCCTexture2DPixelFormat_A8 pixelsWide:width pixelsHigh:height contentSize:dimensions];
	CGContextRelease(context);
	free(data);
}
#endif
-(void) update: (ccTime) dt
{
	int idx = 0;
	CGSize s = [[CCDirector sharedDirector] winSize];
	if (gr_open_flag)
	{
		gr_open_flag = 0;
		sceneIdx=1;
		CCScene *s = [CCScene node];
		[s addChild: [restartAction() node]];	
		
		[[CCDirector sharedDirector] replaceScene: s];
	}
	else if (gr_close_flag)
	{
		gr_close_flag = 0;
		sceneIdx=0;
		CCScene *s = [CCScene node];
		[s addChild: [restartAction() node]];	
		
		[[CCDirector sharedDirector] replaceScene: s];
	}
	else if (sceneIdx) while (graph_head != graph_tail)
	{
		graphbuf_t *crnt = graphbuf+graph_head;
		if (++graph_head == graph_siz)
			graph_head = 0;
		
		NSStringEncoding enc = NSUTF8StringEncoding;
		NSString *conv = [NSString stringWithCString:crnt->buf encoding:enc];
		NSString *font = [NSString stringWithCString:crnt->fnt encoding:enc];
		CGSize dimensions = CGSizeZero; // {s.width, 20};
#if 1
		CCLabelTTF *mytextspace = [CCLabelTTF labelWithString: conv dimensions:dimensions alignment:CCTextAlignmentLeft fontName:font fontSize:crnt->siz];
		[mytextspace setPosition: ccp(s.width/2+crnt->x, 380+crnt->y)];
		[self addChild: mytextspace];
#endif
	}
	else for (idx = 0; idx < sizeof(textspace)/sizeof(*textspace); idx++)
	{
		const char *buf = stdoutbuf[idx];
		stdoutbuf[idx][width-1] = 0;
		NSStringEncoding enc = NSUTF8StringEncoding;
		NSString *conv = [NSString stringWithCString:buf encoding:enc];
		[textspace[idx] setString:conv];
		[textspace[idx] setPosition: ccp(s.width/2, s.height-100-idx*20)];
	}
}

void gr_open(void)
{
	gr_open_flag = 1;
}

void gr_close(void)
{
	gr_close_flag = 1;
}

-(id) init
{
	if( (self=[super init]) ) {
		
		int i;
		
		CGSize s = [[CCDirector sharedDirector] winSize];
	
 		CCLabelTTF *label = [CCLabelTTF labelWithString:[self title] fontName:@"Arial" fontSize:32];
		[self addChild: label];
		[label setPosition: ccp(s.width*3/4, s.height-50)];

		for (i = 0; i < sizeof(textspace)/sizeof(*textspace); i++)
		{
			CGSize dim = {s.width, 20};
			textspace[i] = [CCLabelTTF labelWithString: @"" dimensions:dim alignment:CCTextAlignmentLeft fontName:@"Arial" fontSize:16];
			[textspace[i] setPosition: ccp(s.width/2, s.height-100-i*20)];
			[self addChild: textspace[i]];
		}
		
		CCMenuItemImage *item1 = [CCMenuItemImage itemFromNormalImage:@"b1.png" selectedImage:@"b2.png" target:self selector:@selector(backCallback:)];
		CCMenuItemImage *item2 = [CCMenuItemImage itemFromNormalImage:@"r1.png" selectedImage:@"r2.png" target:self selector:@selector(restartCallback:)];
		CCMenuItemImage *item3 = [CCMenuItemImage itemFromNormalImage:@"f1.png" selectedImage:@"f2.png" target:self selector:@selector(nextCallback:)];
		
		CCMenu *menu = [CCMenu menuWithItems:item1, item2, item3, nil];
		
#if 0
		menu.position = CGPointZero;
		item1.position = ccp( s.width*3/4 - 100, s.height-100 );
		item2.position = ccp( s.width*3/4, s.height-100 );
		item3.position = ccp( s.width*3/4 + 100, s.height-100 );
#else
		menu.position = CGPointMake(s.width/2, 380 );
		item1.position = ccp( -100, 0 );
		item2.position = ccp( 0, 0 );
		item3.position = ccp( 100, 0 );
#endif
		[self addChild: menu z:-1];	

		// update after action in run!
		[self scheduleUpdateWithPriority:1];
//		[[CCScheduler sharedScheduler] scheduleUpdateForTarget:self priority:0 paused:NO];
	}

	return self;
}

-(void) dealloc
{
	[super dealloc];
}

-(void) newOrientation
{
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
	ccDeviceOrientation orientation = [[CCDirector sharedDirector] deviceOrientation];
	switch (orientation) {
		case CCDeviceOrientationLandscapeLeft:
			orientation = CCDeviceOrientationPortrait;
			break;
		case CCDeviceOrientationPortrait:
			orientation = CCDeviceOrientationLandscapeRight;
			break;						
		case CCDeviceOrientationLandscapeRight:
			orientation = CCDeviceOrientationPortraitUpsideDown;
			break;
		case CCDeviceOrientationPortraitUpsideDown:
			orientation = CCDeviceOrientationLandscapeLeft;
			break;
	}
	[[CCDirector sharedDirector] setDeviceOrientation:orientation];
#endif // iPhone
}

-(void) restartCallback: (id) sender
{
//	[self newOrientation];
	CCScene *s = [CCScene node];
	[s addChild: [restartAction() node]];	

	[[CCDirector sharedDirector] replaceScene: s];
}

-(void) nextCallback: (id) sender
{
//	[self newOrientation];

	CCScene *s = [CCScene node];
	[s addChild: [nextAction() node]];
	[[CCDirector sharedDirector] replaceScene: s];
}

-(void) backCallback: (id) sender
{
//	[self newOrientation];

	CCScene *s = [CCScene node];
	[s addChild: [backAction() node]];
	[[CCDirector sharedDirector] replaceScene: s];
}

-(NSString*) title
{
	return @"No title";
}

@end

#pragma mark -
#pragma mark Drawing Primitives Test 1

@implementation Test1
//
// TIP:
// Every CocosNode has a "draw" method.
// In the "draw" method you put all the code that actually draws your node.
// And Test1 is a subclass of TestDemo, which is a subclass of Layer, which is a subclass of CocosNode.
//
// As you can see the drawing primitives aren't CocosNode objects. They are just helper
// functions that let's you draw basic things like: points, line, polygons and circles.
//
//
// TIP:
// Don't draw your stuff outide the "draw" method. Otherwise it wont get transformed.
//
//
// TIP:
// If you want to rotate/translate/scale a circle or any other "primtive", you can do it by rotating
// the node. eg:
//    self.rotation = 90;
//
-(void) draw
{
	CGSize s = [[CCDirector sharedDirector] winSize];
		
	// draw a simple line
	// The default state is:
	// Line Width: 1
	// color: 255,255,255,255 (white, non-transparent)
	// Anti-Aliased
	glEnable(GL_LINE_SMOOTH);
	ccDrawLine( ccp(0, 300), ccp(s.width, 300) );
	
	// restore original values
	glLineWidth(1);
	glColor4ub(255,255,255,255);
	glPointSize(1);
}
-(NSString *) title
{
	return @"OCAML console";
}
@end

enum {maxq = 65536};

void *keyboard;

typedef struct {
	enum geom func;
	long arg1,arg2,arg3,arg4;
} func_t;

static func_t *qptr, myqueue[maxq+1];

@implementation Test2
//
// TIP:
// Every CocosNode has a "draw" method.
// In the "draw" method you put all the code that actually draws your node.
// And Test1 is a subclass of TestDemo, which is a subclass of Layer, which is a subclass of CocosNode.
//
// As you can see the drawing primitives aren't CocosNode objects. They are just helper
// functions that let's you draw basic things like: points, line, polygons and circles.
//
//
// TIP:
// Don't draw your stuff outide the "draw" method. Otherwise it wont get transformed.
//
//
// TIP:
// If you want to rotate/translate/scale a circle or any other "primitive", you can do it by rotating
// the node. eg:
//    self.rotation = 90;
//

CGPoint myvertices[100];
int shape_cnt = 0;

-(void) draw
{
		func_t *ptr = myqueue;
		
			CGSize s = [[CCDirector sharedDirector] winSize];

	NSString *conv = [NSString stringWithFormat:@"%.5f",355.0/113.0];
	NSString *fnt = @"Arial";
	int siz = 24;
    CGSize dimensions = [conv sizeWithFont:[UIFont fontWithName:fnt size:siz]];		
//	return [self initWithString:string dimensions:dim alignment:CCTextAlignmentCenter fontName:fnt fontSize:size];
//	CCTexture2D *texture = [[CCTexture2D alloc] initWithString:conv dimensions:dim alignment:UITextAlignmentLeft fontName:fnt fontSize:siz];
	{
		NSUInteger width = ccNextPOT(dimensions.width);
		NSUInteger height = ccNextPOT(dimensions.height);
		unsigned char*			data;
		
		CGContextRef			context;
		CGColorSpaceRef			colorSpace;
		id						uifont;
		
		colorSpace = CGColorSpaceCreateDeviceGray();
		data = calloc(height, width);
		context = CGBitmapContextCreate(data, width, height, 8, width, colorSpace, kCGImageAlphaNone);
		
		if( context ) {
		
		CGColorSpaceRelease(colorSpace);
		
		
		CGContextSetGrayFillColor(context, 1.0f, 1.0f);
		CGContextTranslateCTM(context, 0.0f, height);
		CGContextScaleCTM(context, 1.0f, -1.0f); //NOTE: NSString draws in UIKit referential i.e. renders upside-down compared to CGBitmapContext referential
		
		UIGraphicsPushContext(context);
		
		{
			uifont = [UIFont fontWithName:fnt size:siz];
			[conv drawInRect:CGRectMake(0, 0, dimensions.width, dimensions.height) withFont:uifont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
		}
		
		if( ! uifont )
			CCLOG(@"cocos2d: Texture2D: Font '%@' not found", fnt);
		UIGraphicsPopContext();
		
		CCTexture2D *texture = [[CCTexture2D alloc] initWithData:data pixelFormat:kCCTexture2DPixelFormat_A8 pixelsWide:width pixelsHigh:height contentSize:dimensions];

	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Unneeded states: GL_COLOR_ARRAY
	glDisableClientState(GL_COLOR_ARRAY);
	
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	glColor4ub(224,224,244,200);
	[texture drawAtPoint: ccp(s.width/2,s.height/2)];
	[texture release];
	
	glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
	
	// restore default GL state
	glEnableClientState(GL_COLOR_ARRAY);
		CGContextRelease(context);
		free(data);
		}
	}			
			glEnable(GL_LINE_SMOOTH);
			ccDrawLine( ccp(0, 1000), ccp(s.width, 1000) );
			
			while (ptr < qptr) {
			pthread_mutex_lock(&mut);
			switch (ptr->func) {
				case qRect:
				{
					CGPoint vertices[] = { ccp(ptr->arg1,ptr->arg2),
											ccp(ptr->arg1,ptr->arg2+ptr->arg4),
											ccp(ptr->arg1+ptr->arg3,ptr->arg2+ptr->arg4),
											ccp(ptr->arg1+ptr->arg3,ptr->arg2),
											ccp(ptr->arg1,ptr->arg2) };
					ccDrawPoly( vertices, 5, NO);
					break;
				}
				case qLine:
					glEnable(GL_LINE_SMOOTH);
					ccDrawLine( ccp(ptr->arg1, ptr->arg2), ccp(ptr->arg3, ptr->arg4) );
					break;
				case qSetColor:
					glColor4ub(ptr->arg1, ptr->arg2, ptr->arg3, 255);
					break;
				case qSetLineWidth:
					glLineWidth(ptr->arg1);
					break;
				case qCurve:
					ccDrawCubicBezier(ccp(ptr->arg1, ptr->arg2), ccp(ptr->arg3, ptr->arg4), ccp(ptr[1].arg1, ptr[1].arg2), ccp(ptr[1].arg3, ptr[1].arg4), 100);
					++ptr;
					break;
				case qFill:
				{
					CGPoint vertices[] = { ccp(ptr->arg1,ptr->arg2),
						ccp(ptr->arg1,ptr->arg2+ptr->arg4),
						ccp(ptr->arg1+ptr->arg3,ptr->arg2+ptr->arg4),
						ccp(ptr->arg1+ptr->arg3,ptr->arg2),
						ccp(ptr->arg1,ptr->arg2) };
					ccDrawPoly( vertices, 5, YES);
					break;
				}
				case qBeginShape:
					shape_cnt = 0;
					break;
				case qVertex:
					myvertices[shape_cnt++] = ccp(ptr->arg1, ptr->arg2);
					break;
				case qEndShape:
				{
					ccDrawPoly( myvertices, shape_cnt, NO);
					break;
				}
				default:
				{
					enum geom unknown = ptr->func;
					break;
				}
			}
			pthread_mutex_unlock(&mut);
			++ptr;
		}
	// restore original values
	glLineWidth(1);
	glColor4ub(255,255,255,255);
	glPointSize(1);
}

-(NSString *) title
{
	return @"OCAML Graphics";
}
@end

void setup();
void update();
void draw();
void wakethread();
void exit();
int load_of_font(const char *);

void lostFocus();
void gotFocus();
void gotMemoryWarning();
void deviceOrientationChanged(int newOrientation);

void *keyboards[UIDeviceOrientationFaceDown+1];

int dly;

struct {
	int x,y,z,r;
	UIDeviceOrientation orient;
} orientation, oldorient;

int read_fonts()
{
	DIR * d;
	struct dirent * e;
	char *p;
	const char *dirname = fullp(@".");
	d = opendir(dirname);
	if (d == NULL) return -1;
	while (1) {
		e = readdir(d);
		if (e == NULL) break;
		if (strcmp(e->d_name, ".") == 0 || strcmp(e->d_name, "..") == 0) continue;
		p = (char *)malloc(strlen(e->d_name) + 1);
		strcpy(p, e->d_name);
		if (strstr(p, ".ttf")) load_of_font(p);
	}
	closedir(d);
	free((char *)dirname);
	return 0;
}

char removefrombuf(void)
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

 int stdin_read(char *buf, int siz)
{
	char ch;
	int cnt = 0;
	do {
		do {
			pthread_mutex_lock(&mut);
			ch = removefrombuf();
			if (ch == -1)
				pthread_cond_wait(&cond, &mut);
			pthread_mutex_unlock(&mut);
		}
		while (ch == -1);
		if (ch)
			buf[cnt++] = ch;
		else {
			if (cnt) --cnt;;
		}
		
		stdout_write(&ch, 1);
	} while ((cnt < siz) && (ch != '\n'));
	return cnt;
}

void* PosixThreadMainRoutine(void* data)
{
	const char *init = "ocamlinit";
	qptr = myqueue;
	memset(stdoutbuf, ' ', sizeof stdoutbuf);
	const char *ocaml = fullp(@"ocaml-3.12.0/bin/ocaml");
	const char *ocamlinit = fullp(@"ocaml-3.12.0/ocamlinit");
	const char *ocamlinclude = fullp(@"ocaml-3.12.0");
	if (access(init,R_OK))
	{
		init = ocamlinit;
		if (access(init,R_OK))
		{
			const char *argv[] = {"ocamlrun", ocaml, "-I", ocamlinclude, NULL};
			ocaml_main(4,argv);
		}
		else 
		{
			const char *argv[] = {"ocamlrun", ocaml, "-I", ocamlinclude, "-init", init, NULL};
			ocaml_main(6,argv);
		}
	}	
	else 
	{
		const char *argv[] = {"ocamlrun", ocaml, "-I", ocamlinclude, "-init", init, NULL};
		ocaml_main(6,argv);
	}
	free((char *)ocaml);
	free((char *)ocamlinit);
	free((char *)ocamlinclude);
	return NULL;
}

void LaunchThread()
{
    // Create the thread using POSIX routines.
    pthread_attr_t  attr;
    pthread_t       posixThreadID;
    int             returnVal;
	
    returnVal = pthread_attr_init(&attr);
    assert(!returnVal);
    returnVal = pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
    assert(!returnVal);
	
    int     threadError = pthread_create(&posixThreadID, &attr, &PosixThreadMainRoutine, NULL);
	
    returnVal = pthread_attr_destroy(&attr);
    assert(!returnVal);
    if (threadError != 0)
    {
		// Report an error.
    }
}

//static int first;

//--------------------------------------------------------------
void testApp_setup()
{	
	read_fonts();
	
	for (int i = 0; i < sizeof(keyboards)/sizeof(*keyboards); i++)
	{
		keyboards[i] = NULL;
		keyboard = *keyboards;
		deviceOrientationChanged(i);
	}
	deviceOrientationChanged(UIDeviceOrientationPortrait);
	
	memset(stdoutbuf, ' ', sizeof stdoutbuf);
	
	LaunchThread();
}

void stdout_puts(const char *buf)
{
	stdout_write(buf, strlen(buf));
}

void wakethread()
{
	pthread_mutex_lock(&mut);
	pthread_cond_broadcast(&cond);
	pthread_mutex_unlock(&mut);
}

int stdout_write(const char *buf, int len)
{
	const char *bufend = buf+len;
	unsigned arg[20];
	int Line, Column, Mode, Seq;
	pthread_mutex_lock(&mut);
	while (buf<bufend) {
		switch (*buf) {
			default:
				stdoutbuf[row][col++] = *buf;
				if (col < width) break;
				col = 0;
			case '\n':
				if (++row == height)
				{
					for (row = 0; row < height-1; row++)
						memcpy(stdoutbuf[row], stdoutbuf[row+1], width);
					memset(stdoutbuf[row], ' ', width);
				}
			case '\r':
				col = 0;
				break;
			case '\e':
			{
				int cnt;
				switch(*++buf)
				{
					case '[':
						for (cnt = 0; cnt < sizeof(arg)/sizeof(*arg); cnt++)
							arg[cnt] = 0;
						cnt = 0;
						do {
							++buf;
							arg[cnt] = 0;
							while (isdigit(*buf))
								arg[cnt] = arg[cnt]*10 + *buf++ - '0';
							++cnt;
						} while(*buf == ';');
						switch (*buf)
					{
						case 'C':
							col += arg[0];
							if (col >= width)
								col = width-1;
							break;
						case 'H':
							row = arg[0];
							col = arg[1];
							break;
						case 'J': if (arg[0]==2)
						{
							for (Column = 0; Column < width; Column++)
								for (Line = 0; Line < height; Line++)
									stdoutbuf[Line][Column] = ' ';
							row = 0;
							col = 0;
						}
							break;
						case 'm':
							Mode = arg[0];
							break;
						default:
							Seq = *buf;
					}
						break;
					default:
						Seq = *buf;
				}
			}
				break;
		}
		++buf;
	}
	pthread_mutex_unlock(&mut);
	//	pthread_cond_wait(&cond, &mut);
	return len;
}

 int bas_read(int fd, char *buf, int len)
{
	if (fd!=fileno(stdin))
		return read(fd, buf, len);
	else 
		return stdin_read(buf, len);
}

 int bas_write(int fd, char *buf, int len)
{
	if (fd!=fileno(stdout))
		return write(fd, buf, len);
	else 
	{
		stdout_write(buf, len);	
		return len;
	}
}
#if 0
 int bas_open(char *name, int flags, int mode)
{
	const char *path = getPwd;
	string combined = string(path) + "/" + name;
	const char *combined_c = combined.c_str();
	return open(combined_c, flags, mode);
}
#endif
 void queue(enum geom func, long arg1, long arg2, long arg3, long arg4)
{
	pthread_mutex_lock(&mut);
	qptr->func = func;
	qptr->arg1 = arg1;
	qptr->arg2 = arg2;
	qptr->arg3 = arg3;
	qptr->arg4 = arg4;	
	if (qptr-myqueue < maxq) ++qptr;
	qptr->func = qEnd;
	if (func == qReset) qptr = myqueue;
	pthread_mutex_unlock(&mut);
}

 void queue2(enum geom func, long arg1, long arg2, long arg3, long arg4, long arg5, long arg6, long arg7, long arg8)
{
	pthread_mutex_lock(&mut);
	qptr->func = func;
	qptr->arg1 = arg1;
	qptr->arg2 = arg2;
	qptr->arg3 = arg3;
	qptr->arg4 = arg4;	
	if (qptr-myqueue < maxq) ++qptr;
	qptr->func = func;
	qptr->arg1 = arg5;
	qptr->arg2 = arg6;
	qptr->arg3 = arg7;
	qptr->arg4 = arg8;	
	if (qptr-myqueue < maxq) ++qptr;
	qptr->func = qEnd;
	pthread_mutex_unlock(&mut);
}


