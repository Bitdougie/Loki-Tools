//
//  Loki_ToolsAppDelegate.m
//  Loki_Tools
//
//  Created by Douglas Mason on 11/02/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

#import "Loki_ToolsAppDelegate.h"

@implementation Loki_ToolsAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	userLogin = [[User alloc]init];
	searchView = [[SearchViewController alloc] init];
	maintenaceView = [[MaintenaceViewController alloc] init];
	loginView = [LoginViewController alloc];
	[loginView initWithUser:userLogin];
}

-(IBAction) openSearch: (id) sender
{
	[searchView openSearchWindow];
}

-(IBAction) openMaintenace: (id) sender
{
	[maintenaceView openMaintenace];
}

-(IBAction) openLogin: (id) sender
{
	[loginView openLogin];
}

-(void)menuAuthority
{
	//sets which menus can be used
	if ([userLogin validLogin]) {
		
	}
	else {
	// disable everyting hmmm what a job
		[loginMenu setAction:@selector(openLogin:)];
	}

}

-(void) dealloc
{
	[searchView release];
	[maintenaceView release];
	[super dealloc];
}
@end
