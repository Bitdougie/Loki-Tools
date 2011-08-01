//
//  HostArchiverTestCases.m
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

#import "HostArchiverTestCases.h"
#import "HostArchiver.h"
#import "Host.h"

@implementation HostArchiverTestCases

-(void)testGetHosts
{
	NSArray *hostList;
	NSArray *hostListReal;
	NSError *error;
	NSError *error_2;
	NSError *cleanUp;
	NSString *hostFilePath;
	NSString *titleResult = @"localhost";
	HostArchiver *archiver;
	NSFileManager *fileSystem;
	Host *testHost;
	
	archiver = [[HostArchiver alloc]initWithProfile:@"/.LokiConfig"];
	fileSystem = [[NSFileManager alloc]init];
	testHost = [[Host alloc]init];
	[testHost setTitle:@"Home Computer"];
	
	error = nil;
	error_2 = nil;
	
	hostList = [archiver getHosts:&error];
	
	STAssertTrue(error != nil, @"Permission denied to configuration file and error caught expected instead is true");

	[archiver release];
	
	hostFilePath = [@"~/.LokiProfile" stringByExpandingTildeInPath];
	
	archiver = [[HostArchiver alloc]initWithProfile:hostFilePath];
	
	hostListReal = [[archiver getHosts:&error_2]retain];
	
	if (error_2 != nil) {
		NSAlert *theAlert = [NSAlert alertWithError:cleanUp];
		[theAlert runModal];
	}
	
	STAssertTrue([[[hostListReal objectAtIndex:0] title] isEqualToString:titleResult], @"Host list was initialised incorrectly, expected title == localHost got: %@",[[hostListReal objectAtIndex:0] title]);
	
	STAssertTrue([[hostListReal objectAtIndex:0] hostName] == NULL ,@"Host list was initialised incorrectly, expected HostName == NULL got %@",[[hostListReal objectAtIndex:0] hostName]);
	
	STAssertTrue([[hostListReal objectAtIndex:0] portNumber] == 0,@"Host List was initalised incorrectly, expected portNumber == 0 got: %i", [[hostListReal objectAtIndex:0] portNumber]);
	
	STAssertTrue([[hostListReal objectAtIndex:0] socketName] == NULL,@"Host List was initialises incorrectly, expected socketName == NULL got: %@",[[hostListReal objectAtIndex:0] socketName]);
	
	STAssertTrue([[hostListReal objectAtIndex:0] flags] == 0, @"Host List was initialises incorrectly, expected flags == 0 got: %i",[[hostListReal objectAtIndex:0] flags]);
	
	if (![fileSystem removeItemAtPath:hostFilePath error:&cleanUp]) {
		NSAlert *theAlert = [NSAlert alertWithError:cleanUp];
		[theAlert runModal];
	}
	
	[hostListReal release];
	[archiver release];
	[fileSystem release];

}

-(void)testAddHosts
{
	@try
	{
		NSString *hostFilePath;
		NSFileManager *fileSystem;
		HostArchiver *archiver;
		Host *newHost;
		NSError *error, *error_2;
		NSError *cleanUp;
		NSArray *hostList;
		NSString *serverTitle = @"Home_Computer";
		
		hostFilePath = [@"~/.LokiProfile" stringByExpandingTildeInPath];
		
		archiver = [[HostArchiver alloc]initWithProfile:hostFilePath];
		
		fileSystem = [[NSFileManager alloc]init];
		
		newHost = [[Host alloc]init];
		
		[newHost setTitle:serverTitle];
		
		if (![archiver addHost:newHost withError:&error]) {
			NSAlert *theAlert = [NSAlert alertWithError:error];
			[theAlert runModal];
		}
		
		hostList = [[archiver getHosts:&error_2]retain];
		
		if (hostList == nil) {
			if (error_2 != nil) {
				NSAlert *theAlert = [NSAlert alertWithError:error_2];
				[theAlert runModal];
			}
		}
	
		STAssertTrue([hostList count] == 2 ,@"Host list was initialised incorrectly, expected  2 hosts in array but got %i", [hostList count]);
		STAssertTrue([[[hostList objectAtIndex:1]title] isEqualToString:serverTitle], @"Did not add server to host list Expected %@ but got %@",serverTitle,[[hostList objectAtIndex:1]title]);
		
		if (![fileSystem removeItemAtPath:hostFilePath error:&cleanUp]) {
			NSAlert *theAlert = [NSAlert alertWithError:cleanUp];
			[theAlert runModal];
		}
	
		[archiver release];
		[fileSystem release];
		[newHost release];
	}
	@catch (NSException * e) {
		NSLog(@"Exception occured in: %@", NSStringFromClass([self class]));
		NSLog(@"Method: %@",[e name]);
		NSLog(@"Line: %i at Function: %s",__LINE__, __PRETTY_FUNCTION__);
		NSLog(@"Reason: %@",[e reason]);
	} 
}

-(void)testRemoveHosts
{
	@try {
		NSString *hostFilePath;
		NSFileManager *fileSystem;
		HostArchiver *archiver;
		NSError *error, *error_2;
		NSError *cleanUp;
		
		hostFilePath = [@"~/.LokiProfile" stringByExpandingTildeInPath];
		
		archiver = [[HostArchiver alloc]initWithProfile:hostFilePath];
		
		fileSystem = [[NSFileManager alloc]init];
		
		if ([archiver getHosts:&error] == nil) {
			NSAlert *theAlert = [NSAlert alertWithError:error];
			[theAlert runModal];
		}
		
		if (![archiver removeHostAtIndex:0 withError:&error_2]) {
			NSAlert *theAlert = [NSAlert alertWithError:error_2];
			[theAlert runModal];
		}
		
		STAssertTrue([[archiver getHosts:NULL] count] == 0, @"Array should have no hosts but has: %i", [[archiver getHosts:NULL] count]);
		
		if (![fileSystem removeItemAtPath:hostFilePath error:&cleanUp]) {
			NSAlert *theAlert = [NSAlert alertWithError:cleanUp];
			[theAlert runModal];
		}
		
		[archiver release];
		[fileSystem release];
	}
	@catch (NSException * e) {
		NSLog(@"Exception occured in: %@", NSStringFromClass([self class]));
		NSLog(@"Method: %@",[e name]);
		NSLog(@"Line: %i at Function: %s",__LINE__, __PRETTY_FUNCTION__);
		NSLog(@"Reason: %@",[e reason]);
		exit(1);
	}
	@finally {
	}
}

@end
