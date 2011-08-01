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
#import "LoginViewController.h"
#import "PhotoPullInViewController.h"

@implementation Loki_ToolsAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	userLogin = [[User alloc]init];
	[self menuAuthority];
}

-(void) dealloc
{
	[userLogin release];
	[super dealloc];
}

-(void)menuAuthority;
{
		[loginMenu setEnabled:YES];
		[searchMenu setEnabled:YES];
		[maintenaceMenu setEnabled:YES];
		[selectDatabaseMenu setEnabled:YES];
		[traderTypeMenu setEnabled:YES];
		[supplierMenu setEnabled:YES];
		[storeMenu setEnabled:YES];
		[discountsMenu setEnabled:YES];
		[productsMenu setEnabled:YES];
}

-(IBAction) openSearch: (id) sender
{
	SearchViewController *searchView;
	searchView = [SearchViewController alloc];
	[searchView initWithUser:userLogin];
	
	if (![NSBundle loadNibNamed:@"SearchViewController" owner: searchView]) {
		ErrorMessageViewController *error;
		error = [[ErrorMessageViewController alloc]init];
		[error openErrorMessage:@"SearchViewController:openSearchWindow" withMessage:@"Could not load SearchViewController.xib"];
		[error setErrorNo:1];
		return;
	}
}

-(IBAction) openMaintenace: (id) sender
{
	MaintenaceViewController *maintenaceView;
	maintenaceView = [MaintenaceViewController alloc];
	[maintenaceView initWithUser:userLogin];
	
	if (![NSBundle loadNibNamed:@"MaintenaceViewController" owner: maintenaceView]) {
		ErrorMessageViewController *error;
		error = [[ErrorMessageViewController alloc]init];
		[error openErrorMessage:@"[MaintenaceViewController openMaintence]" withMessage:@"Could not load MaintenaceViewController.xib"];
		[error setErrorNo:1];
	}	
}

-(IBAction) openLogin: (id) sender
{
	NSLog(@"openLogin \n");
	LoginViewController *loginView;
	
	loginView = [LoginViewController alloc];
	
	[loginView initWithUser:userLogin];
	
	if (![NSBundle loadNibNamed:@"LoginViewController" owner: loginView]) {
		ErrorMessageViewController *error;
		error = [[ErrorMessageViewController alloc]init];
		[error openErrorMessage:@"Login:openLogin" withMessage:@"Could not load LoginViewController.xib"];
		[error setErrorNo:1];
	}
}

-(IBAction) openSelectDatabase: (id) sender
{
	NSLog(@"openSelectDatabase \n");
	
	SelectDatabaseViewController *selectDatabaseView;
	
	selectDatabaseView = [SelectDatabaseViewController alloc];
	[selectDatabaseView initWithUser:userLogin];
	
	if (![NSBundle loadNibNamed:@"SelectDatabaseViewController" owner: selectDatabaseView]) {
		ErrorMessageViewController *error;
		error = [[ErrorMessageViewController alloc]init];
		[error openErrorMessage:@"SelectDatabaseViewController:openSelectDatabase" withMessage:@"Could not load SelectDatabaseViewController.xib"];
		[error setErrorNo:1];
	}
	
	[selectDatabaseView populateList];	
}

-(IBAction) openTrader: (id) sender
{
	TraderTypeViewController *traderTypeView;
	traderTypeView = [TraderTypeViewController alloc];
	[traderTypeView initWithUser: userLogin];
	
	if (![NSBundle loadNibNamed:@"TraderTypeViewController" owner: traderTypeView]) {
		ErrorMessageViewController *error;
		error = [[ErrorMessageViewController alloc]init];
		[error openErrorMessage:@"TraderTypeViewController:openTraderType" withMessage:@"Could not load TraderTypeViewController.xib"];
		[error setErrorNo:1];
		return;
	}
	
	[traderTypeView populateList];
}

-(IBAction)openSupplier:(id) sender
{
	NSLog(@"openSupplier \n");
	SupplierViewController *supplierView;
	supplierView = [SupplierViewController alloc];
	[supplierView initWithUser:userLogin];
	
	if (![NSBundle loadNibNamed:@"SupplierViewController" owner: supplierView]) {
		ErrorMessageViewController *error;
		error = [[ErrorMessageViewController alloc]init];
		[error openErrorMessage:@"SupplierViewController:openSupplier" withMessage:@"Could not load SupplierViewController.xib"];
		[error setErrorNo:1];
		return;
	}
	
	[supplierView refresh: self];
}

-(IBAction)openStore:(id) sender;
{
	NSLog(@"openStore \n");
	StoreViewController *storeView;
	storeView = [StoreViewController alloc];
	[storeView initWithUser:userLogin];
	
	if (![NSBundle loadNibNamed:@"StoreViewController" owner: storeView]) {
		ErrorMessageViewController *error;
		error = [[ErrorMessageViewController alloc]init];
		[error openErrorMessage:@"StoreViewController:openStore" withMessage:@"Could not load StoreViewController.xib"];
		[error setErrorNo:1];
		return;
	}
	
	[storeView refresh: self];
}

-(IBAction)openDiscounts:(id) sender;
{
	NSLog(@"openDiscounts \n");
	DiscountsViewController *discountsView;
	
	discountsView = [DiscountsViewController alloc];
	[discountsView initWithUser:userLogin];
	if (![NSBundle loadNibNamed:@"DiscountsViewController" owner: discountsView]) {
		ErrorMessageViewController *error;
		error = [[ErrorMessageViewController alloc]init];
		[error openErrorMessage:@"DiscountsViewController:openDiscounts" withMessage:@"Could not load DiscountsViewController.xib"];
		[error setErrorNo:1];
		return;
	}
	
	[discountsView refresh:self];
}

-(IBAction)openProducts:(id) sender;
{
	ProductsViewController *productsView;
	productsView = [ProductsViewController alloc];
	[productsView initWithUser:userLogin];
	
	if (![NSBundle loadNibNamed:@"ProductsViewController" owner: productsView]) {
		ErrorMessageViewController *error;
		error = [[ErrorMessageViewController alloc]init];
		[error openErrorMessage:@"ProductViewController:openProduct" withMessage:@"Could not load ProductViewController.xib"];
		[error setErrorNo:1];
		return;
	}
	
	[productsView refresh:self];
}

-(IBAction)openPhotoPullIn:(id) sender
{
	PhotoPullInViewController *photoView;
	photoView = [PhotoPullInViewController alloc];
	[photoView initWithUser:userLogin];
	
	if (![NSBundle loadNibNamed:@"PhotoPullInViewController" owner: photoView]) {
		ErrorMessageViewController *error;
		error = [[ErrorMessageViewController alloc]init];
		[error openErrorMessage:@"ProductViewController:openPhotoPullIn" withMessage:@"Could not load PhotoPullInViewController.xib"];
		[error setErrorNo:1];
		return;
	}
	
	[photoView populateWindow];
}

@end
