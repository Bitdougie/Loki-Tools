//
//  productViewController.m
//  Loki_Tools
//
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

#import "productViewController.h"
#import "DatabaseSetupConnections.h"


@implementation ProductViewController

@synthesize productCode, supplierCode;

-(ProductViewController *)initWithUser:(User *)userObject
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
	[super dealloc];
}

-(void)populateWindow
{
	NSLog(@"populateWindow");
	NSMutableString *query;
	char *charQuery;
	DatabaseSetupConnections *connection;
	MYSQL_RES *res_set;
	MYSQL_ROW row;
	NSString *tempString;
	
	[storeCode removeAllItems];
	
	query = [[NSMutableString alloc]init];
	connection = [DatabaseSetupConnections alloc];
	[connection initWithUser:userLogin];
	[connection connectDatabase];
	
	[query setString:@"SELECT PRODUCT.SUPPLIER_CODE, PRODUCT.SUPPLIER_PART_NO, PRODUCT.PRODUCT_DESCRIPTION,\
	 PRODUCT.BRAND, PRODUCT.UNIT, PRODUCT.PACK_QUANTITY, PRODUCT.CATALOGUE_PAGE, PRODUCT.STOCKED_INDENT, PRODUCT.PRODUCT_DETAILS,\
	 PRODUCT.PROMOTION_DETAILS, PRODUCT.PROMOTION_ID, PRODUCT.PROMO_PAGE_NO, PRODUCT.COMMENTS, PRODUCT.DISCONTINUED\
	 FROM PRODUCT WHERE PRODUCT.SUPPLIER_CODE = '"];
	[query appendString:[connection escapedSQLQuery:supplierCode]];///working on code here
	[query appendString:@"' AND PRODUCT.SUPPLIER_PART_NO = '"];
	[query appendString:[connection escapedSQLQuery:productCode]];
	[query appendString:@"';"];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_real_query([connection conn], charQuery, [query length])) {
		NSString *errorMessage;
		errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
		[error openErrorMessage:@"ProductViewController:populateWindow" withMessage:errorMessage];
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
			[error openErrorMessage:@"ProductViewController:populateWindow" withMessage:errorMessage];
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
				[supplierCodeText setStringValue:tempString];
				[tempString release];
				
				tempString = [[NSString alloc]initWithUTF8String:row[1]];
				[productNo setStringValue:tempString];
				[tempString release];
				
				tempString = [[NSString alloc]initWithUTF8String:row[2]];
				[description setStringValue:tempString];
				[tempString release];
				
				if (row[3] == NULL) {
					[brand setStringValue:@"No Brand"];
				}
				else {
					tempString = [[NSString alloc]initWithUTF8String:row[3]];
					if ([tempString isEqualToString:@""]) {
						[brand setStringValue:@"No Brand"];
					}
					else{
						[brand setStringValue:tempString];
						[tempString release];
					}
				}
				
				if (row[4] == NULL) {
					[productUnits setStringValue:@"N/A"];
				}
				else {
					tempString = [[NSString alloc]initWithUTF8String:row[4]];
					[productUnits setStringValue:tempString];
					[tempString release];
				}
				
				if (row[5] == NULL) {
					[productPackQuantity setStringValue:@"N/A"];
				}
				else {
					tempString = [[NSString alloc]initWithUTF8String:row[5]];
					[productPackQuantity setStringValue:tempString];
					[tempString release];
				}
				
				if (row[6] == NULL) {
					[cataloguePage setStringValue:@"N/A"];
				}
				else {
					tempString = [[NSString alloc]initWithUTF8String:row[6]];
					[cataloguePage setStringValue:tempString];
					[tempString release];
				}
				
				if (row[13] == 0 ) {
					[stocked setStringValue:@"discontinued"];
				}
				else {
					if (row[7] != 0) {
						[stocked setStringValue:@"Indent"];
					}
					else {
						[stocked setStringValue:@"stocked"];
					}
				}

				if (row[8] == NULL) {
					[productDetails setString: @"N/A"];
				}
				else {
					tempString = [[NSString alloc]initWithUTF8String:row[8]];
					[productDetails setString:tempString];
					[tempString release];
				}
				
				if (row[9] == NULL) {
					[promoDetails setString:@"N/A"];
				}
				else {
					tempString = [[NSString alloc]initWithUTF8String:row[9]];
					[promoDetails setString:tempString];
					[tempString release];
				}
				
				if (row[10] == NULL) {
					[promoID setStringValue:@"N/A"];
				}
				else {
					tempString = [[NSString alloc]initWithUTF8String:row[10]];
					[promoID setStringValue:tempString];
					[tempString release];
				}

				if (row[11] == NULL) {
					[promoPageNo setStringValue: @"N/A"];
				}
				else {
					tempString = [[NSString alloc]initWithUTF8String:row[11]];
					[promoID setStringValue:tempString];
					[tempString release];
				}
				
				if (row[12] == NULL) {
					[productComment setString:@"N/A"];
				}
				else {
					tempString = [[NSString alloc]initWithUTF8String:row[12]];
					[productComment setString:tempString];
					[tempString release];
				}

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
		[error openErrorMessage:@"ProductViewController:populateWindow" withMessage:errorMessage];
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
			[error openErrorMessage:@"ProductViewController:populateWindow" withMessage:errorMessage];
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
	
	[query release];
	[connection disconnectDatabase];
	[connection release];
	free(charQuery);
}

