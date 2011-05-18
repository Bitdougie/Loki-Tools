//
//  SupplierViewController.m
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


#import "SupplierViewController.h"
#import "DatabaseSetupConnections.h"


@implementation SupplierViewController

-(SupplierViewController *)initWithUser:(User *)userObject
{
	self = [super init];
	
	if(self)
	{
		userLogin = userObject;
		[userLogin retain];
		error = [[ErrorMessageViewController alloc]init];
		rootNodeBrowser = [BrowserList alloc];
		[rootNodeBrowser initWithDisplayName:@"rootNode"];
		supplierComboBox = [[NSMutableArray alloc]init];
	}
	
	return self;
}

-(void)dealloc
{
	[supplierComboBox release];
	[rootNodeBrowser release];
	[userLogin release];
	[error release];
	[super dealloc];
}

-(IBAction)search:(id) sender
{
	NSLog(@"searching list");
	
	[supplierCode setStringValue:@""];
	[traderType setStringValue:@""];
	[name setStringValue:@""];
	[postalAddress setString:@""];
	[physicalAddress setString:@""];
	[fax setStringValue:@""];
	[phone setStringValue:@""];
	[website setStringValue:@""];
	[freightFree setStringValue:@""];
	
	[self populate:[search stringValue]];
}

-(IBAction)selectSupplier:(id) sender
{
	NSLog(@"select supplier \n");
	NSMutableString *query;
	char *charQuery;
	DatabaseSetupConnections *connection;
	MYSQL_RES *res_set;
	MYSQL_ROW row;
	NSString *temp;
	
	connection = [DatabaseSetupConnections alloc];
	[connection initWithUser:userLogin];
	query = [[NSMutableString alloc]init];
	[connection connectDatabase];
	
	[query setString:@"SELECT SUPPLIER_CODE, TRADE_NAME, POSTAL_ADDRESS, \
	 PHYSICAL_ADDRESS, PHONE, FAX, EMAIL, WEBSITE, FREIGHT_FREE_LIMIT, \
	 TRADER FROM SUPPLIER WHERE "];
	
	if (sender == browser) {
	
		if ([browser clickedRow] >= 0) {
			NSLog(@"browser select \n");
			[query appendString:@"TRADE_NAME = '"];
			[query appendString:[connection escapedSQLQuery:[[rootNodeBrowser childAtIndex:[browser clickedRow]] displayName]]];
			[query appendString:@"';"];
		
			charQuery = (char *)xmalloc(sizeof(char[[query length]]));
		
			(void)strcpy(charQuery,[query UTF8String]);
		
			if (mysql_real_query([connection conn], charQuery, [query length])) {
				NSString *errorMessage;
				errorMessage = [[NSString alloc] initWithUTF8String:mysql_error([connection conn])];
				[error openErrorMessage:@"SupplierViewController:selectSupplier" withMessage:errorMessage];
				[error setErrorNo:0];
			
				[errorMessage release];
				free(charQuery);
				[connection disconnectDatabase];
				[connection release];
				[query release];
				return;
			}
			else {
				res_set = mysql_store_result([connection conn]);
			
				if (res_set == NULL) {
					NSString *errorMessage;
					errorMessage = [[NSString alloc] initWithUTF8String:mysql_error([connection conn])];
					[error openErrorMessage:@"SupplierViewController:selectSupplier" withMessage:errorMessage];
					[error setErrorNo:0];
				
					[errorMessage release];
					free(charQuery);
					[connection disconnectDatabase];
					[connection release];
					[query release];
				}
				else {
				
					while ((row = mysql_fetch_row(res_set)) != NULL) {
						temp = [[NSString alloc] initWithUTF8String:row[0]];
						[supplierCode setStringValue:temp];
						[temp release];
					
						temp =[[NSString alloc] initWithUTF8String:row[1]];
						[name setStringValue: temp];
						[temp release];
					
						temp = [[NSString alloc] initWithUTF8String:row[2]];
						[postalAddress setString:temp];
						[temp release];
					
						temp = [[NSString alloc] initWithUTF8String:row[3]];
						[physicalAddress setString:temp];
						[temp release];
					
						temp = [[NSString alloc] initWithUTF8String:row[4]];
						[phone setStringValue:temp];
						[temp release];
					
						temp = [[NSString alloc] initWithUTF8String:row[5]];
						[fax setStringValue:temp];
						[temp release];
					
						temp = [[NSString alloc] initWithUTF8String:row[6]];
						[email setStringValue:temp];
						[temp release];
					
						temp = [[NSString alloc] initWithUTF8String:row[7]];
						[website setStringValue:temp];
						[temp release];
					
						temp = [[NSString alloc] initWithUTF8String:row[8]];
						[freightFree setStringValue:temp];
						[temp release];
					
						temp = [[NSString alloc] initWithUTF8String:row[9]];
						[traderType setStringValue:temp];
						[temp release];
					}
				
					mysql_free_result(res_set);
				}
			}

			free(charQuery);
		}
	}
	else {
		NSLog(@"comboBox select \n");
		
		if ([[supplierCode stringValue] compare:@""]) 
		{
			[query appendString:@"SUPPLIER_CODE = '"];
			[query appendString:[supplierCode stringValue]];
			[query appendString:@"';"];
		
			charQuery = (char *)xmalloc(sizeof(char[[query length]]));
		
			(void)strcpy(charQuery,[query UTF8String]);
		
			if (mysql_real_query([connection conn], charQuery, [query length])) {
				NSString *errorMessage;
				errorMessage = [[NSString alloc] initWithUTF8String:mysql_error([connection conn])];
				[error openErrorMessage:@"SupplierViewController:selectSupplier" withMessage:errorMessage];
				[error setErrorNo:0];
			
				[errorMessage release];
				free(charQuery);
				[connection disconnectDatabase];
				[connection release];
				[query release];
				return;
			}
			else {
				res_set = mysql_store_result([connection conn]);
			
				if (res_set == NULL) {
					NSString *errorMessage;
					errorMessage = [[NSString alloc] initWithUTF8String:mysql_error([connection conn])];
					[error openErrorMessage:@"SupplierViewController:selectSupplier" withMessage:errorMessage];
					[error setErrorNo:0];
				
					[errorMessage release];
					free(charQuery);
					[connection disconnectDatabase];
					[connection release];
					[query release];
				}
				else {
				
					while ((row = mysql_fetch_row(res_set)) != NULL) {
						temp = [[NSString alloc] initWithUTF8String:row[0]];
						[supplierCode setStringValue:temp];
						[temp release];
					
						temp =[[NSString alloc] initWithUTF8String:row[1]];
						[name setStringValue: temp];
						[temp release];
					
						temp = [[NSString alloc] initWithUTF8String:row[2]];
						[postalAddress setString:temp];
						[temp release];
					
						temp = [[NSString alloc] initWithUTF8String:row[3]];
						[physicalAddress setString:temp];
						[temp release];
					
						temp = [[NSString alloc] initWithUTF8String:row[4]];
						[phone setStringValue:temp];
						[temp release];
					
						temp = [[NSString alloc] initWithUTF8String:row[5]];
						[fax setStringValue:temp];
						[temp release];
					
						temp = [[NSString alloc] initWithUTF8String:row[6]];
						[email setStringValue:temp];
						[temp release];
					
						temp = [[NSString alloc] initWithUTF8String:row[7]];
						[website setStringValue:temp];
						[temp release];
					
						temp = [[NSString alloc] initWithUTF8String:row[8]];
						[freightFree setStringValue:temp];
						[temp release];
						
						temp = [[NSString alloc] initWithUTF8String:row[9]];
						[traderType setStringValue:temp];
						[temp release];
					}
				
					mysql_free_result(res_set);
				}
			}
		
			free(charQuery);
		}
	}
	
	[connection disconnectDatabase];
	[connection release];
	[query release];
}

