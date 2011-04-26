//
//  SearchNode.h
//  Loki_Tools
//
//  Created by Douglas Mason on 15/03/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SearchNode : NSObject {
@private
	NSMutableString *displayName;
	NSMutableArray *children;
	NSImage *icon;
	NSColor *labelColour;
	BOOL isProduct;
}

@property(nonatomic,copy)NSString *displayName;
@property(nonatomic,copy)NSMutableArray *children;
@property(nonatomic,copy)NSImage *icon;
@property(nonatomic,copy)NSColor *labelColour;
@property(nonatomic)BOOL isProduct;

-(SearchNode *)initWithName:(NSString *)name isProduct:(BOOL) offSpring;

@end
