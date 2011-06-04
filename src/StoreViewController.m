//
//  StoreViewController.m
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


#import "StoreViewController.h"
#import "DatabaseSetupConnections.h"


@implementation StoreViewController

-(StoreViewController *)initWithUser:(User *)userObject
{
	self = [super init];
	
	if(self)
	{
		userLogin = userObject;
		[userLogin retain];
		error = [[ErrorMessageViewController alloc]init];
		rootNode = [BrowserList alloc];
		[rootNode initWithDisplayName:@"rootNode"];
	}
	
	return self;
}

-(void)dealloc
{
	[error release];
	[userLogin release];
	[rootNode release];
	[super dealloc];
}

-(IBAction)refresh:(id) sender
{
	NSLog(@"refresh");
	NSMutableString *query;
	char *charQuery;
	MYSQL_RES *res_set;
	MYSQL_ROW row;
	DatabaseSetupConnections *connection;
	BrowserList *tempBrowser;
	NSString *tempString;
	
	[rootNode removeAllChildren];
	[storeCode removeAllItems];
	
	query = [[NSMutableString alloc]init];
	connection = [DatabaseSetupConnections alloc];
	[connection initWithUser:userLogin];
	
	[connection connectDatabase];
	
	[query setString:@"SELECT TRADE_NAME,STORE_CODE FROM STORE;"];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery, [query UTF8String]);
	
	if (mysql_real_query([connection conn], charQuery, [query length])) {
		NSString *errorMessage;
		errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
		[error openErrorMessage:@"StoreViewController:refresh" withMessage:errorMessage];
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
			errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
			[error openErrorMessage:@"StoreViewController:refresh" withMessage:errorMessage];
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
				tempBrowser = [BrowserList alloc];
				tempString = [[NSString alloc] initWithUTF8String:row[0]];
				[tempBrowser initWithDisplayName:tempString];
				[rootNode addChild:tempBrowser];
				[tempBrowser release];
				[tempString release];
				tempString = [[NSString alloc] initWithUTF8String: row[1]];
				[storeCode addItemWithObjectValue:tempString];
				[tempString release];
			}
			
			mysql_free_result(res_set);
		}

	}
	
	[browser loadColumnZero];
	
	[connection disconnectDatabase];
	
	[connection release];
	[query release];
	free(charQuery);
}


