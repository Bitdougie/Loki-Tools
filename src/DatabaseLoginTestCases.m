//
//  DatabaseLoginTestCases.m
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

#import "DatabaseLoginTestCases.h"
#import "DatabaseLogin.h"
#import "testInformation.h"
#import "Host.h"


@implementation DatabaseLoginTestCases

-(void)testInitisation
{	
	Host *testHost;
	
	NSError *error, *error_2;
	
	testHost = [[Host alloc]init];
	[testHost setTitle:HOST_COMPUTER_TITLE];
	[testHost setHostName:HOST_COMPUTER_NAME];
	[testHost setPortNumber:HOST_COMPUTER_PORT_NUMBER];
	[testHost setSocketName:HOST_COMPUTER_SOCKET_NAME];
	[testHost setFlags:HOST_COMPUTER_FLAGS];
	
	STAssertTrue([DatabaseLogin initWithHost:testHost andUserName:HOST_COMPUTER_USER andPassword:HOST_COMPUTER_PASSWORD andDatabase:HOST_COMPUTER_DATABASE error:&error],\
				 @"DatabaseLogin init was meant to be true but returned false \n Reason: %@",[error localizedDescription]);
	
	STAssertFalse([DatabaseLogin initWithHost:testHost andUserName:HOST_COMPUTER_USER andPassword:HOST_COMPUTER_PASSWORD andDatabase:HOST_FALSE_DATABASE error:&error_2],\
				  @"DatabaseLogin init was meant to fail with fake database: %@",HOST_FALSE_DATABASE);
	
	[testHost release];
}

-(void)testOpenConnection
{
	Host *testHost;
	
	NSError *error, *error_2;
	
	MYSQL *connection;
	
	testHost = [[Host alloc]init];
	[testHost setTitle:HOST_COMPUTER_TITLE];
	[testHost setHostName:HOST_COMPUTER_NAME];
	[testHost setPortNumber:HOST_COMPUTER_PORT_NUMBER];
	[testHost setSocketName:HOST_COMPUTER_SOCKET_NAME];
	[testHost setFlags:HOST_COMPUTER_FLAGS];
	
	if (![DatabaseLogin initWithHost:testHost andUserName:HOST_COMPUTER_USER andPassword:HOST_COMPUTER_PASSWORD andDatabase:HOST_COMPUTER_DATABASE error:&error]) {
		NSAlert *theAlert = [NSAlert alertWithError:error];
		[theAlert runModal];
	}
	
	STAssertTrue([DatabaseLogin TotalConnections] == 0,@"Expected number of connections to == 1 but got: %i",[DatabaseLogin TotalConnections]);
	
	connection = [DatabaseLogin openConnection:&error_2];
	
	STAssertTrue(NULL != connection ,@"Expected the MYSQL *connection to be initialised but is NULL because of \n Reason: %@",[error_2 localizedDescription]);
	
	STAssertTrue([DatabaseLogin TotalConnections] == 1,@"Expected number of connections to == 1 but got: %i",[DatabaseLogin TotalConnections]);
	
	STAssertTrue([DatabaseLogin TotalConnections] == [DatabaseLogin numberOfConnections],@"Expected number of connections to be equal but numberOfConnections = %i and the Total number = % i",\
				 [DatabaseLogin numberOfConnections],[DatabaseLogin TotalConnections]);
	
	[DatabaseLogin closeConnection:connection];
	
	[testHost release];
}

@end
