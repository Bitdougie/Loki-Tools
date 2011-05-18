//
//  Loki_ToolsAppDelegate.h
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


#import <Cocoa/Cocoa.h>
#import "SearchViewController.h"
#import "MaintenaceViewController.h"
#import "LoginViewController.h"
#import "User.h"
#import "SelectDatabaseViewController.h"
#import "TraderTypeViewController.h"
#import "SupplierViewController.h"

@interface Loki_ToolsAppDelegate : NSObject <NSApplicationDelegate> {
@private
	SearchViewController *searchView;
	MaintenaceViewController *maintenaceView;
	LoginViewController *loginView;
	User *userLogin;
	SelectDatabaseViewController *selectDatabaseView;
	TraderTypeViewController *traderTypeView;
	SupplierViewController *supplierView;
	
	//menu items
	IBOutlet NSMenuItem *supplierMenu;
	IBOutlet NSMenuItem *loginMenu;
	IBOutlet NSMenuItem *searchMenu;
	IBOutlet NSMenuItem *maintenaceMenu;
	IBOutlet NSMenuItem *selectDatabaseMenu;
	IBOutlet NSMenuItem *traderTypeMenu;
	IBOutlet NSMenu *mainMenu;
	
}

-(IBAction) openSearch: (id) sender;
-(IBAction) openMaintenace: (id) sender;
-(IBAction) openLogin: (id) sender;
-(IBAction) openSelectDatabase:(id) sender;
-(IBAction) openTrader:(id) sender;
-(IBAction) openSupplier:(id) sender;

-(void)menuAuthority;

@end