-(IBAction)select:(id) sender
{
	NSLog(@"select \n");
	NSMutableString *query;
	char *charQuery;
	MYSQL_RES *res_set;
	MYSQL_ROW row;
	DatabaseSetupConnections *connection;
	NSString *tempString;
	
	query = [[NSMutableString alloc]init];
	connection = [DatabaseSetupConnections alloc];
	[connection initWithUser:userLogin];
	[connection connectDatabase];
	
	[query setString:@"SELECT TRADE_NAME, POSTAL_ADDRESS, PHYSICAL_ADDRESS,PHONE, \
	 FAX,EMAIL,WEBSITE,FREE_PHONE,FREE_FAX,COMPANY_PROFILE, PRODUCT_CUSTOMER_MARKET, \
	 EXPERTISE, KEY_BRANDS, STORE_CODE FROM STORE WHERE "];
	
	if (sender == browser) {
		NSLog(@"browser \n");
		if ([browser clickedRow ] >= 0) {
			[query appendString:@"TRADE_NAME = '"];
			[query appendString:[connection escapedSQLQuery:[[rootNode childAtIndex:[browser clickedRow]]displayName]]];
			[query appendString:@"';"];
		
			charQuery = (char *)xmalloc(sizeof(char[[query length]]));
		
			(void)strcpy(charQuery,[query UTF8String]);
		
			if (mysql_real_query([connection conn], charQuery, [query length])) {
				NSString *errorMessage;
				errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
				[error openErrorMessage:self withMessage:errorMessage];
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
					[error openErrorMessage:self withMessage:errorMessage];
					[error setErrorNo:0];
				
					[errorMessage release];
					free(charQuery);
					[connection disconnectDatabase];
					[connection release];
					[query release];
					return;
				}
				else {
				
					while ((row = mysql_fetch_row(res_set)) != NULL) {
					
						if (row[0] == NULL) {
							tempString = [[NSString alloc]initWithString:@""];
						}
						else {
							tempString = [[NSString alloc] initWithUTF8String:row[0]];
						}
						[name setStringValue:tempString];
						[tempString release];
					
						if (row[1] == NULL) {
							tempString = [[NSString alloc]initWithString:@""];
						}
						else {
							tempString = [[NSString alloc] initWithUTF8String:row[1]];
						}
						[postalAddress setString:tempString];
						[tempString release];
					
						if (row[2] == NULL) {
							tempString = [[NSString alloc]initWithString:@""];
						}	
						else {
							tempString = [[NSString alloc] initWithUTF8String:row[2]];
						}
						[physicalAddress setString:tempString];
						[tempString release];
					
						if (row[3] == NULL) {
							tempString = [[NSString alloc]initWithString:@""];
						}
						else {
							tempString = [[NSString alloc] initWithUTF8String:row[3]];
						}
						[phone setStringValue:tempString];
						[tempString release];
					
						if (row[4] == NULL) {
							tempString = [[NSString alloc]initWithString:@""];
						}
						else {
							tempString = [[NSString alloc] initWithUTF8String:row[4]];
						}
						[fax setStringValue:tempString];
						[tempString release];
					
						if (row[5] == NULL) {
							tempString = [[NSString alloc]initWithString:@""];
						}
						else {
							tempString = [[NSString alloc] initWithUTF8String:row[5]];
						}
						[email setStringValue:tempString];
						[tempString release];
					
						if (row[6] == NULL) {
							tempString = [[NSString alloc]initWithString:@""];
						}
						else {
							tempString = [[NSString alloc] initWithUTF8String:row[6]];
						}
						[website setStringValue:tempString];
						[tempString release];
					
						if (row[7] == NULL) {
							tempString = [[NSString alloc]initWithString:@""];
						}	
						else {
							tempString = [[NSString alloc] initWithUTF8String:row[7]];
						}
						[freePhone setStringValue:tempString];
						[tempString release];
					
						if (row[8] == NULL) {
							tempString = [[NSString alloc]initWithString:@""];
						}
						else {
							tempString = [[NSString alloc] initWithUTF8String:row[8]];
						}
						[freeFax setStringValue:tempString];
						[tempString release];
					
						if (row[9] == NULL) {
							tempString = [[NSString alloc]initWithString:@""];
						}
						else {
							tempString = [[NSString alloc] initWithUTF8String:row[9]];
						}
						[companyProfile setString:tempString];
						[tempString release];
					
						if (row[10] == NULL) {
							tempString = [[NSString alloc]initWithString:@""];
						}
						else {
							tempString = [[NSString alloc] initWithUTF8String:row[10]];
						}
						[productCustomerMarket setString:tempString];
						[tempString release];
					
						if (row[11] == NULL) {
							tempString = [[NSString alloc]initWithString:@""];
						}
						else {
							tempString = [[NSString alloc] initWithUTF8String:row[11]];
						}
						[expertise setString:tempString];
						[tempString release];
					
						if (row[12] == NULL) {
							tempString = [[NSString alloc]initWithString:@""];
						}
						else {
							tempString = [[NSString alloc] initWithUTF8String:row[12]];
						}
						[keyBrands setString:tempString];
						[tempString release];
					
						if (row[13] == NULL) {
							tempString = [[NSString alloc]initWithString:@""];
						}	
						else {
							tempString = [[NSString alloc] initWithUTF8String:row[13]];
						}
						[storeCode setStringValue:tempString];
						[tempString release];
					}
				
					mysql_free_result(res_set);
				}

			}

			free(charQuery);
		}
	}
	else {
		NSLog(@"supplier code comboBox \n");
		[query appendString:@"STORE_CODE = '"];
		[query appendString:[connection escapedSQLQuery:[storeCode stringValue]]];
		[query appendString:@"';"];
		
		charQuery = (char *)xmalloc(sizeof(char[[query length]]));
		
		(void)strcpy(charQuery,[query UTF8String]);
		
		if (mysql_real_query([connection conn], charQuery, [query length])) {
			NSString *errorMessage;
			errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
			[error openErrorMessage:self withMessage:errorMessage];
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
				[error openErrorMessage:self withMessage:errorMessage];
				[error setErrorNo:0];
				
				[errorMessage release];
				free(charQuery);
				[connection disconnectDatabase];
				[connection release];
				[query release];
				return;
			}
			else {
				
				while ((row = mysql_fetch_row(res_set)) != NULL) {
					
					if (row[0] == NULL) {
						tempString = [[NSString alloc]initWithString:@""];
					}
					else {
						tempString = [[NSString alloc] initWithUTF8String:row[0]];
					}
					[name setStringValue:tempString];
					[tempString release];
					
					if (row[1] == NULL) {
						tempString = [[NSString alloc]initWithString:@""];
					}
					else {
						tempString = [[NSString alloc] initWithUTF8String:row[1]];
					}
					[postalAddress setString:tempString];
					[tempString release];
					
					if (row[2] == NULL) {
						tempString = [[NSString alloc]initWithString:@""];
					}	
					else {
						tempString = [[NSString alloc] initWithUTF8String:row[2]];
					}
					[physicalAddress setString:tempString];
					[tempString release];
					
					if (row[3] == NULL) {
						tempString = [[NSString alloc]initWithString:@""];
					}
					else {
						tempString = [[NSString alloc] initWithUTF8String:row[3]];
					}
					[phone setStringValue:tempString];
					[tempString release];
					
					if (row[4] == NULL) {
						tempString = [[NSString alloc]initWithString:@""];
					}
					else {
						tempString = [[NSString alloc] initWithUTF8String:row[4]];
					}
					[fax setStringValue:tempString];
					[tempString release];
					
					if (row[5] == NULL) {
						tempString = [[NSString alloc]initWithString:@""];
					}
					else {
						tempString = [[NSString alloc] initWithUTF8String:row[5]];
					}
					[email setStringValue:tempString];
					[tempString release];
					
					if (row[6] == NULL) {
						tempString = [[NSString alloc]initWithString:@""];
					}
					else {
						tempString = [[NSString alloc] initWithUTF8String:row[6]];
					}
					[website setStringValue:tempString];
					[tempString release];
					
					if (row[7] == NULL) {
						tempString = [[NSString alloc]initWithString:@""];
					}	
					else {
						tempString = [[NSString alloc] initWithUTF8String:row[7]];
					}
					[freePhone setStringValue:tempString];
					[tempString release];
					
					if (row[8] == NULL) {
						tempString = [[NSString alloc]initWithString:@""];
					}
					else {
						tempString = [[NSString alloc] initWithUTF8String:row[8]];
					}
					[freeFax setStringValue:tempString];
					[tempString release];
					
					if (row[9] == NULL) {
						tempString = [[NSString alloc]initWithString:@""];
					}
					else {
						tempString = [[NSString alloc] initWithUTF8String:row[9]];
					}
					[companyProfile setString:tempString];
					[tempString release];
					
					if (row[10] == NULL) {
						tempString = [[NSString alloc]initWithString:@""];
					}
					else {
						tempString = [[NSString alloc] initWithUTF8String:row[10]];
					}
					[productCustomerMarket setString:tempString];
					[tempString release];
					
					if (row[11] == NULL) {
						tempString = [[NSString alloc]initWithString:@""];
					}
					else {
						tempString = [[NSString alloc] initWithUTF8String:row[11]];
					}
					[expertise setString:tempString];
					[tempString release];
					
					if (row[12] == NULL) {
						tempString = [[NSString alloc]initWithString:@""];
					}
					else {
						tempString = [[NSString alloc] initWithUTF8String:row[12]];
					}
					[keyBrands setString:tempString];
					[tempString release];
					
					if (row[13] == NULL) {
						tempString = [[NSString alloc]initWithString:@""];
					}	
					else {
						tempString = [[NSString alloc] initWithUTF8String:row[13]];
					}
					[storeCode setStringValue:tempString];
					[tempString release];
				}
				
				mysql_free_result(res_set);
			}
			
		}
		
		free(charQuery);
	}
	
	[connection disconnectDatabase];
	[connection release];
	[query release];
}