-(IBAction)edit:(id) sender
{
	NSLog(@"edit \n");
	NSMutableString *query;
	char *charQuery;
	DatabaseSetupConnections *connection;
	
	query = [[NSMutableString alloc]init];
	connection = [DatabaseSetupConnections alloc];
	[connection initWithUser:userLogin];
	[connection connectDatabase];
	
	[query setString:@"UPDATE SUPPLIER SET "];
	[query appendString:@"TRADE_NAME = '"];
	[query appendString:[connection escapedSQLQuery:[name stringValue]]];
	[query appendString:@"', POSTAL_ADDRESS = '"];
	[query appendString:[connection escapedSQLQuery:[postalAddress string]]];
	[query appendString:@"', PHYSICAL_ADDRESS = '"];
	[query appendString:[connection escapedSQLQuery:[physicalAddress string]]];
	[query appendString:@"', PHONE = '"];
	[query appendString:[connection escapedSQLQuery:[phone stringValue]]];
	[query appendString:@"', FAX = '"];
	[query appendString:[connection escapedSQLQuery:[fax stringValue]]];
	[query appendString:@"', EMAIL = '"];
	[query appendString:[connection escapedSQLQuery:[email stringValue]]];
	[query appendString:@"', WEBSITE = '"];
	[query appendString:[connection escapedSQLQuery:[website stringValue]]];
	[query appendFormat:@"', FREIGHT_FREE_LIMIT = %f", [freightFree doubleValue]];
	[query appendString:@", TRADER = '"];
	[query appendString:[connection escapedSQLQuery:[traderType stringValue]]];
	[query appendString:@"' WHERE SUPPLIER_CODE = '"];
	[query appendString:[connection escapedSQLQuery:[supplierCode stringValue]]];
	[query appendString:@"';"];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_real_query([connection conn], charQuery, [query length])) {
		NSString *errorMessage;
		errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
		[error openErrorMessage:@"SupplierViewController:add" withMessage:errorMessage];
		[error setErrorNo:0];
		
		[errorMessage release];
		[connection disconnectDatabase];
		[connection release];
		[query release];
		free(charQuery);
		return;
	}
	
	[connection disconnectDatabase];
	[connection release];
	[query release];
	free(charQuery);
	[self refresh: self];
}

