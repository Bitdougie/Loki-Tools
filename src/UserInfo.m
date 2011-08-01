//
//  UserInfo.m
//  Loki_Tools
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

#import "UserInfo.h"
#import <my_global.h>
#import <my_sys.h>
#import <mysql.h>
#import "xLokiProcedures.h"
#import "lokierr.h"

static NSString *userName;
static NSString *password;
static Host *currentHost;
static BOOL validLogin = FALSE;
static int numberOfConnections = 0;

char * copyObjectString(NSString *object);

@implementation UserInfo

+(BOOL)initWithHost:(Host *) host andUserName:(NSString *) user andPassword:(NSString *) passPhrase andError:(NSError **)anError
{
	@try {
		/*
			Assigning all the structures to the class memory
		 */
		
		if (currentHost == nil) {
			currentHost = host;
			[currentHost retain];
		}
		else {
			[currentHost release];
			currentHost = host;
			[currentHost retain];
		}
		
		if (userName == nil) {
			userName = user;
			[userName retain];
		}
		else {
			[userName release];
			userName = user;
			[userName retain];
		}
		
		if (password == nil) {
			password = passPhrase;
			[password retain];
		}
		else {
			[password release];
			password = passPhrase;
			[password retain];
		}
		
		/*
		 Converting objective-c data types to C data types for use
		 in the mysql procedure calls.
		 */
		
		char *userNameChar;
		char *passwordChar;
		char *hostNameChar;
		char *socketNameChar;
		
		userNameChar = copyObjectString(userName);
		passwordChar = copyObjectString(password);
		hostNameChar = copyObjectString([currentHost hostName]);
		socketNameChar = copyObjectString([currentHost socketName]);
		
		if (numberOfConnections == 0) {
			if (mysql_library_init(0,NULL,NULL)) {
				if (anError != nil) {
					NSString *description = nil; 
					int errCode;
					
					NSString *message = [[NSString alloc]initWithFormat:@"An unknown error has occured in mysql_library_init() with errno: %i",errno];
					description = NSLocalizedString(message,@"");
					errCode = LTUKE;
					[message release];
					// Make underlying error.
					NSError *underlyingError = [[[NSError alloc] initWithDomain:NSPOSIXErrorDomain
																		   code:errno userInfo:nil] autorelease];
					// Make and return custom domain error.
					NSArray *objArray = [NSArray arrayWithObjects:description, underlyingError, @"", nil];
					
					NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,
										 NSUnderlyingErrorKey, NSFilePathErrorKey, nil];
					NSDictionary *eDict = [NSDictionary dictionaryWithObjects:objArray
																	  forKeys:keyArray];
					
					*anError = [[[NSError alloc] initWithDomain:LokiTools
														   code:errCode userInfo:eDict] autorelease];
				}
				
				xfree(userNameChar);
				xfree(passwordChar);
				xfree(hostNameChar);
				xfree(socketNameChar);
				
				validLogin = FALSE;
				return FALSE;
			}
		}

		MYSQL *conn;
		
		conn = mysql_init(NULL);
		
		if (conn == NULL) {
			if (anError != nil) {
				NSString *description = nil;
				int errCode;
				errCode = mysql_errno(conn);
				
				NSMutableString *message = [[NSMutableString alloc]initWithUTF8String:mysql_error(conn)];
				[message appendFormat:@" \n ** ERROR NO: %i **",errCode];
				description = NSLocalizedString(message,@"");
				[message release];
				
				// Make underlying error.
				NSError *underlyingError = [[[NSError alloc] initWithDomain:NSPOSIXErrorDomain
																	   code:errno userInfo:nil] autorelease];
				// Make and return custom domain error.
				NSArray *objArray = [NSArray arrayWithObjects:description, underlyingError, @"", nil];
				
				NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,
									 NSUnderlyingErrorKey, NSFilePathErrorKey, nil];
				NSDictionary *eDict = [NSDictionary dictionaryWithObjects:objArray
																  forKeys:keyArray];
				
				*anError = [[[NSError alloc] initWithDomain:LokiTools
													   code:errCode userInfo:eDict] autorelease];
			}
			
			xfree(userNameChar);
			xfree(passwordChar);
			xfree(hostNameChar);
			xfree(socketNameChar);
			
			validLogin = FALSE;
			return FALSE;
		}
		
		if (!mysql_real_connect(conn, hostNameChar, userNameChar, passwordChar, NULL, [currentHost portNumber], socketNameChar, [currentHost flags])) {
			if (anError != nil) {
				NSString *description = nil;
				int errCode;
				errCode = mysql_errno(conn);
				
				switch (errCode) {
					case ER_ACCESS_DENIED_ERROR:
						description = NSLocalizedString(@"UserName or Password is incorrect",@"");
						break;
					case CR_UNKNOWN_HOST:
						description = NSLocalizedString(@"Unknown Host",@"");
						break;
					case CR_CONNECTION_ERROR:
						description = NSLocalizedString(@"The socket specified does not exist",@"");
						break;
					default:;
						NSMutableString *message = [[NSMutableString alloc]initWithUTF8String:mysql_error(conn)];
						[message appendFormat:@" \n ** ERROR NO: %i **",errCode];
						description = NSLocalizedString(message,@"");
						[message release];
						break;
				}
				
				// Make underlying error.
				NSError *underlyingError = [[[NSError alloc] initWithDomain:NSPOSIXErrorDomain
																	   code:errno userInfo:nil] autorelease];
				// Make and return custom domain error.
				NSArray *objArray = [NSArray arrayWithObjects:description, underlyingError, @"", nil];
				
				NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,
									 NSUnderlyingErrorKey, NSFilePathErrorKey, nil];
				NSDictionary *eDict = [NSDictionary dictionaryWithObjects:objArray
																  forKeys:keyArray];
				
				*anError = [[[NSError alloc] initWithDomain:LokiTools
													   code:errCode userInfo:eDict] autorelease];

			}
			
			xfree(userNameChar);
			xfree(passwordChar);
			xfree(hostNameChar);
			xfree(socketNameChar);
			
			validLogin = FALSE;
			return FALSE;
		}
		numberOfConnections++;
		mysql_close(conn);
		numberOfConnections--;
		
		if (numberOfConnections == 0) {
			mysql_library_end();
		}
		
		xfree(userNameChar);
		xfree(passwordChar);
		xfree(hostNameChar);
		xfree(socketNameChar);
		
		validLogin = TRUE;
		return TRUE;
	}
	@catch (NSException * e) {
		NSLog(@"Exception occured in: %@", NSStringFromClass([self class]));
		NSLog(@"Method: %@",[e name]);
		NSLog(@"Line: %i at Function: %s",__LINE__, __PRETTY_FUNCTION__);
		NSLog(@"Reason: %@",[e reason]);
	}
	@finally {
		
	}
	validLogin = FALSE;
	return FALSE;
}

