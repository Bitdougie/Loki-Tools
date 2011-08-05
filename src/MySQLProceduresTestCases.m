//
//  MySQLProceduresTestCases.m
//  Loki_Tools
//
//  Created by Douglas Mason on 4/08/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

#import "MySQLProceduresTestCases.h"
#import "MySQLProcedures.h"
#import "testInformation.h"
#import "Host.h"
#import "DatabaseLogin.h"
#import "lokierr.h"


@implementation MySQLProceduresTestCases

-(void)testEscapeString
{
	@try {
		NSError *error,*error_2, *error_3, *error_4;
		Host *testHost;
		
		testHost = [[Host alloc]init];
		
		[testHost setTitle:HOST_COMPUTER_TITLE];
		[testHost setHostName:HOST_COMPUTER_NAME];
		[testHost setSocketName:HOST_COMPUTER_SOCKET_NAME];
		[testHost setPortNumber:HOST_COMPUTER_PORT_NUMBER];
		[testHost setFlags:HOST_COMPUTER_FLAGS];
		
		if (![DatabaseLogin initWithHost:testHost andUserName:HOST_COMPUTER_USER andPassword:HOST_COMPUTER_PASSWORD andDatabase:HOST_COMPUTER_DATABASE error:&error]) {
			NSAlert *theAlert = [NSAlert alertWithError:error];
			[theAlert runModal];
		}
		
		[testHost release];
		
		NSString *testBox;
		
		testBox = [[MySQLProcedures escapeSQLQuery:STRING_TO_ESCAPE_CHANGELESS andError:&error_2]retain];
		
		if (testBox == NULL) {
			NSAlert *theAlert = [NSAlert alertWithError:error_2];
			[theAlert runModal];
		}
		
		STAssertTrue([testBox isEqualToString: STRING_TO_ESCAPE_CHANGELESS],@"Expected strings to be the same but were different");
		
		[testBox release];
		
		testBox = [[MySQLProcedures escapeSQLQuery:STRING_TO_ESCAPE andError:&error_3] retain];
		
		if (testBox == NULL) {
			NSAlert *theAlert = [NSAlert alertWithError:error_3];
			[theAlert runModal];
		}
		
		STAssertTrue([testBox isEqualToString:ESCAPE_STRING_RESULT],@"Expected string to be equal to ESCAPE_STRING_RESULT but found: %@",testBox);
		
		[testBox release];
		
		STAssertTrue(NULL == [MySQLProcedures escapeSQLQuery:NULL andError:&error_4],@"Expected to return NULL but did not");
		
		STAssertTrue([error_4 code] == LTNA,@"Expected error from NULL input to be: %i",LTNA);
		
	}
	@catch (NSException * e) {
		NSLog(@"Exception occured in: %@", NSStringFromClass([self class]));
		NSLog(@"Method: %@",[e name]);
		NSLog(@"Line: %i at Function: %s",__LINE__, __PRETTY_FUNCTION__);
		NSLog(@"Reason: %@",[e reason]);
	}
}

-(void)testSearchString
{
	@try {
	}
	@catch (NSException * e) {
		NSLog(@"Exception occured in: %@", NSStringFromClass([self class]));
		NSLog(@"Method: %@",[e name]);
		NSLog(@"Line: %i at Function: %s",__LINE__, __PRETTY_FUNCTION__);
		NSLog(@"Reason: %@",[e reason]);
	}

}

@end