-(IBAction)add:(id) sender
{
	NSLog(@"add \n");
	NSMutableString *query;
	char *charQuery;
	DatabaseSetupConnections *connection;
	
	query = [[NSMutableString alloc]init];
	connection = [DatabaseSetupConnections alloc];
	[connection initWithUser:userLogin];
	[connection connectDatabase];
	
	[query setString:@"INSERT INTO SUPPLIER VALUES('"];
	[query appendString:[connection escapedSQLQuery:[supplierCode stringValue]]];
	[query appendString:@"','"];
	[query appendString:[connection escapedSQLQuery:[name stringValue]]];
	[query appendString:@"','"];
	[query appendString:[connection escapedSQLQuery:[postalAddress string]]];
	[query appendString:@"','"];
	[query appendString:[connection escapedSQLQuery:[physicalAddress string]]];
	[query appendString:@"','"];
	[query appendString:[connection escapedSQLQuery:[phone stringValue]]];
	[query appendString:@"','"];
	[query appendString:[connection escapedSQLQuery:[fax stringValue]]];
	[query appendString:@"','"];
	[query appendString:[connection escapedSQLQuery:[email stringValue]]];
	[query appendString:@"','"];
	[query appendString:[connection escapedSQLQuery:[website stringValue]]];
	[query appendString:@"',"];
	if ([[freightFree stringValue] compare:@""]) 
	{
		[query appendString:[connection escapedSQLQuery:[freightFree stringValue]]];
	}
	else {
		[query appendString:@"NULL"];
	}
	[query appendString:@",'"];
	[query appendString:[connection escapedSQLQuery:[traderType stringValue]]];
	[query appendString:@"',NULL); "];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_real_query([connection conn], charQuery, [query length])) {
		NSString *errorMessage;
		errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
		[error openErrorMessage:@"SupplierViewController:add" withMessage:errorMessage];
		[error setErrorNo:0];
		
		[errorMessage release];
		[connection disconnectDatabase];
		[connection release];
		[query release];
		free(charQuery);
		return;
	}
	
	[connection disconnectDatabase];
	[connection release];
	[query release];
	free(charQuery);
	[self refresh: self];
}

