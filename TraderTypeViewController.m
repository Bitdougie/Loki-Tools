//
//  TraderTypeViewController.m
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
 
 Loki Tools  Copyright (C) 2011  Douglas Mason
 This program comes with ABSOLUTELY NO WARRANTY;
 */

#import "TraderTypeViewController.h"
#import "DatabaseSetupConnections.h"
#import <my_global.h>
#import <my_sys.h>
#import <mysql.h>

@implementation TraderTypeViewController

-(TraderTypeViewController *)initWithUser:(User *)userObject
{
	self = [super init];
	
	if(self)
	{
		userLogin = userObject;
		[userLogin retain];
		rootNode = [BrowserList alloc];
		[rootNode initWithDisplayName:@"rootNode"];
		error = [[ErrorMessageViewController alloc]init];
	}
	
	return self;
}

-(void)dealloc
{
	[userLogin release];
	[rootNode release];
	[error release];
	[super dealloc];
}

-(IBAction)update:(id) sender
{
	NSMutableString *query;
	query = [[NSMutableString alloc]init];
	char *charQuery;
	MYSQL_RES *res_set;
	MYSQL_ROW row;
	NSString *matchs;
	NSUInteger numMatchs;
	
	DatabaseSetupConnections *connection;
	
	connection = [DatabaseSetupConnections alloc];
	[connection initWithUser:userLogin];
	[connection connectDatabase];
	
	[query setString:@"SELECT COUNT(TITLE) FROM TRADER_TYPE WHERE TITLE = '"];
	[query appendString:[connection escapedSQLQuery:[traderType stringValue]]];
	[query appendString:@"';"];
	
	charQuery = (char*)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery,[query UTF8String]);
	
	if(mysql_real_query([connection conn], charQuery, [query length]))
	{
		NSString *errorMessage;
		errorMessage = [[NSString alloc] initWithUTF8String: mysql_error([connection conn])];
		[error openErrorMessage:@"TraderTypeViewController:update" withMessage: errorMessage];
		[error setErrorNo:0];
		
		[errorMessage release];
		[connection disconnectDatabase];
		[connection release];
		free(charQuery);
		[query release];
	}
	else {
		res_set = mysql_store_result([connection conn]);
		
		while ((row = mysql_fetch_row(res_set)) != NULL ) {
			matchs = [[NSString alloc]initWithUTF8String:row[0]];
			numMatchs = [matchs intValue];
			[matchs release];
		}
		
		mysql_free_result(res_set);
	}
	
	free(charQuery);
	
	if (numMatchs > 0) {
		// write over existing information
		[query setString:@"UPDATE TRADER_TYPE SET SUMMARY='"];
		[query appendString:[connection escapedSQLQuery:[summary string]]];
		[query appendString:@"', PERCENT_REBATE = "];
		[query appendFormat:@"%f WHERE TITLE = '",[rebate doubleValue]/100];
		[query appendString:[connection escapedSQLQuery:[traderType stringValue]]];
		[query appendString:@"';"];
		
		charQuery = (char *)xmalloc(sizeof(char[[query length]]));
		
		(void)strcpy(charQuery,[query UTF8String]);
		
		if(mysql_real_query([connection conn], charQuery, [query length]))
		{
			NSString *errorMessage;
			errorMessage = [[NSString alloc] initWithUTF8String: mysql_error([connection conn])];
			[error openErrorMessage:@"TraderTypeViewController:update" withMessage: errorMessage];
			[error setErrorNo:0];
			
			[errorMessage release];
			[connection disconnectDatabase];
			[connection release];
			free(charQuery);
			[query release];
		}
		
		free(charQuery);
	}
	else {
		// create new entry
		[query setString:@"INSERT INTO TRADER_TYPE VALUES('"];
		[query appendString:[connection escapedSQLQuery:[traderType stringValue]]];
		[query appendString:@"','"];
		[query appendString:[connection escapedSQLQuery:[summary string]]];
		[query appendString:@"',"];
		[query appendFormat:@"%f );",[rebate doubleValue]/100];		
		
		charQuery = (char *)xmalloc(sizeof(char[[query length]]));
		
		(void)strcpy(charQuery,[query UTF8String]);
		
		if(mysql_real_query([connection conn], charQuery, [query length]))
		{
			NSString *errorMessage;
			errorMessage = [[NSString alloc] initWithUTF8String: mysql_error([connection conn])];
			[error openErrorMessage:@"TraderTypeViewController:update" withMessage: errorMessage];
			[error setErrorNo:0];
			
			[errorMessage release];
			[connection disconnectDatabase];
			[connection release];
			free(charQuery);
			[query release];
		}
		free(charQuery);
	}

	[connection disconnectDatabase];
	[connection release];
	[query release];
	
	[self populateList];
}

-(IBAction)refresh:(id) sender
{
	[self populateList];
}

