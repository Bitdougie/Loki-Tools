//
//  LoginViewController.m
//  Loki_Tools
//
//  Created by Douglas Mason on 11/04/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

#import "LoginViewController.h"



@implementation LoginViewController

-(LoginViewController *)initWithUser: (User *) userObject
{
	self = [super init];
	
	if(self){
		userLogin = userObject;
		[userLogin retain];
	}
	
	return self;
}

-(void)openLogin
{
	if([loginWindow isVisible])
	{
		[loginWindow orderFront:@"[LoginViewController openLogin]"];
	}
	else {
		[NSBundle loadNibNamed:@"LoginViewController" owner: self];
	}
}

-(IBAction)login: (id) sender;
{
	DatabaseSetupConnections *connection;
	
	connection = [DatabaseSetupConnections alloc];
	
	[connection initWithUser: userLogin];
	
	[userLogin setUserName:[user stringValue]];
	[userLogin setPassword:[password stringValue]];
	
	if(![connection connectDatabase]){
		[userLogin setValidLogin:TRUE];
		[loginWindow setIsVisible:FALSE];
	}
	else {
		[userLogin setValidLogin:FALSE];
	}

	[connection disconnectDatabase];
	[connection release];
}

-(void)dealloc
{
	[userLogin autorelease];
	[super dealloc];
}

@end
