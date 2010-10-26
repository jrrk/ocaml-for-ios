//
//  main.m
//  ocaml-cocos
//
//  Created by Jonathan Kimmitt on 19/10/2010.
//  Copyright OMSI Limited 2010. All rights reserved.
//

#include <sys/param.h>
#import <UIKit/UIKit.h>
#include <unistd.h>
#import <Foundation/Foundation.h>
//#import "libs/cocos2d/CCConfiguration.h"

//char *getPwd, *getPwd2;

NSBundle		*myloadingBundle = nil;

const char *fullp(NSString *relPath)
{
char realp[MAXPATHLEN];
NSAutoreleasePool *pool = [NSAutoreleasePool new];
NSString *fullpath = nil;	
// only if it is not an absolute path
if( ! [relPath isAbsolutePath] )
	{
	NSMutableArray *imagePathComponents = [NSMutableArray arrayWithArray:[relPath pathComponents]];
	NSString *file = [imagePathComponents lastObject];
	
	[imagePathComponents removeLastObject];
	NSString *imageDirectory = [NSString pathWithComponents:imagePathComponents];
		
	fullpath = [myloadingBundle pathForResource:file ofType:nil inDirectory:imageDirectory];
	const char* bundle_String = [fullpath UTF8String]; 
	realpath(bundle_String, realp);
	[pool release];
	return strdup(realp);
	}	
else {
	const char *rel = strdup([relPath UTF8String]);
	[pool release];
	return rel;	
}

}

const char *getPwd(void)
{
	static const char *pwd = 0;
	if (!pwd)
	{
		NSAutoreleasePool *pool = [NSAutoreleasePool new];
		const char *tmp_pwd = fullp(@".");
		char *new_pwd = (char *)malloc(strlen(tmp_pwd)+2);
		sprintf(new_pwd, "%s/", tmp_pwd);
		free((char *)tmp_pwd);
		pwd = new_pwd;
		[pool release];
	}
	return pwd;
}

int main(int argc, char *argv[]) {
	int retval;
	const char *mydir;
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	myloadingBundle = [NSBundle mainBundle];
	NSArray *dirArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
															NSUserDomainMask,
															YES);
	mydir = [[dirArray objectAtIndex:0] UTF8String];
	retval = chdir(mydir);
	if (retval)
	{
		perror("chdir");
	}
	// NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"."];
	// [NSString stringWithFormat:@"%@", [dirArray objectAtIndex:0]];
	// const char* cString = [path UTF8String]; 
	
#if 0
	getPwd = (char *)malloc(strlen(realp)+50);
	strcpy(getPwd, realp);
	getPwd2 = strdup(realp);
	chdir(getPwd2);
	
	char *right = strrchr(getPwd, '/');
	if (right) right[1] = 0;
#endif
	int retVal = UIApplicationMain(argc, argv, nil, @"ocaml_cocosAppDelegate");
	[pool release];
	return retVal;
}