-(IBAction)remove:(id) sender
{
	NSLog(@"remove \n");
	NSMutableString *query;
	char *charQuery;
	DatabaseSetupConnections *connection;
	
	query = [[NSMutableString alloc]init];
	connection = [DatabaseSetupConnections alloc];
	[connection initWithUser:userLogin];
	[connection connectDatabase];
	
	[query setString:@"DELETE FROM SUPPLIER WHERE SUPPLIER_CODE ='"];
	[query appendString:[connection escapedSQLQuery:[supplierCode stringValue]]];
	[query appendString:@"';"];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery,[query UTF8String]);

	if (mysql_real_query([connection conn], charQuery, [query length])) {
		NSString *errorMessage;
		errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
		[error openErrorMessage:@"SupplierViewController:remove" withMessage:errorMessage];
		[error setErrorNo:0];
		
		[errorMessage release];
		[connection disconnectDatabase];
		[connection release];
		[query release];
		free(charQuery);
	}
	
	[connection disconnectDatabase];
	[connection release];
	[query release];
	free(charQuery);
	
	[self refresh: self];
}

-(void)openSupplier
{
	NSLog(@"open supplier \n");
	
	if (![NSBundle loadNibNamed:@"SupplierViewController" owner: self]) {
		[error openErrorMessage:@"SupplierViewController:openSupplier" withMessage:@"Could not load SupplierViewController.xib"];
		[error setErrorNo:1];
		return;
	}
	
	[self refresh: @"openSupplier"];
}

-(void)populate:(NSString *) searchString
{
	NSLog(@"populate \n");
	NSMutableString *query;
	DatabaseSetupConnections *connection;
	BrowserList *browserTemp;
	MYSQL_RES *res_set;
	MYSQL_ROW row;
	char *charQuery;
	NSString *tradeName;
	NSString *temp;
	
	[rootNodeBrowser removeAllChildren];
	[supplierComboBox removeAllObjects];
	
	query = [[NSMutableString alloc]init];
	connection = [DatabaseSetupConnections alloc];
	[connection initWithUser:userLogin];
	[connection connectDatabase];
	
	[query setString:@"SELECT TRADE_NAME, SUPPLIER_CODE FROM SUPPLIER WHERE TRADE_NAME LIKE '%"];
	[query appendString:[connection escapedSQLQuery: searchString]];
	[query appendString:@"%';"];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_real_query([connection conn], charQuery, [query length])) {
		NSString *errorMessage;
		errorMessage = [[NSString alloc] initWithUTF8String:mysql_error([connection conn])];
		[error openErrorMessage:@"SupplierViewController:populate" withMessage:errorMessage];
		[error setErrorNo:0];
		
		[errorMessage release];
		[connection disconnectDatabase];
		[connection release];
		[query release];
		free(charQuery);
		return;
	}
	else {
		
		res_set = mysql_store_result([connection conn]);
		
		if (res_set == NULL) {
			NSString *errorMessage;
			errorMessage = [[NSString alloc] initWithUTF8String:mysql_error([connection conn])];
			[error openErrorMessage:@"SupplierViewController:populate" withMessage:errorMessage];
			[error setErrorNo:0];
			
			[errorMessage release];
			[connection disconnectDatabase];
			[connection release];
			[query release];
			free(charQuery);
			return;
		}
		else{
			while ((row = mysql_fetch_row(res_set)) != NULL) {
				tradeName = [[NSString alloc] initWithUTF8String:row[0]];
				browserTemp = [BrowserList alloc];
				[browserTemp initWithDisplayName:tradeName];
				[rootNodeBrowser addChild:browserTemp];
				temp = [[NSString alloc]initWithUTF8String:row[1]];
				[supplierComboBox addObject:temp];
				[temp release];
				[tradeName release];
				[browserTemp release];
			}
		
		}
		
		mysql_free_result(res_set);
	}
	
	[browser loadColumnZero];
	
	[connection disconnectDatabase];
	[connection release];
	[query release];
	free(charQuery);
}

