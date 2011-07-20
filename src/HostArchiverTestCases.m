//
//  HostArchiverTestCases.m
//  Loki_Tools
//
//  Created by Douglas Mason on 5/07/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

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
	NSString *hostFilePath;
	HostArchiver *archiver;
	
	archiver = [[HostArchiver alloc]initWithProfile:@"/.LokiProfile"];
	
	error = nil;
	error_2 = nil;
	
	hostList = [archiver getHosts:&error];
	
	STAssertTrue(error != nil, @"Permission denied to configuration file and error caught");

	[archiver release];
	
	hostFilePath = [@"~/.LokiProfile" stringByExpandingTildeInPath];
	
	archiver = [[HostArchiver alloc]initWithProfile:hostFilePath];
	
	hostListReal = [[archiver getHosts:&error_2]retain];
	
	STAssertTrue(error_2 == nil, @"Array of hosts not constructed error code not nil");
	
	STAssertTrue([[hostListReal objectAtIndex:0] hostName] == NULL ,@"Host list was initialised incorrectly, expected HostName == NULL got %@",[[hostListReal objectAtIndex:0] hostName]);
	
	STAssertTrue([[hostListReal objectAtIndex:0] portNumber] == 0,@"Host List was initalised incorrectly, expected portNumber == 0 got: %i", [[hostListReal objectAtIndex:0] portNumber]);
	
	STAssertTrue([[hostListReal objectAtIndex:0] socketName] == NULL,@"Host List was initialises incorrectly, expected socketName == NULL got: %@",[[hostListReal objectAtIndex:0] socketName]);
	
	STAssertTrue([[hostListReal objectAtIndex:0] flags] == 0, @"Host List was initialises incorrectly, expected flags == 0 got: %i",[[hostListReal objectAtIndex:0] flags]);
	
	[archiver release];

}

@end
