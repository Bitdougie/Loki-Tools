//
//  ProductsViewController.m
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

#import "ProductsViewController.h"
#import "DatabaseSetupConnections.h"


@implementation ProductsViewController

-(ProductsViewController *)initWithUser:(User *)userObject
{
	self = [super init];
	
	if(self)
	{
		userLogin = userObject;
		[userLogin retain];
		error = [[ErrorMessageViewController alloc]init];
	}
	return self;
}

-(void)dealloc
{
	[userLogin release];
	[error release];
	[rootNode release];
	[super dealloc];
}

-(IBAction)refresh:(id) sender
{
	NSLog(@"refresh \n");
	NSMutableString *query;
	char *charQuery;
	DatabaseSetupConnections *connection;
	MYSQL_RES *res_set;
	MYSQL_ROW row;
	NSString *tempString;
	
	query = [[NSMutableString alloc]init];
	connection = [DatabaseSetupConnections alloc];
	[connection initWithUser:userLogin];
	[connection connectDatabase];
	
	[query setString:@"SELECT SUPPLIER_CODE FROM SUPPLIER;"];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_real_query([connection conn], charQuery, [query length])) {
		NSString *errorMessage;
		errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
		[error openErrorMessage:@"DiscountsViewController:refresh" withMessage:errorMessage];
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
			[error openErrorMessage:@"DiscountsViewController:refresh" withMessage:errorMessage];
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
				tempString = [[NSString alloc]initWithUTF8String:row[0]];
				[supplierCode addItemWithObjectValue:tempString];
				[tempString release];
			}
			mysql_free_result(res_set);
		}
	}
	
	free(charQuery);
	
	[query setString:@"SELECT SUPPLIER_CODE FROM SUPPLIER;"];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_real_query([connection conn], charQuery, [query length])) {
		NSString *errorMessage;
		errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
		[error openErrorMessage:@"DiscountsViewController:refresh" withMessage:errorMessage];
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
			[error openErrorMessage:@"DiscountsViewController:refresh" withMessage:errorMessage];
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
				tempString = [[NSString alloc]initWithUTF8String:row[0]];
				[storeCode addItemWithObjectValue:tempString];
				[tempString release];
			}
			
			mysql_free_result(res_set);
		}
		
	}
	
	
	[connection disconnectDatabase];
	[connection release];
	[query release];
	free(charQuery);
	
	[supplierCode setStringValue:@""];
	[storeCode setStringValue:@""];
	[storeName setStringValue:@"Store Code:"];
	[supplierName setStringValue:@"Supplier Code:"];
}	

-(IBAction)selectSupplier:(id)sender
{
	NSLog(@"selectSupplier");
	NSMutableString *query;
	char *charQuery;
	DatabaseSetupConnections *connection;
	MYSQL_RES *res_set;
	MYSQL_ROW row;
	NSString *tempString;
	
	query = [[NSMutableString alloc]init];
	connection = [DatabaseSetupConnections alloc];
	[connection initWithUser:userLogin];
	[connection connectDatabase];
	
	[query setString:@"SELECT TRADE_NAME FROM SUPPLIER WHERE SUPPLIER_CODE = '"];
	[query appendString:[connection escapedSQLQuery:[supplierCode stringValue]]];
	[query appendString:@"';"];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_real_query([connection conn], charQuery, [query length])) {
		NSString *errorMessage;
		errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
		[error openErrorMessage:@"DiscountsViewController:selectSupplier" withMessage:errorMessage];
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
			[error openErrorMessage:@"DiscountsViewController:selectSupplier" withMessage:errorMessage];
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
				tempString = [[NSString alloc]initWithUTF8String:row[0]];
				[supplierName setStringValue:tempString];
				[tempString release];
			}
			
			mysql_free_result(res_set);
		}
		
	}
	
	[connection disconnectDatabase];
	[connection release];
	[query release];
	free(charQuery);
}

-(IBAction)selectStore:(id)sender
{
	NSLog(@"select store");
	NSMutableString *query;
	char *charQuery;
	DatabaseSetupConnections *connection;
	MYSQL_RES *res_set;
	MYSQL_ROW row;
	NSString *tempString;
	
	query = [[NSMutableString alloc]init];
	connection = [DatabaseSetupConnections alloc];
	[connection initWithUser:userLogin];
	[connection connectDatabase];
	
	[query setString:@"SELECT TRADE_NAME FROM STORE WHERE STORE_CODE = '"];
	[query appendString:[connection escapedSQLQuery:[storeCode stringValue]]];
	[query appendString:@"';"];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_real_query([connection conn], charQuery, [query length])) {
		NSString *errorMessage;
		errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
		[error openErrorMessage:@"DiscountsViewController:selectStore" withMessage:errorMessage];
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
			[error openErrorMessage:@"DiscountsViewController:selectStore" withMessage:errorMessage];
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
				tempString = [[NSString alloc]initWithUTF8String:row[0]];
				[storeName setStringValue:tempString];
				[tempString release];
			}
			
			mysql_free_result(res_set);
		}
		
	}
	
	[connection disconnectDatabase];
	[connection release];
	[query release];
	free(charQuery);
}	

