//
//  BrowserList.m
//  Loki_Tools
/*
 Loki Tools a Search engine, data preperation tool that does data mining
 and retail analysis.
 Copyright (C) 2011  Douglas Mason
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.//
 */

#import "BrowserList.h"

@implementation BrowserList

@synthesize displayName, children;

-(BrowserList *)init
{
	self = [super init];
	
	if(self)
	{
		displayName = [[NSString alloc]init];
		children = [[NSMutableArray alloc]init];
	}
	return self;
}

-(void)dealloc
{
	[displayName release];
	[children release];
	[super dealloc];
}

-(BrowserList *)initWithChildren:(NSMutableArray *)browserListArray andRootDisplayName:(NSString *) rootName
{
	[self init];
	
	if(self)
	{
		[self setDisplayName:rootName];
		[self setChildren:browserListArray];
	}
	return self;
}

-(BrowserList *) initWithDisplayName:(NSString *)rootName
{
	[self init];
	
	if(self)
	{
		[self setDisplayName:rootName];
	}
	
	return self;
}

-(void)addChild:(BrowserList *)browserChild
{
	[children addObject:browserChild];
}

-(void)removeAllChildren
{
	[children removeAllObjects];
}

-(int)numberOfChildren
{
	int number;
	number = [children count];
	return number;
}

-(BrowserList *)childAtIndex:(NSUInteger)index
{
    BrowserList *child;
	child = [children objectAtIndex:index];
	return child;
}

@end
