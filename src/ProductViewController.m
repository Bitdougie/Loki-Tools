//
//  productViewController.m
//  Loki_Tools
//
//  Created by Douglas Mason on 31/05/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

#import "productViewController.h"
#import "DatabaseSetupConnections.h"


@implementation ProductViewController

-(ProductViewController *)initWithUser:(User *)userObject
{
	self = [super init];
	
	if(self)
	{
		userLogin = userObject;
		[userLogin retain];
		error = [[ErrorMessageViewController alloc]init];
		productCode = [[NSMutableString alloc]init];
		supplierCode = [[NSMutableString alloc]init];
	}
	
	return self;
}

-(void)dealloc
{
	[productCode release];
	[supplierCode release];
	[userLogin release];
	[error release];
	[super dealloc];
}

-(void)openProductNo:(NSString *)newProductNo andSupplierCode:(NSString *)supplier
{
	NSLog(@"openProductNo \n");
	[productCode setString: newProductNo];
	[supplierCode setString: supplier];
	
	if (![NSBundle loadNibNamed:@"ProductViewController" owner: self]) {
		[error openErrorMessage:@"ProductViewController:openProductNo" withMessage:@"Could not load ProductViewController.xib"];
		[error setErrorNo:1];
		return;
	}
	
	[self populateWindow];
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
	BOOL stockedIndent;
	BOOL discontinued;
	
	query = [[NSMutableString alloc]init];
	connection = [DatabaseSetupConnections alloc];
	[connection initWithUser:userLogin];
	[connection connectDatabase];
	
	[query setString:@"SELECT PRODUCT.SUPPLIER_CODE, PRODUCT.SUPPLIER_PART_NO, PRODUCT.PRODUCT_DESCRIPTION,\
	 PRODUCT.BRAND, PRODUCT.UNIT, PRODUCT.PACK_QUANTITY, PRODUCT.CATALOGUE_PAGE, PRODUCT.STOCKED_INDENT, PRODUCT.PRODUCT_DETAILS,\
	 PRODUCT.PROMOTION_DETAILS, PRODUCT.PROMOTION_ID, PRODUCT.PROMO_PAGE_NO, PRODUCT.COMMENTS, PRODUCT.DISCONTINUED\
	 FROM PRODUCT WHERE PRODUCT.SUPPLIER_CODE = '"];
	[query appendString:[connection escapedSQLQuery:(NSString *)supplierCode]];///working on code here
	[query appendString:@"' AND PRODUCT.SUPPLIER_PART_NO = '"];
	[query appendString:[connection escapedSQLQuery:(NSString *)productCode]];
	[query appendString:@"';"];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery,[query UTF8String]);
	
	NSLog(@" %s ",charQuery);
	
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
				
				if (row[8] == NULL) {
					[productDetails setString: @"N/A"];
				}
				else {
					tempString = [[NSString alloc]initWithUTF8String:row[8]];
					[productDetails setString:tempString];
					[tempString release];
				}
				//continue code here for interface

			}
			mysql_free_result(res_set);
		}

	}
	
	[query release];
	[connection disconnectDatabase];
	[connection release];
	free(charQuery);
}

@end