char * copyObjectString(NSString *object)
{
	@try {
		char *charChar;
		
		if (object != NULL) {
			charChar = (char *)xmalloc(sizeof([object UTF8String]));
			(void)strcpy(charChar,[object UTF8String]);
			return charChar;
		}
		
		return NULL;
	}
	@catch (NSException * e) {
		NSLog(@"Method: %@",[e name]);
		NSLog(@"Line: %i at Function: %s",__LINE__, __PRETTY_FUNCTION__);
		NSLog(@"Reason: %@",[e reason]);
	}
	return NULL;
}

+(NSString *)userName
{
	@try {
		if (validLogin) {
			NSString *userNameCopy;
			userNameCopy = [[[NSString alloc]initWithString:userName]autorelease];
			return userNameCopy;
		}
		
		return nil;
	}
	@catch (NSException * e) {
		NSLog(@"Exception occured in: %@", NSStringFromClass([self class]));
		NSLog(@"Method: %@",[e name]);
		NSLog(@"Line: %i at Function: %s",__LINE__, __PRETTY_FUNCTION__);
		NSLog(@"Reason: %@",[e reason]);
	}
	return nil;
}

+(NSString *)title
{
	@try {
		if (validLogin) {
			NSString *titleCopy;
			titleCopy = [[[NSString alloc]initWithString:[currentHost title]]autorelease];
			return titleCopy;
		}
		return nil;
	}
	@catch (NSException * e) {
		NSLog(@"Exception occured in: %@", NSStringFromClass([self class]));
		NSLog(@"Method: %@",[e name]);
		NSLog(@"Line: %i at Function: %s",__LINE__, __PRETTY_FUNCTION__);
		NSLog(@"Reason: %@",[e reason]);
	}
	return nil;
}

