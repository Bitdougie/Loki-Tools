//
//  DatabaseSetupConnections.m
//  Loki_Tools
//
//  Created by Douglas Mason on 11/02/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

#import "DatabaseSetupConnections.h"
#import "ErrorMessageViewController.h"

@implementation DatabaseSetupConnections

-(DatabaseSetupConnections *) initWithUser: (User *) userObject
{
	self = [super init];
	
	if (self) {
		userLogin = userObject;
		[userLogin retain];
	}
	
	return self;
}

-(int)connectDatabase
{
	//allocate memory for temperary variables for strcpy function
	
	char * hostNameCopy;
	char * userNameCopy;
	char * passwordCopy;
	char * socketNameCopy;
	char * databaseNameCopy;
	NSString *errorMessage;
	ErrorMessageViewController *view;
	
	view = [[ErrorMessageViewController alloc]init];
	
	if ([[userLogin hostName] UTF8String] == NULL) {
		hostNameCopy = NULL;
	}
	else {
		hostNameCopy = (char *)xmalloc(sizeof([[userLogin hostName] UTF8String]));
		(void)strcpy(hostNameCopy,[[userLogin hostName] UTF8String]);
	}
	
	if ([[userLogin userName] UTF8String] == NULL) {
		userNameCopy = NULL;
	}
	else {
		userNameCopy = (char *)xmalloc(sizeof([[userLogin userName] UTF8String]));
		(void)strcpy(userNameCopy,[[userLogin userName] UTF8String]);
	}
	
	if ([[userLogin password] UTF8String] == NULL) {
		passwordCopy = NULL;
	}
	else {
		passwordCopy = (char *)xmalloc(sizeof([[userLogin password] UTF8String]));
		(void)strcpy(passwordCopy,[[userLogin password] UTF8String]);
	}

	if([[userLogin socketName] UTF8String] == NULL) {
		socketNameCopy = NULL;
	}
	else {
		socketNameCopy = (char *)xmalloc(sizeof([[userLogin socketName] UTF8String]));
		(void)strcpy(socketNameCopy,[[userLogin socketName] UTF8String]);
	}

	if([[userLogin databaseName] UTF8String] == NULL) {
		databaseNameCopy = NULL;
	}
	else {
		databaseNameCopy = (char *)xmalloc(sizeof([[userLogin databaseName] UTF8String]));
		(void)strcpy(databaseNameCopy,[[userLogin databaseName ] UTF8String]);
	}
	
	if (mysql_library_init(0,NULL,NULL)) {
		errorMessage = @"Could not connect/initialise MYSQL Library";
		[view openErrorMessage:@"Database Setup Connections" withMessage:errorMessage];
		[view setErrorNo:1];
		free(hostNameCopy);
		free(userNameCopy);
		free(passwordCopy);
		free(socketNameCopy);
		free(databaseNameCopy);
		return 1;
	}
	
	conn = mysql_init(NULL);
	
	if(conn == NULL)
	{
		errorMessage = @"Not enough memory to initalise MYSQL connection";
		[view openErrorMessage:@"Database Setup Connections" withMessage:errorMessage];
		[view setErrorNo:1];
		free(hostNameCopy);
		free(userNameCopy);
		free(passwordCopy);
		free(socketNameCopy);
		free(databaseNameCopy);
		return 1;
	}
	
	if(!mysql_real_connect(conn, hostNameCopy,userNameCopy,passwordCopy,databaseNameCopy,[userLogin portNumber],socketNameCopy,[userLogin flags]))
	{
		errorMessage = [[NSString alloc] initWithUTF8String: mysql_error(conn)];
		[view openErrorMessage:@"Database Setup Connections" withMessage:errorMessage];
		[view setErrorNo:0];
		free(hostNameCopy);
		free(userNameCopy);
		free(passwordCopy);
		free(socketNameCopy);
		free(databaseNameCopy);
		[errorMessage autorelease];
		return 1;
	}

	free(hostNameCopy);
	free(userNameCopy);
	free(passwordCopy);
	free(socketNameCopy);
	free(databaseNameCopy);
	
	return 0;
}

-(void)disconnectDatabase
{
	mysql_close(conn);
	mysql_library_end();
}

-(void)dealloc
{
	[userLogin autorelease];
	[super dealloc];
}

@end
