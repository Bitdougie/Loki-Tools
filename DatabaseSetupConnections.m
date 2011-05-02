//
//  DatabaseSetupConnections.m
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


#import "DatabaseSetupConnections.h"
#import "ErrorMessageViewController.h"

@implementation DatabaseSetupConnections

@synthesize conn;

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

-(NSString *) escapedSQLQuery: (NSString *) rawQuery
{
	char *rawCharQuery;
	char *charSQLEscapedString;
	unsigned int ESLength;
	NSString *sQLEscapedString;
	
	rawCharQuery = (char*)xmalloc(sizeof([rawQuery UTF8String]));
	ESLength = (2 * [rawQuery length] +1);
	charSQLEscapedString = (char*)xmalloc(sizeof(char [ESLength]));
	
	(void)strcpy(charSQLEscapedString,[rawQuery UTF8String]);
	
	mysql_real_escape_string(conn, charSQLEscapedString, rawCharQuery, [rawQuery length]);
	
	sQLEscapedString =[[NSString alloc] initWithUTF8String: charSQLEscapedString];
	
	[sQLEscapedString autorelease];
	
	return sQLEscapedString;
}

-(void)dealloc
{
	[userLogin autorelease];
	[super dealloc];
}

@end