+(MYSQL *)openConnection:(NSError **)anError
{
	@try {
		if (validLogin) {
			
			if (numberOfConnections == 0) {
				if (mysql_library_init(0,NULL,NULL)) {
					if (anError != nil) {
						NSString *description = nil; 
						int errCode;
						
						NSString *message = [[NSString alloc]initWithFormat:@"An unknown error has occured in mysql_library_init() with errno: %i",errno];
						description = NSLocalizedString(message,@"");
						errCode = LTUKE;
						[message release];
						// Make underlying error.
						NSError *underlyingError = [[[NSError alloc] initWithDomain:NSPOSIXErrorDomain
																			   code:errno userInfo:nil] autorelease];
						// Make and return custom domain error.
						NSArray *objArray = [NSArray arrayWithObjects:description, underlyingError, @"", nil];
						
						NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,
											 NSUnderlyingErrorKey, NSFilePathErrorKey, nil];
						NSDictionary *eDict = [NSDictionary dictionaryWithObjects:objArray
																		  forKeys:keyArray];
						
						*anError = [[[NSError alloc] initWithDomain:LokiTools
															   code:errCode userInfo:eDict] autorelease];
					}
					return NULL;
				}
			}
			
			MYSQL *connection;
			
			connection = mysql_init(NULL);
			
			
			if (connection == NULL) {
				if (anError != nil) {
					NSString *description = nil;
					int errCode;
					errCode = mysql_errno(connection);
					
					NSMutableString *message = [[NSMutableString alloc]initWithUTF8String:mysql_error(connection)];
					[message appendFormat:@" \n ** ERROR NO: %i **",errCode];
					description = NSLocalizedString(message,@"");
					[message release];
					
					// Make underlying error.
					NSError *underlyingError = [[[NSError alloc] initWithDomain:NSPOSIXErrorDomain
																		   code:errno userInfo:nil] autorelease];
					// Make and return custom domain error.
					NSArray *objArray = [NSArray arrayWithObjects:description, underlyingError, @"", nil];
					
					NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,
										 NSUnderlyingErrorKey, NSFilePathErrorKey, nil];
					NSDictionary *eDict = [NSDictionary dictionaryWithObjects:objArray
																	  forKeys:keyArray];
					
					*anError = [[[NSError alloc] initWithDomain:LokiTools
														   code:errCode userInfo:eDict] autorelease];
				}
				return NULL;
			}
			
			char *userNameChar;
			char *passwordChar;
			char *hostNameChar;
			char *socketNameChar;
			
			userNameChar = copyObjectString(userName);
			passwordChar = copyObjectString(password);
			hostNameChar = copyObjectString([currentHost hostName]);
			socketNameChar = copyObjectString([currentHost socketName]);
			
			if (!mysql_real_connect(connection, hostNameChar, userNameChar, passwordChar, NULL, [currentHost portNumber], socketNameChar, [currentHost flags])) {
				if (anError != nil) {
					NSString *description = nil;
					int errCode;
					errCode = mysql_errno(connection);
					
					switch (errCode) {
						case ER_ACCESS_DENIED_ERROR:
							description = NSLocalizedString(@"UserName or Password is incorrect",@"");
							break;
						case CR_UNKNOWN_HOST:
							description = NSLocalizedString(@"Unknown Host",@"");
							break;
						case CR_CONNECTION_ERROR:
							description = NSLocalizedString(@"The socket specified does not exist",@"");
							break;
						default:;
							NSMutableString *message = [[NSMutableString alloc]initWithUTF8String:mysql_error(connection)];
							[message appendFormat:@" \n ** ERROR NO: %i **",errCode];
							description = NSLocalizedString(message,@"");
							[message release];
							break;
					}
					
					// Make underlying error.
					NSError *underlyingError = [[[NSError alloc] initWithDomain:NSPOSIXErrorDomain
																		   code:errno userInfo:nil] autorelease];
					// Make and return custom domain error.
					NSArray *objArray = [NSArray arrayWithObjects:description, underlyingError, @"", nil];
					
					NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,
										 NSUnderlyingErrorKey, NSFilePathErrorKey, nil];
					NSDictionary *eDict = [NSDictionary dictionaryWithObjects:objArray
																	  forKeys:keyArray];
					
					*anError = [[[NSError alloc] initWithDomain:LokiTools
														   code:errCode userInfo:eDict] autorelease];
					
				}
				
				xfree(userNameChar);
				xfree(passwordChar);
				xfree(hostNameChar);
				xfree(socketNameChar);
				
				validLogin = FALSE;
				return FALSE;
			}
			
			xfree(userNameChar);
			xfree(passwordChar);
			xfree(hostNameChar);
			xfree(socketNameChar);
			
			numberOfConnections++;
			
			return connection;
		}

		return NULL; 
	}
	@catch (NSException * e) {
		NSLog(@"Exception occured in: %@", NSStringFromClass([self class]));
		NSLog(@"Method: %@",[e name]);
		NSLog(@"Line: %i at Function: %s",__LINE__, __PRETTY_FUNCTION__);
		NSLog(@"Reason: %@",[e reason]);
	}
	return NULL;
}

+(void)closeConnection:(MYSQL *)connection
{
	@try {
		numberOfConnections--;
		mysql_close(connection);
		
		if (numberOfConnections == 0) {
			mysql_library_end();
		}
	}
	@catch (NSException * e) {
		NSLog(@"Exception occured in: %@", NSStringFromClass([self class]));
		NSLog(@"Method: %@",[e name]);
		NSLog(@"Line: %i at Function: %s",__LINE__, __PRETTY_FUNCTION__);
		NSLog(@"Reason: %@",[e reason]);
	}
}

+(int)numberOfConnections
{
	@try {
		int result;
		
		result = numberOfConnections;
		
		return result;
	}
	@catch (NSException * e) {
		NSLog(@"Exception occured in: %@", NSStringFromClass([self class]));
		NSLog(@"Method: %@",[e name]);
		NSLog(@"Line: %i at Function: %s",__LINE__, __PRETTY_FUNCTION__);
		NSLog(@"Reason: %@",[e reason]);
	}
	
	return -1;
}

@end
