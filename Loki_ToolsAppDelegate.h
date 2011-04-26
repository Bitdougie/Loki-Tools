//
//  Loki_ToolsAppDelegate.h
//  Loki_Tools
//
//  Created by Douglas Mason on 11/02/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SearchViewController.h"
#import "MaintenaceViewController.h"
#import "LoginViewController.h"
#import "User.h"

@interface Loki_ToolsAppDelegate : NSObject <NSApplicationDelegate> {
@private
	SearchViewController *searchView;
	MaintenaceViewController *maintenaceView;
	LoginViewController *loginView;
	User *userLogin;
	
	//menu items
	IBOutlet NSMenuItem *loginMenu;
	IBOutlet NSMenuItem *searchMenu;
	IBOutlet NSMenuItem *maintenaceMenu;
	
}

-(IBAction) openSearch: (id) sender;
-(IBAction) openMaintenace: (id) sender;
-(IBAction) openLogin: (id) sender;

-(void)menuAuthority;

@end
