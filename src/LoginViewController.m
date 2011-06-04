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
#import "ErrorMessageViewController.h"
#import "Loki_ToolsAppDelegate.h"

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

-(IBAction)login: (id) sender;
{
	NSLog(@"login");
	DatabaseSetupConnections *connection;

	connection = [DatabaseSetupConnections alloc];

	[userLogin setUserName:[user stringValue]];
	[userLogin setPassword:[password stringValue]];
	
	[connection initWithUser: userLogin];
	
	if(![connection connectDatabase]){
		[userLogin setValidLogin:TRUE];
		[loginWindow close];
	}
	else {
		[userLogin setValidLogin:FALSE];
	}
	
	[connection disconnectDatabase];
	[connection release];
}

-(void)dealloc
{
	[userLogin release];
	[super dealloc];
}

@end