-(IBAction)addStore:(id) sender
{
	NSLog(@"add");
	NSMutableString *query;
	char *charQuery;
	DatabaseSetupConnections *connection;
	
	query = [[NSMutableString alloc]init];
	connection = [DatabaseSetupConnections alloc];
	[connection initWithUser:userLogin];
	[connection connectDatabase];
	
	[query setString:@"INSERT INTO STORE VALUE('"];
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
	[query appendString:@"','"];
	[query appendString:[connection escapedSQLQuery:[freePhone stringValue]]];
	[query appendString:@"','"];
	[query appendString:[connection escapedSQLQuery:[freeFax stringValue]]];
	[query appendString:@"','"];
	[query appendString:[connection escapedSQLQuery:[companyProfile string]]];
	[query appendString:@"','"];
	[query appendString:[connection escapedSQLQuery:[productCustomerMarket string]]];
	[query appendString:@"','"];
	[query appendString:[connection escapedSQLQuery:[expertise string]]];
	[query appendString:@"','"];
	[query appendString:[connection escapedSQLQuery:[keyBrands string]]];
	[query appendString:@"','"];
	[query appendString:[connection escapedSQLQuery:[storeCode stringValue]]];
	[query appendString:@"');"];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery,[query UTF8String]);
	
	if(mysql_real_query([connection conn], charQuery, [query length]))
	{
		NSString *errorMessage;
		errorMessage = [[NSString alloc] initWithUTF8String:mysql_error([connection conn])];
		[error openErrorMessage:@"StoreViewController:add" withMessage:errorMessage];
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
	
	[self refresh:self];
}

