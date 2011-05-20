//
//  Loki_ToolsAppDelegate.m
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


#import "Loki_ToolsAppDelegate.h"
#import "ErrorMessageViewController.h"

@implementation Loki_ToolsAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	userLogin = [[User alloc]init];
	searchView = [[SearchViewController alloc] init];
	maintenaceView = [MaintenaceViewController alloc];
	[maintenaceView initWithUser:userLogin];
	loginView = [LoginViewController alloc];
	[loginView initWithUser:userLogin andMainProgram: self];
	selectDatabaseView = [SelectDatabaseViewController alloc];
	[selectDatabaseView initWithUser:userLogin];
	traderTypeView = [TraderTypeViewController alloc];
	[traderTypeView initWithUser: userLogin];
	supplierView = [SupplierViewController alloc];
	[supplierView initWithUser:userLogin];
	storeView = [StoreViewController alloc];
	[storeView initWithUser:userLogin];
	[self menuAuthority];
}

-(void) dealloc
{
	[userLogin release];
	[searchView release];
	[maintenaceView release];
	[traderTypeView release];
	[supplierView release];
	[storeView release];
	[super dealloc];
}

-(void)menuAuthority
{
	//sets which menus can be used
	if ([userLogin validLogin]) {
		[loginMenu setEnabled:YES];
		[searchMenu setEnabled:NO];
		[maintenaceMenu setEnabled:YES];
		[selectDatabaseMenu setEnabled:YES];
		[traderTypeMenu setEnabled:YES];
		[supplierMenu setEnabled:YES];
		[storeMenu setEnabled:YES];
	}
	else {
		[loginMenu setEnabled:YES];
		[searchMenu setEnabled:NO];
		[maintenaceMenu setEnabled:NO];
		[selectDatabaseMenu setEnabled:NO];
		[traderTypeMenu setEnabled:NO];
		[supplierMenu setEnabled:NO];
		[storeMenu setEnabled:NO];
	}
}

-(IBAction) openSearch: (id) sender
{
	//[searchView openSearchWindow];
}

-(IBAction) openMaintenace: (id) sender
{
	[maintenaceView openMaintenace];
}

-(IBAction) openLogin: (id) sender
{
	[loginView openLogin];
}

-(IBAction) openSelectDatabase: (id) sender
{
	[selectDatabaseView openSelectDatabase];
}

-(IBAction) openTrader: (id) sender
{
	[traderTypeView openTraderType];
}

-(IBAction)openSupplier:(id) sender
{
	[supplierView openSupplier];
}

-(IBAction)openStore:(id) sender;
{
	[storeView openStore];
}

@end
