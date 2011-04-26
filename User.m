//
//  User.m
//  Loki_Tools
//
//  Created by Douglas Mason on 11/04/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

#import "User.h"


@implementation User

@synthesize hostName, userName, password, portNumber, socketName, databaseName, flags, validLogin;

-(User *) init
{
	self = [super init];
	
	if (self) {
		[self setHostName: NULL];
		[self setUserName:@"root"];
		[self setPassword:NULL];
		[self setPortNumber:0];
		[self setSocketName:NULL];
		[self setDatabaseName:NULL];
		[self setFlags:0];
		[self setValidLogin: FALSE];
	}
	
	return self;
}

@end
