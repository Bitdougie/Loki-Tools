//
//  SearchNode.m
//  Loki_Tools
//
//  Created by Douglas Mason on 15/03/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

#import "SearchNode.h"


@implementation SearchNode

@dynamic displayName, children, isProduct, icon, labelColour;

-(SearchNode *)initWithName:(NSString *)name isProduct: (BOOL) product
{
	self = [super init];
	
	if(self){
		displayName = [[NSMutableString alloc]init];
		children = [[NSMutableArray alloc]init];
		
		[self setDisplayName: name];
		[self setIsProduct: product];
	}

	return self;
}

-(void)dealloc
{
	[displayName release];
	[children release];	
	[super dealloc];
}

-(NSString *)displayName
{
}

-(NSImage *)icon
{
}

-(BOOL)isProduct
{
}

-(NSArray *)children
{
}
	
-(NSColor *)labelColour
{
}

@end
