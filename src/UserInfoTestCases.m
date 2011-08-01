//
//  UserInfoTestCases.m
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

#import "UserInfoTestCases.h"
#import "Host.h"
#import "UserInfo.h"
#import "lokierr.h"

@implementation UserInfoTestCases

-(void)testInitialisation
{
	@try {
		/*
		 Depending on the configuration of your MySQL server these hard coded
		 testing perameters will need to be changed to suit your set up.
		 */
		
		NSString *testTitle = @"Home Computer";
		NSString *testHostName = NULL;
		unsigned int testPortNumber = 0;
		NSString *testSocketName = NULL;
		unsigned int testFlags = 0;
		NSString *testPassword = @"secret";
		NSString *testUserName = @"doug";
		
		/*
		 Code set for error catching tests
		 */
		
		NSString *dummyHostName = @"www.wrongserver.wrong";
		NSString *dummyPassword = @"wrong password";
		NSString *dummyUserName = @"wrong userName";
		NSString *dummySocketName = @"wrong socket";
		/* Test code that does not need configuration from here on */
		
		Host *testHost;
		NSError *error ,*error_2, *error_3, *error_4, *error_5;
		
		testHost = [[Host alloc]init];
		[testHost setTitle:testTitle];
		[testHost setHostName:testHostName];
		[testHost setPortNumber:testPortNumber];
		[testHost setSocketName:testSocketName];
		[testHost setFlags:testFlags];
		
		STAssertTrue([UserInfo initWithHost:testHost andUserName:testUserName andPassword:testPassword andError:&error],\
					 @"Expected login would succeed but failed with error code: %i \n Reason: %@",[error code],[error localizedDescription]);
		
		[testHost setHostName:dummyHostName];
		
		if (![UserInfo initWithHost:testHost andUserName:testUserName andPassword: testPassword andError:&error_2]) {
			STAssertTrue([error_2 code] == CR_UNKNOWN_HOST ,@"Expected to return failure due to unknown host error code but returned %i \n Reason: %@",\
						 [error_2 code],[error localizedDescription]);
		}
		else {
			STAssertTrue(FALSE,@"Expected failure from initWithHost in UserInfo with unknown host error");
		}
		
		[testHost setHostName:testHostName];
		
		if (![UserInfo initWithHost:testHost andUserName:testUserName andPassword:dummyPassword andError:&error_3]) {
			STAssertTrue([error_3 code] == ER_ACCESS_DENIED_ERROR,@"Expected to return failure due to wrong password but returned %i \n Reason: %@",\
						 [error_3 code],[error localizedDescription]);
		}
		else {
			STAssertTrue(FALSE,@"Expected failure from initWithHost in UserInfo with wrong password");
		}
		
		if (![UserInfo initWithHost:testHost andUserName:dummyUserName andPassword:testPassword andError:&error_4]) {
			STAssertTrue([error_4 code] == ER_ACCESS_DENIED_ERROR,@"Expected to return failure due to wrong userName but returned %i \n Reason: %@",\
						 [error_4 code],[error localizedDescription]);
		}
		else {
			STAssertTrue(FALSE,@"Expected failure from initWithHost in UserInfo with wrong userName");
		}

		[testHost setSocketName:dummySocketName];
		
		if (![UserInfo initWithHost:testHost andUserName:testUserName andPassword:testPassword andError:&error_5]) {
			STAssertTrue([error_5 code] == CR_CONNECTION_ERROR,@"Expected to return failure due to wrong socketName but returned %i \n Reason: %@",\
						 [error_5 code],[error_5 localizedDescription]);
		}
		else {
			STAssertTrue(FALSE,@"Expected failure from initWithHost in UserInfo with wrong socketName");
		}
		
		[testHost setSocketName:testSocketName];
		
		[testHost release];
	}
	@catch (NSException * e) {
		NSLog(@"Exception occured in: %@", NSStringFromClass([self class]));
		NSLog(@"Method: %@",[e name]);
		NSLog(@"Line: %i at Function: %s",__LINE__, __PRETTY_FUNCTION__);
		NSLog(@"Reason: %@",[e reason]);
	}
}

-(void)testConnection
{
	@try {
		
		/*
			These  parameters will need to me changed to produce a valid login
		 */
		
		NSString *testTitle = @"Home Computer";
		NSString *testHostName = NULL;
		unsigned int testPortNumber = 0;
		NSString *testSocketName = NULL;
		unsigned int testFlags = 0;
		NSString *testPassword = @"secret";
		NSString *testUserName = @"doug";
		
		//***************************************
		
		Host *testHost;
		NSError *error, *error_2, *error_3;
		
		testHost = [[Host alloc]init];
		[testHost setTitle:testTitle];
		[testHost setHostName:testHostName];
		[testHost setPortNumber:testPortNumber];
		[testHost setSocketName:testSocketName];
		[testHost setFlags:testFlags];
		
		MYSQL *connection, *connection_2;
		
		STAssertTrue([UserInfo initWithHost:testHost andUserName:testUserName andPassword:testPassword andError:&error],\
					 @"Expected login would succeed but failed with error code: %i \n Reason: %@",[error code],[error localizedDescription]);
		
		STAssertTrue([UserInfo numberOfConnections] == 0,@"Expected number of connections to equal zero but got: %i",[UserInfo numberOfConnections]);
		
		connection = [UserInfo openConnection:&error_2];
		
		if (connection == NULL) {
			NSAlert *theAlert = [NSAlert alertWithError:error_2];
			[theAlert runModal];
		}
		
		STAssertTrue([UserInfo numberOfConnections] == 1,@"Expected number of connections to equal one but got: %i",[UserInfo numberOfConnections]);
		
		connection_2 = [UserInfo openConnection:&error_3];
		
		if (connection_2 == NULL) {
			NSAlert *theAlert = [NSAlert alertWithError:error_3];
			[theAlert runModal];
		}
		
		STAssertTrue([UserInfo numberOfConnections] == 2,@"Expected number of connections to equal two but got: %i",[UserInfo numberOfConnections]);
		
		[UserInfo closeConnection:connection];
		
		STAssertTrue([UserInfo numberOfConnections] == 1,@"Expected number of connections to equal one but got: %i",[UserInfo numberOfConnections]);
		
		[UserInfo closeConnection:connection_2];
		
		STAssertTrue([UserInfo numberOfConnections] == 0,@"Expected number of connections to equal one but got: %i",[UserInfo numberOfConnections]);
		
		STAssertTrue([[UserInfo userName] isEqualToString:testUserName],@"Expected [UserInfo userName] == testUserName");
		
		STAssertTrue([[UserInfo title] isEqualToString:[testHost title]],@"Expected [UserInfo title] == [testHost title]");
		
		[testHost release];
		
	}
	@catch (NSException * e) {
		NSLog(@"Exception occured in: %@", NSStringFromClass([self class]));
		NSLog(@"Method: %@",[e name]);
		NSLog(@"Line: %i at Function: %s",__LINE__, __PRETTY_FUNCTION__);
		NSLog(@"Reason: %@",[e reason]);
	}
}

@end