-(IBAction)selectTrader:(id) sender
{	
	NSMutableString *query;
	query = [[NSMutableString alloc]init];
	char *charQuery;
	MYSQL_RES *res_set;
	MYSQL_ROW row;
	NSString *description;
	NSString *percentRebate;
	
	DatabaseSetupConnections *connection;
	
	connection = [DatabaseSetupConnections alloc];
	[connection initWithUser:userLogin];
	
	[connection connectDatabase];
	
	if ([browser clickedRow] >= 0) {
		[traderType setStringValue:[[rootNode childAtIndex:[browser clickedRow]] displayName]];
		[query setString:@"SELECT SUMMARY, PERCENT_REBATE*100 FROM TRADER_TYPE WHERE TITLE = '"];
		[query appendString:[connection escapedSQLQuery:[[rootNode childAtIndex:[browser clickedRow]] displayName]]];
		[query appendString:@"';"];
		
		charQuery = (char *)xmalloc(sizeof(char[[query length]]));
		
		(void)strcpy(charQuery,[query UTF8String]);
		
		if(mysql_real_query([connection conn], charQuery, [query length]))
		{
			NSString *errorMessage;
			errorMessage = [[NSString alloc] initWithUTF8String: mysql_error([connection conn])];
			[error openErrorMessage:@"TraderTypeViewController:populateList" withMessage: errorMessage];
			[error setErrorNo:0];

			[errorMessage release];
			[connection disconnectDatabase];
			[query release];
			[connection release];
			free(charQuery);
			return;
		}
		
		res_set = mysql_store_result([connection conn]);
		
		if (res_set == NULL) {
			NSString *errorMessage;
			errorMessage = [[NSString alloc] initWithUTF8String: mysql_error([connection conn])];
			[error openErrorMessage:@"TraderTypeViewController:populateList" withMessage: errorMessage];
			[error setErrorNo:0];
			
			[errorMessage release];
			[connection disconnectDatabase];
			[query release];
			[connection release];
			free(charQuery);
			return;			
		}
		else {
			
			while ((row = mysql_fetch_row(res_set)) != NULL) {
				description = [[NSString alloc]initWithUTF8String:row[0]];
				percentRebate = [[NSString alloc]initWithUTF8String:row[1]];
				
				[summary setString:description];
				[rebate setStringValue:percentRebate];
				
				[description release];
				[percentRebate release];
			}
			 
			mysql_free_result(res_set);
		}

		free(charQuery);
	}
	else {
		[traderType setStringValue:@""];
		[summary setString:@""];
		[rebate setStringValue:@""];
	}
	
	[connection disconnectDatabase];
	[query release];
	[connection release];
}

-(void)openTraderType
{	
	if (![NSBundle loadNibNamed:@"TraderTypeViewController" owner: self]) {
		[error openErrorMessage:@"TraderTypeViewController:openTraderType" withMessage:@"Could not load TraderTypeViewController.xib"];
		[error setErrorNo:1];
	}
	
	[self populateList];
}

-(void)populateList
{
	NSMutableString *query;
	query = [[NSMutableString alloc]init];
	char *charQuery;
	MYSQL_RES *res_set;
	MYSQL_ROW row;
	NSString *title;
	DatabaseSetupConnections *connection;
	BrowserList *tempList;
	
	[rootNode removeAllChildren];
	
	connection = [DatabaseSetupConnections alloc];
	[connection initWithUser:userLogin];
	
	[connection connectDatabase];
	
	[query setString:@"SELECT TITLE FROM TRADER_TYPE;"];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_query([connection conn], charQuery) != 0) {
		NSString *errorMessage;
		errorMessage = [[NSString alloc] initWithUTF8String: mysql_error([connection conn])];
		[error openErrorMessage:@"TraderTypeViewController:populateList" withMessage: errorMessage];
		[error setErrorNo:0];
		
		[errorMessage release];
		[connection disconnectDatabase];
		[connection release];
		free(charQuery);
		[query release];
		return;
	}
	
	res_set = mysql_store_result([connection conn]);
	
	if(res_set == NULL)
	{
		NSString *errorMessage;
		errorMessage = [[NSString alloc] initWithUTF8String: mysql_error([connection conn])];
		[error openErrorMessage:@"ChangePasswordViewController:populateList" withMessage: errorMessage];
		[error setErrorNo:0];
		
		[errorMessage release];
		[connection disconnectDatabase];
		[connection release];
		free(charQuery);
		[query release];
		return;
	}
	else {
		while ((row = mysql_fetch_row(res_set)) != NULL) {
			title = [[NSString alloc]initWithUTF8String:row[0]];
			tempList = [BrowserList alloc];
			[tempList initWithDisplayName:title];
			[rootNode addChild:tempList];
			
			[tempList release];
			[title release];
		}
		mysql_free_result(res_set);
	}
	
	[browser loadColumnZero];
	
	[connection disconnectDatabase];
	[connection release];
	free(charQuery);
	[query release];	
}


-(id) rootItemForBrowser:(NSBrowser *)browser
{
	return rootNode;
}

-(NSInteger)browser:(NSBrowser *)browser numberOfChildrenOfItem:(id)item
{
	BrowserList *node = (BrowserList *)item;
	return [node numberOfChildren];
}

-(id)browser:(NSBrowser *)browser child:(NSInteger)index ofItem:(id)item
{
	BrowserList *node = (BrowserList *)item;
	return[node childAtIndex:index];
}

-(BOOL)browser:(NSBrowser *)browser isLeafItem:(id)item
{
	BrowserList *node = (BrowserList *)item;
	if ([node numberOfChildren] > 0) {
		return FALSE;
	}
	else {
		return TRUE;
	}
}

-(id)browser:(NSBrowser *)browser objectValueForItem:(id)item
{
	BrowserList *node = (BrowserList *)item;
	return [node displayName];
}

@end
