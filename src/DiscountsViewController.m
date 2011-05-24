//
//  DiscountsViewController.m
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

#import "DiscountsViewController.h"
#import "DatabaseSetupConnections.h"


@implementation DiscountsViewController

-(DiscountsViewController *)initWithUser:(User *)userObject
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
	[error release];
	[userLogin release];
	[super dealloc];
}

-(void)openDiscounts
{
	NSLog(@"openDiscounts \n");
	if (![NSBundle loadNibNamed:@"DiscountsViewController" owner: self]) {
		[error openErrorMessage:@"DiscountsViewController:openDiscounts" withMessage:@"Could not load DiscountsViewController.xib"];
		[error setErrorNo:1];
	}
	
	[self refresh:self];
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
	
	[query setString:@"SELECT STORE_CODE FROM STORE;"];
	
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
	
	[discountCode setStringValue:@""];
	[discount setStringValue:@""];
	[supplierCode setStringValue:@""];
	[storeCode setStringValue:@""];
	[storeName setStringValue:@"Store Code:"];
	[supplierName setStringValue:@"Supplier Code:"];
}

-(IBAction)selectSupplier:(id)sender
{
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
	[self populateDiscountCodes];
}

-(IBAction)selectStore:(id)sender
{
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
	[self populateDiscountCodes];
}

-(IBAction)selectDiscount:(id) sender
{
	NSLog(@"selectDiscount \n");
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
	
	[query setString:@"SELECT DISCOUNT FROM DISCOUNTS WHERE SUPPLIER_CODE ='"];
	[query appendString:[connection escapedSQLQuery:[supplierCode stringValue]]];
	[query appendString:@"' AND STORE_CODE ='"];
	[query appendString:[connection escapedSQLQuery:[storeCode stringValue]]];
	[query appendString:@"' AND TITLE ='"];
	[query appendString:[connection escapedSQLQuery:[discountCode stringValue]]];
	[query appendString:@"';"];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery,[query UTF8String]);

	if (mysql_real_query([connection conn], charQuery, [query length])) {
		NSString *errorMessage;
		errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
		[error openErrorMessage:@"DiscountsViewController:selectDiscount" withMessage:errorMessage];
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
			[error openErrorMessage:@"DiscountsViewController:selectDiscount" withMessage:errorMessage];
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
				[discount setStringValue:tempString];
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
	
	[query setString:@"DELETE FROM DISCOUNTS WHERE SUPPLIER_CODE = '"];
	[query appendString:[connection escapedSQLQuery:[supplierCode stringValue]]];
	[query appendString:@"' AND STORE_CODE ='"];
	[query appendString:[connection escapedSQLQuery:[storeCode stringValue]]];
	[query appendString:@"' AND TITLE ='"];
	[query appendString:[connection escapedSQLQuery:[discountCode stringValue]]];
	[query appendString:@"';"];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_real_query([connection conn], charQuery, [query length])) {
		NSString *errorMessage;
		errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
		[error openErrorMessage:@"DiscountsViewController:remove" withMessage:errorMessage];
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
	[self populateDiscountCodes];
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
	
	[query setString:@"INSERT INTO  DISCOUNTS VALUES('"];
	[query appendString:[connection escapedSQLQuery:[supplierCode stringValue]]];
	[query appendString:@"','"];
	[query appendString:[connection escapedSQLQuery:[storeCode stringValue]]];
	[query appendString:@"','"];
	[query appendString:[connection escapedSQLQuery:[discountCode stringValue]]];
	[query appendString:@"',"];
	[query appendFormat:@"%f",[discount doubleValue]];
	[query appendString:@");"];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_real_query([connection conn], charQuery, [query length])) {
		NSString *errorMessage;
		errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
		[error openErrorMessage:@"DiscountsViewController:add" withMessage:errorMessage];
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

-(IBAction)edit:(id) sender
{
	NSLog(@"edit \n");
	NSMutableString *query;
	char *charQuery;
	DatabaseSetupConnections *connection;
	
	query =[[NSMutableString alloc]init];
	connection = [DatabaseSetupConnections alloc];
	[connection initWithUser:userLogin];
	[connection connectDatabase];
	
	[query setString:@"UPDATE DISCOUNTS SET DISCOUNT = "];
	[query appendFormat:@"%f",[discount doubleValue]];
	[query appendString:@"	WHERE SUPPLIER_CODE ='"];
	[query appendString:[connection escapedSQLQuery:[supplierCode stringValue]]];
	[query appendString:@"' AND STORE_CODE ='"];
	[query appendString:[connection escapedSQLQuery:[storeCode stringValue]]];
	[query appendString:@"' AND TITLE ='"];
	[query appendString:[connection escapedSQLQuery:[discountCode stringValue]]];
	[query appendString:@"';"];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_real_query([connection conn], charQuery, [query length])) {
		NSString *errorMessage;
		errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
		[error openErrorMessage:@"DiscountsViewController:add" withMessage:errorMessage];
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

-(void)populateDiscountCodes
{
	NSLog(@"populateDiscountCodes \n");
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
	
	[discountCode removeAllItems];
	[discountCode setStringValue:@""];
	[discount setStringValue:@""];
	
	[query setString:@"SELECT TITLE FROM DISCOUNTS WHERE SUPPLIER_CODE ='"];
	[query appendString:[connection escapedSQLQuery:[supplierCode stringValue]]];
	[query appendString:@"' AND STORE_CODE ='"];
	[query appendString:[connection escapedSQLQuery:[storeCode stringValue]]];
	[query appendString:@"';"];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_real_query([connection conn], charQuery, [query length])) {
		NSString *errorMessage;
		errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
		[error openErrorMessage:@"DiscountsViewController:populateDiscountCodes" withMessage:errorMessage];
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
			[error openErrorMessage:@"DiscountsViewController:populateDiscountCodes" withMessage:errorMessage];
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
				[discountCode addItemWithObjectValue:tempString];
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



@end
