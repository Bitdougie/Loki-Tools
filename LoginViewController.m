//
//  LoginViewController.m
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

#import "LoginViewController.h"



@implementation LoginViewController

-(LoginViewController *)initWithUser: (User *) userObject andMainProgram: (Loki_ToolsAppDelegate *) mainAppObject
{
	self = [super init];
	
	if(self){
		userLogin = userObject;
		mainProgram = mainAppObject;
		[userLogin retain];
		[mainProgram retain];
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
	[mainProgram autorelease];
	[super dealloc];
}

@end
