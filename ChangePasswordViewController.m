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
#import "ErrorMessageViewController.h"


@implementation ChangePasswordViewController

-(ChangePasswordViewController *)initWithUser:(User *) userObject
{
	self = [super init];
	
	if (self) {
		userLogin = userObject;
		[userLogin retain];
		nibLoaded = FALSE;
	}
	return self;
}

-(void)openChangePassword
{
	if([changePasswordWindow isVisible])
	{
		[changePasswordWindow orderFront:@"[ChangePasswordViewController openChangePassword]"];
	}
	else {
		if (nibLoaded) {
			[changePasswordWindow setIsVisible:TRUE];
		}
		else {
			if (![NSBundle loadNibNamed:@"ChangePasswordViewController" owner: self]) {
				ErrorMessageViewController *error;
				error = [[ErrorMessageViewController alloc]init];
				[error openErrorMessage:@"ChangePassword:openChangePassword" withMessage:@"Could not load ChangePasswordViewController.xib"];
				[error setErrorNo:1];
			}
			else {
				nibLoaded = TRUE;
			}
		}
		
	}
}

-(IBAction)changePassword: (id) sender
{
	NSString *errorMessage;
	NSString *escapedpassword;
	NSMutableString *sQLPasswordQuery;
	char *charSQLPasswordQuery;
	
	sQLPasswordQuery = [[NSMutableString alloc]init];
	
	//compare strings first
	if (NSOrderedSame == [[newPassword stringValue] compare:[retypedNewPassword stringValue]]) {
	
		//change passwords if both inputs are the same
	
		DatabaseSetupConnections *connection;
		connection = [DatabaseSetupConnections alloc]; 
		[connection initWithUser:userLogin];
		
		if ([connection connectDatabase]) {
			// connection error handler
			ErrorMessageViewController *error;
			error = [[ErrorMessageViewController alloc]init];
			[error openErrorMessage:@"ChangePasswordViewController:changePassword" withMessage:@"Failed to connect to database"];
			[error setErrorNo:0];
			[connection release];
			[error autorelease];
			return;
		};
		
		escapedpassword = [connection escapedSQLQuery:[newPassword stringValue]];		
		[escapedpassword retain];
		
		//Build query
		
		[sQLPasswordQuery setString:@"SET PASSWORD FOR '"];
		[sQLPasswordQuery appendString:[userLogin userName]];
		[sQLPasswordQuery appendString:@"'@'"];
		
		if ([userLogin hostName] == NULL) {
			[sQLPasswordQuery appendString:@"localhost"];
		}
		else {
			[sQLPasswordQuery appendString:[userLogin hostName]];
		}
		
		[sQLPasswordQuery appendString:@"' IDENTIFIED BY '"];
		[sQLPasswordQuery appendString:escapedpassword];
		[sQLPasswordQuery appendString:@"';"];
		
		charSQLPasswordQuery = (char*)xmalloc(sizeof([sQLPasswordQuery length]));
		
		(void)strcpy(charSQLPasswordQuery,[sQLPasswordQuery UTF8String]);
		
		if (mysql_query([connection conn], charSQLPasswordQuery) != 0) {
			//error report
			ErrorMessageViewController *errorPassword;
			errorMessage = [[NSString alloc]initWithUTF8String: mysql_error([connection conn])];
			errorPassword = [[ErrorMessageViewController alloc]init];
			
			[errorPassword openErrorMessage:@"ChangePasswordViewController:changePassword" withMessage: errorMessage];
			[errorPassword setErrorNo:0];
			
			[escapedpassword autorelease];
			[connection release];
			return;
		}
		
		[connection disconnectDatabase];
		[changePasswordWindow setIsVisible:FALSE];
		
		[escapedpassword autorelease];
		[connection release];
	}
	else {
		ErrorMessageViewController *errorDifferentPassword;
		[errorDifferentPassword openErrorMessage:@"ChangepasswordViewController:changePassword" withMessage: @"New password not typed the same"];
		[errorDifferentPassword setErrorNo:0];		
		[errorDifferentPassword autorelease];
	}

}

-(void)dealloc
{
	[userLogin autorelease];
	[super dealloc];
}

@end
