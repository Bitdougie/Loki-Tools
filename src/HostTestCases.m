//
//  HostTestCases.m
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

#import "HostTestCases.h"
#import "Host.h"

@implementation HostTestCases

-(void)testInitialization
{
	Host *testHost;
	NSString *titleResult = @"localhost";
	NSString *hostNameResult = NULL;
	unsigned int portNumResult = 0;
	NSString *socketNameResult = NULL;
	unsigned int flagResult = 0;
	
	testHost = [Host alloc];
	[testHost init];
	
	STAssertTrue([[testHost title] isEqualToString: titleResult], @"title intialized incorrectly. Expected localHost");
	
	STAssertTrue([testHost hostName] == hostNameResult, @"hostName initialized incorrectly. Expected NULL");
	
	STAssertTrue([testHost portNumber] == portNumResult, @"portNumber initialized incorrectly\
				 Expected %i got %i",portNumResult,[testHost portNumber]);
	
	STAssertTrue([testHost socketName] == socketNameResult, @"socketName initialized incorrectly. Expected NULL");
	
	STAssertTrue([testHost flags] == flagResult, @"flags initalized incorrectly \
				 Expected %i got %i",flagResult,[testHost flags]);
	
	[testHost release];
}

@end