-(IBAction)selectStoreCode:(id) sender
{
	NSLog(@"selectStoreCode \n");
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
	
	[query setString:@"SELECT (PRODUCT_PRICES.LIST_PRICE - (PRODUCT_PRICES.LIST_PRICE * (DISCOUNTS.DISCOUNT/100))), \
	 (PRODUCT_PRICES.LIST_PRICE - (PRODUCT_PRICES.LIST_PRICE * (DISCOUNTS.DISCOUNT/100))) - \
	 ((PRODUCT_PRICES.LIST_PRICE - (PRODUCT_PRICES.LIST_PRICE * (DISCOUNTS.DISCOUNT/100))) * (TRADER_TYPE.PERCENT_REBATE)) \
	 FROM PRODUCT_PRICES INNER JOIN DISCOUNTS ON PRODUCT_PRICES.BROKEN_PACK_DISCOUNT_CATAGORY = DISCOUNTS.TITLE \
	 AND PRODUCT_PRICES.SUPPLIER_CODE = DISCOUNTS.SUPPLIER_CODE AND PRODUCT_PRICES.STORE_CODE = DISCOUNTS.STORE_CODE INNER JOIN \
	 SUPPLIER ON SUPPLIER.SUPPLIER_CODE = DISCOUNTS.SUPPLIER_CODE INNER JOIN TRADER_TYPE ON SUPPLIER.TRADER = TRADER_TYPE.TITLE WHERE \
	 PRODUCT_PRICES.SUPPLIER_CODE = '" ];
	[query appendString:[connection escapedSQLQuery:supplierCode]];
	[query appendString:@"' AND PRODUCT_PRICES.SUPPLIER_PART_NO = '"];
	[query appendString:[connection escapedSQLQuery:productCode]];
	[query appendString:@"' AND PRODUCT_PRICES.STORE_CODE = '"];
	[query appendString:[connection escapedSQLQuery:[storeCode stringValue]]];
	[query appendString:@"';"];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery, [query UTF8String]);
	
	NSLog(@" %s ", charQuery);
	
	if (mysql_real_query([connection conn], charQuery, [query length])) {
		NSString *errorMessage;
		errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
		[error openErrorMessage:@"ProductViewController:selectStoreCode" withMessage:errorMessage];
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
			[error openErrorMessage:@"ProductViewController:selectStoreCode" withMessage:errorMessage];
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
				[price setStringValue:tempString];
				[tempString release];
				tempString = [[NSString alloc]initWithUTF8String:row[1]];
				[rebatePrice setStringValue:tempString];
				[tempString release];
			}
			mysql_free_result(res_set);
		}
	}
	
	free(charQuery);
	
	[query setString:@"SELECT (PRODUCT_PRICES.PACK_LIST_PRICE - (PRODUCT_PRICES.PACK_LIST_PRICE * (DISCOUNTS.DISCOUNT/100))), \
	 (PRODUCT_PRICES.PACK_LIST_PRICE - (PRODUCT_PRICES.PACK_LIST_PRICE * (DISCOUNTS.DISCOUNT/100))) - \
	 ((PRODUCT_PRICES.PACK_LIST_PRICE - (PRODUCT_PRICES.PACK_LIST_PRICE * (DISCOUNTS.DISCOUNT/100))) * (TRADER_TYPE.PERCENT_REBATE)) \
	 FROM PRODUCT_PRICES INNER JOIN DISCOUNTS ON PRODUCT_PRICES.PACK_DISCOUNT_CATAGORY = DISCOUNTS.TITLE \
	 AND PRODUCT_PRICES.SUPPLIER_CODE = DISCOUNTS.SUPPLIER_CODE AND PRODUCT_PRICES.STORE_CODE = DISCOUNTS.STORE_CODE INNER JOIN \
	 SUPPLIER ON SUPPLIER.SUPPLIER_CODE = DISCOUNTS.SUPPLIER_CODE INNER JOIN TRADER_TYPE ON SUPPLIER.TRADER = TRADER_TYPE.TITLE WHERE \
	 PRODUCT_PRICES.SUPPLIER_CODE = '" ];
	[query appendString:[connection escapedSQLQuery:supplierCode]];
	[query appendString:@"' AND PRODUCT_PRICES.SUPPLIER_PART_NO = '"];
	[query appendString:[connection escapedSQLQuery:productCode]];
	[query appendString:@"' AND PRODUCT_PRICES.STORE_CODE = '"];
	[query appendString:[connection escapedSQLQuery:[storeCode stringValue]]];
	[query appendString:@"';"];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery, [query UTF8String]);
	
	NSLog(@" %s ", charQuery);
	
	if (mysql_real_query([connection conn], charQuery, [query length])) {
		NSString *errorMessage;
		errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
		[error openErrorMessage:@"ProductViewController:selectStoreCode" withMessage:errorMessage];
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
			[error openErrorMessage:@"ProductViewController:selectStoreCode" withMessage:errorMessage];
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
				[packPrice setStringValue:tempString];
				[tempString release];
				tempString = [[NSString alloc]initWithUTF8String:row[1]];
				[rebatePackPrice setStringValue:tempString];
				[tempString release];
			}
			mysql_free_result(res_set);
		}
	}
	
	free(charQuery);
	
	[query setString:@"SELECT PRODUCT_PRICES.PROMO_BUY_PRICE, (PRODUCT_PRICES.PROMO_BUY_PRICE - (PRODUCT_PRICES.PROMO_BUY_PRICE * TRADER_TYPE.PERCENT_REBATE)) ,\
	 PRODUCT_PRICES.PROMO_SELL_EX_GST, PRODUCT_PRICES.PROMO_SELL_INC_GST \
	 FROM PRODUCT_PRICES INNER JOIN SUPPLIER ON PRODUCT_PRICES.SUPPLIER_CODE = SUPPLIER.SUPPLIER_CODE INNER JOIN \
	 TRADER_TYPE ON SUPPLIER.TRADER = TRADER_TYPE.TITLE WHERE PRODUCT_PRICES.SUPPLIER_CODE = '"];
	[query appendString:[connection escapedSQLQuery:supplierCode]];
	[query appendString:@"' AND PRODUCT_PRICES.SUPPLIER_PART_NO = '"];
	[query appendString:[connection escapedSQLQuery:productCode]];
	[query appendString:@"' AND PRODUCT_PRICES.STORE_CODE = '"];
	[query appendString:[connection escapedSQLQuery:[storeCode stringValue]]];
	[query appendString:@"';"];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery, [query UTF8String]);
	
	NSLog(@" %s ", charQuery);
	
	if (mysql_real_query([connection conn], charQuery, [query length])) {
		NSString *errorMessage;
		errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
		[error openErrorMessage:@"ProductViewController:selectStoreCode" withMessage:errorMessage];
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
			[error openErrorMessage:@"ProductViewController:selectStoreCode" withMessage:errorMessage];
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
				if (row[0] == NULL) {
					[promoPrice setStringValue:@"N/A"];
				}
				else {
					tempString = [[NSString alloc]initWithUTF8String:row[0]];
					[promoPrice setStringValue:tempString];
					[tempString release];
				}
				
				if(row[1] == NULL){
					[promoRebatePrice setStringValue:@"N/A"];
				}
				else{
					tempString = [[NSString alloc]initWithUTF8String:row[1]];
					[promoRebatePrice setStringValue:tempString];
					[tempString release];
				}
				
				if (row[2] == NULL) {
					[promoSellExGST setStringValue:@"N/A"];
				}
				else {
					tempString = [[NSString alloc]initWithUTF8String:row[2]];
					[promoSellExGST setStringValue:tempString];
					[tempString release];
				}
				
				if (row[3] == NULL) {
					[promoSellIncGST setStringValue:@"N/A"];
				}
				else {
					tempString = [[NSString alloc]initWithUTF8String:row[3]];
					[promoSellIncGST setStringValue:tempString];
					[tempString release];
				}
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
