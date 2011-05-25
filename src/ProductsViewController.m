//
//  ProductsViewController.m
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
 
 Loki Tools  Copyright (C) 2011  Douglas Mason
 This program comes with ABSOLUTELY NO WARRANTY;
 */

#import "ProductsViewController.h"


@implementation ProductsViewController

-(ProductsViewController *)initWithUser:(User *)userObject
{
	self = [super init];
	
	if(self)
	{
		userLogin = userObject;
		[userLogin retain];
		error = [[ErrorMessageViewController alloc]init];
	}
	return self;
}

-(void)dealloc
{
	[userLogin release];
	[error release];
	[rootNode release];
	[super dealloc];
}

-(void)openProducts
{
	if (![NSBundle loadNibNamed:@"ProductsViewController" owner: self]) {
		[error openErrorMessage:@"ProductViewController:openProduct" withMessage:@"Could not load ProductViewController.xib"];
		[error setErrorNo:1];
		return;
	}
}

-(id)rootItemForBrowser:(NSBrowser *)browser
{
	if(rootNode == nil){
		rootNode = [[FileBrowser alloc] initWithURL:[NSURL fileURLWithPath:@"/Users/"]];
	}
	return rootNode;
}

-(NSInteger)browser:(NSBrowser *)browser numberOfChildrenOfItem:(id)item
{
	FileBrowser *node = (FileBrowser *)item;
	return [[node children] count];
}

-(id)browser:(NSBrowser *)browser child:(NSInteger)index ofItem:(id)item
{
	FileBrowser *node = (FileBrowser *)item;
	return [[node children] objectAtIndex:index];
}

-(BOOL)browser:(NSBrowser *)browser isLeafItem:(id) item{
	FileBrowser *node = (FileBrowser *)item;
	if (![node isDirectory]) {
		[path setStringValue:[node fullFilePath]];
	}
	else {
		[path setStringValue:@"Nothing Currently Selected ... :-("];
	}

	return ![node isDirectory];
}

-(id)browser:(NSBrowser *)browser objectValueForItem:(id) item{

	FileBrowser *node = (FileBrowser *)item;
	return [node displayName];
}

@end
