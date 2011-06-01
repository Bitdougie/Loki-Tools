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
	}
	
	return self;
}

-(void)dealloc
{
	if (productCode != nil) {
		[productCode release];
	}
	if (supplierCode != nil) {
		[supplierCode release];
	}
	[userLogin release];
	[error release];
	[super dealloc];
}

-(void)openProductNo:(NSString *)productNo andSupplierCode:(NSString *)supplier
{
	productCode = [[NSString alloc]initWithString:productNo];
	supplierCode = [[NSString alloc]initWithString:supplier];
	
	if (![NSBundle loadNibNamed:@"ProductViewController" owner: self]) {
		[error openErrorMessage:@"ProductViewController:openProductNo" withMessage:@"Could not load ProductViewController.xib"];
		[error setErrorNo:1];
		return;
	}
	
	[self populateWindow];
}

-(void)populateWindow
{
	NSMutableString *query;
	char *charQuery;
	DatabaseSetupConnections *connection;
	MYSQL_RES *res_set;
	MYSQL_ROW row;
	
	query = [[NSMutableString alloc]init];
	connection = [DatabaseSetupConnections alloc];
	[connection initWithUser:userLogin];
	[connection connectDatabase];
	
	[query setString:@"SELECT PRODUCT.SUPPLIER_CODE, PRODUCT.SUPPLIER_PART_NO, PRODUCT.PRODUCT_DESCRIPTION,\
	 PRODUCT.BRAND, PRODUCT.UNIT,PRODUCT.PACK_QUANTITY
}

@end