-(IBAction)editStore:(id) sender
{
	NSLog(@"editStore \n");
	NSMutableString *query;
	char *charQuery;
	DatabaseSetupConnections *connection;
	
	query = [[NSMutableString alloc]init];
	connection = [DatabaseSetupConnections alloc];
	[connection initWithUser:userLogin];
	[connection connectDatabase];
	
	[query setString:@"UPDATE STORE SET POSTAL_ADDRESS ='"];
	[query appendString:[connection escapedSQLQuery:[postalAddress string]]];
	[query appendString:@"', PHYSICAL_ADDRESS ='"];
	[query appendString:[connection escapedSQLQuery:[physicalAddress string]]];
	[query appendString:@"', PHONE ='"];
	[query appendString:[connection escapedSQLQuery:[phone stringValue]]];
	[query appendString:@"', FAX ='"];
	[query appendString:[connection escapedSQLQuery:[fax stringValue]]];
	[query appendString:@"', EMAIL ='"];
	[query appendString:[connection escapedSQLQuery:[email stringValue]]];
	[query appendString:@"', WEBSITE ='"];
	[query appendString:[connection escapedSQLQuery:[website stringValue]]];
	[query appendString:@"', FREE_PHONE ='"];
	[query appendString:[connection escapedSQLQuery:[freePhone stringValue]]];
	[query appendString:@"', FREE_FAX ='"];
	[query appendString:[connection escapedSQLQuery:[freeFax stringValue]]];
	[query appendString:@"', COMPANY_PROFILE ='"];
	[query appendString:[connection escapedSQLQuery:[companyProfile string]]];
	[query appendString:@"', PRODUCT_CUSTOMER_MARKET ='"];
	[query appendString:[connection escapedSQLQuery:[productCustomerMarket string]]];
	[query appendString:@"', EXPERTISE ='"];
	[query appendString:[connection escapedSQLQuery:[expertise string]]];
	[query appendString:@"', KEY_BRANDS ='"];
	[query appendString:[connection escapedSQLQuery:[keyBrands string]]];
	[query appendString:@"', TRADE_NAME ='"];
	[query appendString:[connection escapedSQLQuery:[name stringValue]]];
	[query appendString:@"' WHERE STORE_CODE ='"];
	[query appendString:[connection escapedSQLQuery:[storeCode stringValue]]];
	[query appendString:@"';"];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_real_query([connection conn], charQuery, [query length])) {
		NSString *errorMessage;
		errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
		[error openErrorMessage:@"StoreViewController:editStore" withMessage:errorMessage];
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
}

-(IBAction)removeStore:(id) sender
{
	NSLog(@"remove Store \n");
	NSMutableString *query;
	char *charQuery;
	DatabaseSetupConnections *connection;
	
	query = [[NSMutableString alloc]init];
	connection = [DatabaseSetupConnections alloc];
	[connection initWithUser:userLogin];
	[connection connectDatabase];
	
	[query setString:@"DELETE FROM STORE WHERE STORE_CODE ='"];
	[query appendString:[connection escapedSQLQuery:[storeCode stringValue]]];
	[query appendString:@"';"];
	
	charQuery = (char *)xmalloc(sizeof(char [[query length]]));
	
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_real_query([connection conn], charQuery, [query length])) {
		NSString *errorMessage;
		errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
		[error openErrorMessage:@"StoreViewController:removeStore" withMessage:errorMessage];
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
	[self refresh:self];
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