-(IBAction)pullIn:(id) sender
{
	NSLog(@"PullIn \n");
	NSMutableString *query;
	char *charQuery;
	DatabaseSetupConnections *connection;
	MYSQL_RES *res_set;
	MYSQL_ROW row;
	NSString *tempString;
	
	query = [[NSMutableString alloc]init];
	connection = [DatabaseSetupConnections alloc];
	[connection initWithUser:userLogin];
	[connection connectDatabase];
	
	[query setString:@"LOAD DATA LOCAL INFILE '"];
	[query appendString:[connection escapedSQLQuery:[path stringValue]]];
	[query appendString:@"' REPLACE INTO TABLE PRODUCT FIELDS TERMINATED BY ',' ENCLOSED BY '\"' \
	 (SUPPLIER_PART_NO,  PRODUCT_DESCRIPTION,  BRAND,  UNIT,  @skip,  @skip,  @skip,  @skip, \
	 @skip,  SUPPLIER_BAR_CODE,  PACK_QUANTITY,  CATALOGUE_PAGE,  STOCKED_INDENT,  PRODUCT_DETAILS) \
	 SET SUPPLIER_CODE = '"]; 
	[query appendString:[connection escapedSQLQuery:[supplierCode stringValue]]];
	[query appendString:@"';"];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_real_query([connection conn], charQuery, [query length])) {
		NSString *errorMessage;
		errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
		[error openErrorMessage:@"DiscountsViewController:selectStore" withMessage:errorMessage];
		[error setErrorNo:0];
		
		[errorMessage release];
		[connection disconnectDatabase];
		[connection release];
		[query release];
		free(charQuery);
		return;
	}
	
	free(charQuery);
	
	[query setString:@"SELECT STORE_CODE FROM STORE"];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_real_query([connection conn], charQuery, [query length])) {
		NSString *errorMessage;
		errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
		[error openErrorMessage:@"DiscountsViewController:selectStore" withMessage:errorMessage];
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
			[error openErrorMessage:@"DiscountsViewController:selectStore" withMessage:errorMessage];
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
				free(charQuery);
				
				[query setString:@"LOAD DATA LOCAL INFILE '"];
				[query appendString:[connection escapedSQLQuery:[path stringValue]]];
				[query appendString:@"' REPLACE INTO TABLE PRODUCT_PRICES FIELDS TERMINATED BY ',' ENCLOSED BY '\"' \
				 (SUPPLIER_PART_NO, @skip,  @skip,  @skip,  LIST_PRICE,  PACK_LIST_PRICE,  NETT_CONTRACT_PRICE,  BROKEN_PACK_DISCOUNT_CATAGORY, \
				 PACK_DISCOUNT_CATAGORY,@skip,  @skip,  @skip,  @skip,  @skip) \
				 SET SUPPLIER_CODE = '"]; 
				[query appendString:[connection escapedSQLQuery:[supplierCode stringValue]]];
				[query appendString:@"', STORE_CODE = '"];
				tempString = [[NSString alloc]initWithUTF8String:row[0]];
				[query appendString:[connection escapedSQLQuery:tempString]];
				[tempString release];
				[query appendString:@"';"];
				
				charQuery = (char *)xmalloc(sizeof(char[[query length]]));
				
				(void)strcpy(charQuery,[query UTF8String]);
				
				if (mysql_real_query([connection conn], charQuery, [query length])) {
					if (mysql_errno([connection conn]) != 1452) {
						NSString *errorMessage;
						errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
						[error openErrorMessage:@"DiscountsViewController:selectStore" withMessage:errorMessage];
						[error setErrorNo:0];
						
						[errorMessage release];
						[connection disconnectDatabase];
						[connection release];
						[query release];
						free(charQuery);
						return;
					}
				}
			}
		}

	}
	
	[connection disconnectDatabase];
	[connection release];
	[query release];
	free(charQuery);
}

-(id)rootItemForBrowser:(NSBrowser *)browser
{
	if(rootNode == nil){
		rootNode = [[FileBrowser alloc] initWithURL:[NSURL fileURLWithPath:@"/Users/"]];
	}
	return rootNode;
}

-(NSInteger)browser:(NSBrowser *)browser numberOfChildrenOfItem:(id)item
{
	FileBrowser *node = (FileBrowser *)item;
	return [[node children] count];
}

-(id)browser:(NSBrowser *)browser child:(NSInteger)index ofItem:(id)item
{
	FileBrowser *node = (FileBrowser *)item;
	return [[node children] objectAtIndex:index];
}

-(BOOL)browser:(NSBrowser *)browser isLeafItem:(id) item{
	FileBrowser *node = (FileBrowser *)item;
	if (![node isDirectory]) {
		[path setStringValue:[node fullFilePath]];
	}
	else {
		[path setStringValue:@"Nothing Currently Selected ... :-("];
	}

	return ![node isDirectory];
}

-(id)browser:(NSBrowser *)browser objectValueForItem:(id) item{

	FileBrowser *node = (FileBrowser *)item;
	return [node displayName];
}

@end
