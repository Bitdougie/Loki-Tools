//
//  MySQLProceduresTestCases.m
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

#import "MySQLProceduresTestCases.h"
#import "MySQLProcedures.h"
#import "testInformation.h"
#import "Host.h"
#import "DatabaseLogin.h"
#import "lokierr.h"
#import "lokiStructure.h"
#import "xLokiProcedures.h"
#import <my_global.h>
#import <my_sys.h>
#import <mysql.h>
#import <CommonCrypto/CommonDigest.h>

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
		NSError *error,*error_2,*error_3,*error_4;
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
		
		NSArray *testArray;
		
		testArray = [MySQLProcedures searchSQLQuery:SEARCH_STRING_CHANGELESS andError:&error_2];
		
		[testArray retain];
		
		STAssertTrue([testArray count] == SEARCH_STRING_CHANGELESS_LENGTH,@"Expected array to be of length: %i but was of length %i",SEARCH_STRING_CHANGELESS_LENGTH,[testArray count]);
		
		STAssertTrue([[testArray objectAtIndex:0] isEqualToString:SEARCH_STRING_CHANGELESS_RESULT_1],@"Expected result to be: %@ but got: %@",\
					 SEARCH_STRING_CHANGELESS_RESULT_1,[testArray objectAtIndex:0]);
		
		STAssertTrue([[testArray objectAtIndex:1] isEqualToString:SEARCH_STRING_CHANGELESS_RESULT_2],@"Expected result to be: %@ but got: %@",\
					 SEARCH_STRING_CHANGELESS_RESULT_2,[testArray objectAtIndex:1]);
		
		[testArray release];
		
		testArray = [MySQLProcedures searchSQLQuery:SEARCH_STRING_SINGLE andError:&error_3];
		
		[testArray retain];
		
		STAssertTrue([testArray count] == 1,@"Expected array to be of length 1 but was of length %i",[testArray count]);
		
		STAssertTrue([[testArray objectAtIndex:0] isEqualToString: SEARCH_STRING_SINGLE_RESULT],@"Expected result to be: %@ but got: %@",SEARCH_STRING_SINGLE_RESULT,[testArray objectAtIndex:0]);
		
		STAssertTrue(NULL == [MySQLProcedures searchSQLQuery:NULL andError:&error_4],@"Expected to return NULL but did not");
		
		STAssertTrue([error_4 code] == LTNA,@"Expected error from NULL input to be: %i",LTNA);
		
		[testArray release];
	}
	@catch (NSException * e) {
		NSLog(@"Exception occured in: %@", NSStringFromClass([self class]));
		NSLog(@"Method: %@",[e name]);
		NSLog(@"Line: %i at Function: %s",__LINE__, __PRETTY_FUNCTION__);
		NSLog(@"Reason: %@",[e reason]);
	}

}

-(void)testLoadBlobToDatabase
{
	@try {
		NSError *error,*error_2,*error_3,*error_4;
		NSURL *URL;
		
		Host *testHost;
		
		testHost = [[Host alloc]init];
		
		[testHost setTitle:HOST_COMPUTER_TITLE];
		[testHost setHostName:HOST_COMPUTER_NAME];
		[testHost setSocketName:HOST_COMPUTER_SOCKET_NAME];
		[testHost setPortNumber:HOST_COMPUTER_PORT_NUMBER];
		[testHost setFlags:HOST_COMPUTER_FLAGS];
		
		if (![UserInfo initWithHost:testHost andUserName:HOST_COMPUTER_USER andPassword:HOST_COMPUTER_PASSWORD andError:&error]) {
			NSAlert *theAlert = [NSAlert alertWithError:error];
			[theAlert runModal];
		}
		
		MYSQL *connection;
		NSString *query;
		char *charQuery;
		
		connection = [UserInfo openConnection:&error_2];
		
		if (connection == NULL) {
			NSAlert *theAlert = [NSAlert alertWithError:error_2];
			[theAlert runModal];
		}
		
		query = [[NSMutableString alloc]initWithFormat:@"CREATE DATABASE %@;",BLOB_TEST_DATABASE];
		charQuery = copyObjectString(query);		
		mysql_real_query(connection, charQuery, [query length]);
		
		[query release];
		xfree(charQuery);
		
		query = [[NSMutableString alloc]initWithFormat:@"CREATE TABLE %@(%@ INT NOT NULL PRIMARY KEY,%@ LONGBLOB);",BLOB_TEST_TABLE,BLOB_TEST_TABLE_ID,BLOB_TEST_TABLE_DATA];
		charQuery = copyObjectString(query);
		
		if (![DatabaseLogin initWithHost:testHost andUserName:HOST_COMPUTER_USER andPassword:HOST_COMPUTER_PASSWORD andDatabase:BLOB_TEST_DATABASE error:&error_3]) {
			NSAlert *theAlert = [NSAlert alertWithError:error_3];
			[theAlert runModal];
		}
		
		[testHost release];
		
		NSMutableString *pathToPic;
		
		pathToPic = [[NSMutableString alloc]initWithFormat:@"%@/%@",SOURCE_PATH,BLOB_FILE_NAME];
		
		URL = [[NSURL alloc]initFileURLWithPath:[pathToPic stringByExpandingTildeInPath]];
		
		if (![MySQLProcedures loadBlobToDatabase:URL intoTable: BLOB_TEST_TABLE atRow:BLOB_TEST_TABLE_DATA andError:&error_4]) {
			//NSAlert *theAlert = [NSAlert alertWithError:error_4];
			//[theAlert runModal];
		}
		
		
		
		[UserInfo closeConnection:connection];
		xfree(charQuery);
		[query release];
		[pathToPic release];
		
	}
	@catch (NSException * e) {
		NSLog(@"Exception occured in: %@", NSStringFromClass([self class]));
		NSLog(@"Method: %@",[e name]);
		NSLog(@"Line: %i at Function: %s",__LINE__, __PRETTY_FUNCTION__);
		NSLog(@"Reason: %@",[e reason]);
	}
}

@end