-(IBAction)refresh: (id) sender
{
	NSLog(@"refresh \n");
	NSMutableString *query;
	DatabaseSetupConnections *connection;
	MYSQL_RES *res_set;
	MYSQL_ROW row;
	char *charQuery;
	NSString *temp;
	
	connection = [DatabaseSetupConnections alloc];
	[connection initWithUser:userLogin];
	[connection connectDatabase];
	
	[traderType removeAllItems];
	
	query = [[NSMutableString alloc]init];
	[query setString:@"SELECT TITLE FROM TRADER_TYPE;"];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_real_query([connection conn], charQuery, [query length])) {
		NSString *errorMessage;
		errorMessage = [[NSString alloc] initWithUTF8String:mysql_error([connection conn])];
		[error openErrorMessage:@"SupplierViewController:refresh" withMessage:errorMessage];
		[error setErrorNo:0];
		
		[errorMessage release];
		[connection disconnectDatabase];
		[connection release];
		[query release];
		free(charQuery);
		return;
	}
	else {
		res_set = mysql_store_result([connection conn]);
		
		if (res_set == NULL) {
			NSString *errorMessage;
			errorMessage = [[NSString alloc] initWithUTF8String:mysql_error([connection conn])];
			[error openErrorMessage:@"SupplierViewController:refresh" withMessage:errorMessage];
			[error setErrorNo:0];
			
			[errorMessage release];
			[connection disconnectDatabase];
			[connection release];
			[query release];
			free(charQuery);
			return;
		}
		else {
			
			while ((row = mysql_fetch_row(res_set)) != NULL) {
				temp = [[NSString alloc]initWithUTF8String:row[0]];
				[traderType addItemWithObjectValue:temp];
			}
			
			mysql_free_result(res_set);
		}

	}

	[connection disconnectDatabase];
	[connection release];
	[query release];
	free(charQuery);
	
	[self populate: @""];
}

-(id) rootItemForBrowser:(NSBrowser *)browser
{
	return rootNodeBrowser;
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

-(NSInteger) numberOfItemsInComboBox: (NSComboBox *) aComboBox
{
	return ([supplierComboBox count]);
}

-(id) comboBox: (NSComboBox *) aComboBox objectValueForItemAtIndex:(NSInteger)index
{
	return ([supplierComboBox objectAtIndex:index]);
}

-(NSUInteger) comboBox:(NSComboBox *)aComboBox indexOfItemWithStringValue: (NSString *) string
{
	return ([supplierComboBox indexOfObject:string]);
}

-(NSString *) firstGenreMatchingPrefix: (NSString *) prefix
{
	NSString *string = nil;
	NSString *lowercasePrefix = [prefix lowercaseString];
	NSEnumerator *stringEnum = [supplierComboBox objectEnumerator];
	
	while ((string = [stringEnum nextObject]))
		if ([[string lowercaseString]hasPrefix:lowercasePrefix]) {
			return(string);
		}
	
	return nil;
}

-(NSString *) comboBox: (NSComboBox *) aComboBox completedString: (NSString *) inputString
{
	NSString *candidate = [self firstGenreMatchingPrefix:inputString];
	return(candidate ? candidate : inputString);
}


@end
