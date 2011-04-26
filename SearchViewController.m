//
//  SearchViewController.m
//  Loki_Tools
//
//  Created by Douglas Mason on 11/02/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

#import "SearchViewController.h"


@implementation SearchViewController

@synthesize productSearchKey, productBrowser, searchWindow;

-(SearchViewController *) init
{
	self = [super init];
	
	if (self) {
		//when something important is needed here (clap your hands)
	}
	
	return self;
}

-(void)openSearchWindow
{
	if([searchWindow isVisible])
	{
		[searchWindow orderFront:@"[SearchViewController openSearchWindow]"];
	}
	else {
		[NSBundle loadNibNamed:@"SearchViewController" owner: self];
	}

}


-(IBAction) searchNow: (id) sender
{
	NSString* searchKey = [productSearchKey stringValue];
	
	//NSBrowserCell* cell = [[NSBrowserCell alloc]initTextCell:@"Fox and Gun Ltd"];
	
	NSBrowserCell* cellTest; 
	
	NSMatrix* databaseCol;
	
	//databaseCol = [productBrowser matrixInColumn:0];
	
	//[databaseCol putCell:cell atRow:0 column:0];
	
	NSLog(@"Search Key: %@ \n",searchKey);
	
	[productBrowser setMaxVisibleColumns:1];
	
	cellTest = [productBrowser loadedCellAtRow:0 column:0];
	
	[cellTest setStringValue:@"testing finally worked"];
	
	SearchSetupConnections* database = [[SearchSetupConnections alloc]init];
	
	[database connectDatabase];
	
	[database searchForSupplier:searchKey];
	
	[database disconnectDatabase];
	
	[database release];
}

@end
