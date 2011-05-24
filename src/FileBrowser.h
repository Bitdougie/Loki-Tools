//
//  FileBrowser.h
//  Loki_Tools
//
//  Created by Douglas Mason on 25/05/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ErrorMessageViewController.h"

@interface FileBrowser : NSObject {
	NSURL *url;
	NSMutableDictionary *children;
	BOOL childrenDirty;
	ErrorMessageViewController *error;
}

-(FileBrowser *)initWithURL:(NSURL *)urlObject;

@property(readonly, assign)NSURL *URL;
@property(readonly, copy)NSString *displayName;
@property(readonly, retain) NSArray *children;
@property(readonly) BOOL isDirectory;
@property(readonly,retain)NSColor *labelColor;

-(void)invalidateChildren;

@end
