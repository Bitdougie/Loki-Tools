//
//  ChangePasswordViewController.m
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
 */


#import "ChangePasswordViewController.h"
#import "DatabaseSetupConnections.h"

@implementation ChangePasswordViewController

@synthesize newPassword, retypedNewPassword, changePasswordWindow;

-(ChangePasswordViewController *)initWithUser:(User *) userObject
{
	self = [super init];
	
	if (self) {
		userLogin = userObject;
		[userLogin retain];
		nibLoaded = FALSE;
		error = [[ErrorMessageViewController alloc]init];
	}
	return self;
}

-(IBAction)changePassword: (id) sender
{
	NSString *escapedpassword;
	NSMutableString *sQLPasswordQuery;
	char *charSQLPasswordQuery;
	NSString *password;
	NSString *errorMessage;
	
	sQLPasswordQuery = [[NSMutableString alloc]init];
	password = [[NSString alloc] initWithString:[newPassword stringValue]];
	
	if (NSOrderedSame == [[newPassword stringValue] compare:[retypedNewPassword stringValue]]) {
		DatabaseSetupConnections *connection;
		connection = [DatabaseSetupConnections alloc] ;
		[connection initWithUser:userLogin];
		
		if([connection connectDatabase]){
			[error openErrorMessage:@"ChangePasswordViewController:changePassword" withMessage:@"Failed to connect to database"];
			[error setErrorNo:0];
			return;
		}
		
		escapedpassword = [connection escapedSQLQuery:password];		
		[escapedpassword retain];
		
		[sQLPasswordQuery setString:@"SET PASSWORD FOR '"];
		[sQLPasswordQuery appendString:[userLogin userName]];
		[sQLPasswordQuery appendString:@"'@'"];
		
		if ([userLogin hostName] == NULL) {
			[sQLPasswordQuery appendString:@"localhost"];
		}
		else {
			[sQLPasswordQuery appendString:[userLogin hostName]];
		}
		
		[sQLPasswordQuery appendString:@"' = PASSWORD('"];
		[sQLPasswordQuery appendString:escapedpassword];
		[sQLPasswordQuery appendString:@"');"];
		
		charSQLPasswordQuery = (char*)xmalloc(sizeof(char [[sQLPasswordQuery length]]));
		
		(void)strcpy(charSQLPasswordQuery,[sQLPasswordQuery UTF8String]);
		
		if (mysql_query([connection conn], charSQLPasswordQuery) != 0) {
			errorMessage = [[NSString alloc] initWithUTF8String: mysql_error([connection conn])];
			[error openErrorMessage:@"ChangePasswordViewController:changePassword" withMessage: errorMessage];
			[error setErrorNo:0];
			
			[errorMessage release];
			[connection disconnectDatabase];
			free(charSQLPasswordQuery);
			[escapedpassword release];
			[connection release];
			[changePasswordWindow close];
			[sQLPasswordQuery release];
			[password release];
			return;
		}
		
		[userLogin setPassword: password];
		
		[connection disconnectDatabase];
		free(charSQLPasswordQuery);
		[escapedpassword release];
		[connection release];
		[changePasswordWindow close];
	}
	else {
		[error openErrorMessage:@"ChangepasswordViewController:changePassword" withMessage: @"New password not typed the same"];
		[error setErrorNo:0];
	}
	
	[sQLPasswordQuery release];
	[password release];
}

-(void)dealloc
{
	[error release];
	[userLogin release];
	[super dealloc];
}

@end
