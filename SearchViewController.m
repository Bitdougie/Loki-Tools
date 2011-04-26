//
//  SearchViewController.m
//  Loki_Tools
//
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
