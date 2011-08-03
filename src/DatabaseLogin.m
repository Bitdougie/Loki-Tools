//
//  DatabaseLogin.m
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

#import "DatabaseLogin.h"
#import "lokierr.h"
#import "xLokiProcedures.h"

static NSString *database;
static NSString *userName;
static NSString *password;
static Host *currentHost;
static BOOL validDatabaseLogin = FALSE;
static int numberOfConnections = 0;

@implementation DatabaseLogin


+(BOOL)initWithHost:(Host *) host andUserName:(NSString *) user andPassword:(NSString *) passPhrase andDatabase:(NSString *) databaseName error:(NSError **)anError;
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
		
		if (database == nil) {
			database = databaseName;
			[database retain];
		}
		else {
			[database release];
			database = databaseName;
			[database retain];
		}
		
		char *userNameChar;
		char *passwordChar;
		char *hostNameChar;
		char *socketNameChar;
		char *databaseChar;
		
		userNameChar = copyObjectString(userName);
		passwordChar = copyObjectString(password);
		hostNameChar = copyObjectString([currentHost hostName]);
		socketNameChar = copyObjectString([currentHost socketName]);
		databaseChar = copyObjectString(database);
		
		if (![UserInfo initWithHost:host andUserName:user andPassword:passPhrase andError:anError])
		{
			xfree(userNameChar);
			xfree(passwordChar);
			xfree(hostNameChar);
			xfree(socketNameChar);
			xfree(databaseChar);
			
			validDatabaseLogin = FALSE;
			return FALSE;
		}
		
		
		if ([super TotalConnections] == 0) {
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
				xfree(databaseChar);
				
				validDatabaseLogin = FALSE;
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
			xfree(databaseChar);
			
			if ([super TotalConnections] == 0) {
				mysql_library_end();
			}
			
			validDatabaseLogin = FALSE;
			return FALSE;
		}
		
		if (!mysql_real_connect(conn, hostNameChar, userNameChar, passwordChar, databaseChar, [currentHost portNumber], socketNameChar, [currentHost flags])) {
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
			xfree(databaseChar);
			
			if ([super TotalConnections] == 0) {
				mysql_library_end();
			}
			
			validDatabaseLogin = FALSE;
			return FALSE;
		}
		
		numberOfConnections++;
		mysql_close(conn);
		numberOfConnections--;
		
		xfree(userNameChar);
		xfree(passwordChar);
		xfree(hostNameChar);
		xfree(socketNameChar);
		xfree(databaseChar);
		
		if ([super TotalConnections] == 0) {
			mysql_library_end();
		}
		
		validDatabaseLogin = TRUE;
		return TRUE;
	}
	@catch (NSException * e) {
		NSLog(@"Exception occured in: %@", NSStringFromClass([self class]));
		NSLog(@"Method: %@",[e name]);
		NSLog(@"Line: %i at Function: %s",__LINE__, __PRETTY_FUNCTION__);
		NSLog(@"Reason: %@",[e reason]);
	}
	validDatabaseLogin = FALSE;
	return FALSE;
}

+(MYSQL *)openConnection:(NSError **) anError
{
	@try {
		if (validDatabaseLogin) {
			
			char *userNameChar;
			char *passwordChar;
			char *hostNameChar;
			char *socketNameChar;
			char *databaseChar;
			
			userNameChar = copyObjectString(userName);
			passwordChar = copyObjectString(password);
			hostNameChar = copyObjectString([currentHost hostName]);
			socketNameChar = copyObjectString([currentHost socketName]);
			databaseChar = copyObjectString(database);
			
			if ([super TotalConnections] == 0) {
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
					xfree(databaseChar);
					
					validDatabaseLogin = FALSE;
					return NULL;
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
				xfree(databaseChar);
				
				if ([super TotalConnections] == 0) {
					mysql_library_end();
				}
				
				validDatabaseLogin = FALSE;
				return NULL;
			}
			
			if (!mysql_real_connect(conn, hostNameChar, userNameChar, passwordChar, databaseChar, [currentHost portNumber], socketNameChar, [currentHost flags])) {
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
				xfree(databaseChar);
				
				if ([super TotalConnections] == 0) {
					mysql_library_end();
				}
				
				validDatabaseLogin = FALSE;
				return FALSE;
			}
			
			numberOfConnections++;
			validDatabaseLogin = TRUE;
			return conn;
		}
		validDatabaseLogin = FALSE;
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
		
		if ([self TotalConnections] == 0) {
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
