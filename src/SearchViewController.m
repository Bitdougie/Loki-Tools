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

-(SearchViewController *)initWithUser:(User *)userObject
{
	self = [super init];
	
	if (self) {
		userLogin = userObject;
		[userLogin retain];
		error = [[ErrorMessageViewController alloc]init];
		rootNode = [SearchNode alloc];
		[rootNode initWithUser:userLogin];
		[rootNode setSearchString: @""];
		[rootNode setIsLeafNode:FALSE];
	}
	
	return self;
}

-(void)dealloc
{
	[error release];
	[userLogin release];
	[rootNode release];
	[super dealloc];
}

-(IBAction) searchNow: (id) sender
{
	[rootNode newSearchString:[productSearchKey stringValue]];
	[productBrowser loadColumnZero];
}

-(IBAction) selectItem: (id) sender
{
	if ([productBrowser clickedColumn] == 2) {
		ProductViewController *productView;
		productView = [ProductViewController alloc];
		[productView initWithUser:userLogin];
		
		SearchNode *node = [productBrowser itemAtRow:[productBrowser clickedRow] inColumn:[productBrowser clickedColumn]];
		[node retain];
		
		NSLog(@"openProductNo \n");
		[productView setProductCode: [node productCode]];
		[productView setSupplierCode:[node supplierCode]];
		
		[node release];
		
		if (![NSBundle loadNibNamed:@"ProductViewController" owner: productView]) {
			[error openErrorMessage:@"ProductViewController:openProductNo" withMessage:@"Could not load ProductViewController.xib"];
			[error setErrorNo:1];
			return;
		}
		
		[productView populateWindow];
	}
}

-(id)rootItemForBrowser:(NSBrowser *)browser
{
	return rootNode;
}

-(NSInteger)browser:(NSBrowser *)browser numberOfChildrenOfItem:(id)item
{
	SearchNode *node = (SearchNode *)item;
	return [node numOfChildren];
}

-(id)browser:(NSBrowser *)browser child:(NSInteger)index ofItem:(id)item
{
	SearchNode *node = (SearchNode *)item;
	return [node childAtIndex:index];
}

-(BOOL)browser:(NSBrowser *)browser isLeafItem:(id)item
{
	SearchNode *node = (SearchNode *)item;	
	return [node isLeafNode];
}

-(id)browser:(NSBrowser *)browser objectValueForItem:(id)item
{
	SearchNode *node = (SearchNode *)item;
	
	if ([node supplierCode] != nil) {
		if ([node brandName] != nil ) {
			if ([node productCode] != nil) {
				return [node productDescription];
			}
			else {
				return [node brandName];
			}
		}
		else {
			return [node supplierName];
		}
	}
	else{
		return @"rootNode";
	}
}

@end
