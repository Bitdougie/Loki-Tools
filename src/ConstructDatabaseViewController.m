//
//  ConstructDatabaseViewController.m
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

#import "ConstructDatabaseViewController.h"
#import "DatabaseSetupConnections.h"


@implementation ConstructDatabaseViewController

-(ConstructDatabaseViewController *)initWithUser:(User *)userObject
{
	self = [super init];
	
	if (self) {
		userLogin = userObject;
		[userLogin retain];
		error = [[ErrorMessageViewController alloc]init];
	}
		
	return self;
}

-(void)openConstructDatabase{
	if (![NSBundle loadNibNamed:@"ConstructDatabaseViewController" owner: self]) {
		[error openErrorMessage:@"ConstructDatabaseViewController:openConstructDatabase" withMessage:@"Could not load ConstructDatabaseViewConstroller.xib"];
		[error setErrorNo:1];
	}	
}

-(IBAction)constructDatabase: (id) sender
{
	NSString *databaseName;
	NSString *escapedDatabaseName;
	NSMutableString *query;
	NSString *errorMessage;
	char *charQuery;
	DatabaseSetupConnections *connection;
	databaseName = [newDataBaseName stringValue];
	[databaseName retain];
	
	connection = [DatabaseSetupConnections alloc];
	[connection initWithUser: userLogin];
	
	if([connection connectDatabase])
	{
		[error openErrorMessage:@"ConstructDatabaseViewController:constructDatabase" withMessage:@"Failed to connect to MySQL server"];
		[error setErrorNo:0];
		[connection disconnectDatabase];
		[connection release];
		[databaseName release];
		return;
	}
	
	escapedDatabaseName = [connection escapedSQLQuery:databaseName];
	[escapedDatabaseName retain];
	
	query = [[NSMutableString alloc]initWithString:@"CREATE DATABASE "];
	[query appendString:escapedDatabaseName];
	[query appendString:@";"];
	
	charQuery = (char *)xmalloc(sizeof(char [[query length]]));
	
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_query([connection conn], charQuery ) != 0) {
		errorMessage = [[NSString alloc] initWithUTF8String: mysql_error([connection conn])];
		[error openErrorMessage:@"ChangePasswordViewController:changePassword" withMessage: errorMessage];
		[error setErrorNo:0];
		
		[errorMessage release];
		[connection disconnectDatabase];
		[query release];
		[escapedDatabaseName release];
		[connection release];
		[databaseName release];
		return;
	}

	free(charQuery);
	
	[userLogin setDatabaseName:databaseName];
	[connection disconnectDatabase];
	
	[connection connectDatabase];
	
	[query setString:@"\
	 CREATE TABLE TRADER_TYPE\
	 (TITLE VARCHAR(150) NOT NULL,\
	 SUMMARY VARCHAR(10000),\
	 PERCENT_REBATE DOUBLE SIGNED DEFAULT 0.0,\
	 PRIMARY KEY (TITLE))\
	 ENGINE = InnoDB;\
	 "];
	
	charQuery = (char *)xmalloc(sizeof(char [[query length]]));	
	(void)strcpy(charQuery,[query UTF8String]);	
	
	if (mysql_query([connection conn], charQuery) != 0) {
		errorMessage = [[NSString alloc] initWithUTF8String: mysql_error([connection conn])];
		[error openErrorMessage:@"ChangePasswordViewController:changePassword" withMessage: errorMessage];
		[error setErrorNo:0];

		[errorMessage release];
		free(charQuery);
		[connection disconnectDatabase];		
		[query release];
		[escapedDatabaseName release];
		[connection release];
		[databaseName release];
		return;
	}
	
	free(charQuery);
	
	[query setString:@"\
	 CREATE TABLE SUPPLIER \
	 ( \
	 SUPPLIER_CODE VARCHAR(200) NOT NULL,\
	 TRADE_NAME VARCHAR(200) NOT NULL,\
	 POSTAL_ADDRESS VARCHAR(500) NOT NULL,\
	 PHYSICAL_ADDRESS VARCHAR(500) NOT NULL,\
	 PHONE VARCHAR(150) DEFAULT NULL,\
	 FAX VARCHAR(150) DEFAULT NULL,\
	 EMAIL VARCHAR(250) DEFAULT NULL,\
	 WEBSITE VARCHAR(250) DEFAULT NULL,\
	 FREIGHT_FREE_LIMIT DOUBLE DEFAULT NULL,\
	 TRADER VARCHAR(150) NOT NULL,\
	 LOGO LONGBLOB DEFAULT NULL,\
	 FOREIGN KEY (TRADER) REFERENCES TRADER_TYPE (TITLE),\
	 PRIMARY KEY (SUPPLIER_CODE)\
	 )ENGINE = InnoDB;\
	 "];
	
	charQuery = (char*)xmalloc(sizeof(char[[query length]]));
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_query([connection conn], charQuery) != 0) {
		errorMessage = [[NSString alloc] initWithUTF8String: mysql_error([connection conn])];
		[error openErrorMessage:@"ChangePasswordViewController:changePassword" withMessage: errorMessage];
		[error setErrorNo:0];
		
		[errorMessage release];
		free(charQuery);
		[connection disconnectDatabase];		
		[query release];
		[escapedDatabaseName release];
		[connection release];
		[databaseName release];
		return;
	}

	free(charQuery);
	
	[query setString:@"\
	 CREATE TABLE SUPPLIER_EMPLOYEES\
	 (      \
	 SUPPLIER_CODE VARCHAR(200) NOT NULL,\
	 EMPLOYEE_NAME VARCHAR(200) NOT NULL,\
	 PHONE VARCHAR(150) DEFAULT NULL,\
	 MOBILE VARCHAR(150) DEFAULT NULL,\
	 EMAIL VARCHAR(250) DEFAULT NULL,\
	 ID_PERSON INT UNSIGNED NOT NULL AUTO_INCREMENT,\
	 FOREIGN KEY (SUPPLIER_CODE) REFERENCES SUPPLIER (SUPPLIER_CODE),\
	 PRIMARY KEY (ID_PERSON)\
	 )ENGINE = InnoDB;\
	 "];
	
	charQuery = (char*)xmalloc(sizeof(char[[query length]]));
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_query([connection conn], charQuery) != 0) {
		errorMessage = [[NSString alloc] initWithUTF8String: mysql_error([connection conn])];
		[error openErrorMessage:@"ChangePasswordViewController:changePassword" withMessage: errorMessage];
		[error setErrorNo:0];
		
		[errorMessage release];
		free(charQuery);
		[connection disconnectDatabase];		
		[query release];
		[escapedDatabaseName release];
		[connection release];
		[databaseName release];
		return;
	}	
	
	free(charQuery);
	
	[query setString:@"\
	 CREATE TABLE STORE\
	 (\
	 TRADE_NAME VARCHAR(200) NOT NULL,\
	 POSTAL_ADDRESS VARCHAR(500) NOT NULL,\
	 PHYSICAL_ADDRESS VARCHAR(500) NOT NULL,\
	 PHONE VARCHAR(150) DEFAULT NULL,\
	 FAX VARCHAR(150) DEFAULT NULL,\
	 EMAIL VARCHAR(250) DEFAULT NULL,\
	 WEBSITE VARCHAR(250) DEFAULT NULL,\
	 FREE_PHONE VARCHAR(150) DEFAULT NULL,\
	 FREE_FAX VARCHAR(150) DEFAULT NULL,\
	 COMPANY_PROFILE VARCHAR(10000) DEFAULT NULL,\
	 PRODUCT_CUSTOMER_MARKET VARCHAR(10000) DEFAULT NULL,\
	 EXPERTISE VARCHAR(10000) DEFAULT NULL,\
	 KEY_BRANDS VARCHAR(10000) DEFAULT NULL,\
	 STORE_CODE VARCHAR(200) NOT NULL,\
	 PRIMARY KEY (STORE_CODE)\
	 )ENGINE = InnoDB;\
	 "];
	
	charQuery = (char*)xmalloc(sizeof(char[[query length]]));
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_query([connection conn], charQuery) != 0) {
		errorMessage = [[NSString alloc] initWithUTF8String: mysql_error([connection conn])];
		[error openErrorMessage:@"ChangePasswordViewController:changePassword" withMessage: errorMessage];
		[error setErrorNo:0];
		
		[errorMessage release];
		free(charQuery);
		[connection disconnectDatabase];		
		[query release];
		[escapedDatabaseName release];
		[connection release];
		[databaseName release];
		return;
	}
	
	free(charQuery);
	
	[query setString:@"\
	 CREATE TABLE STORE_EMPLOYEES\
	 (\
	 EMPLOYEE_NAME VARCHAR(250) NOT NULL,\
	 STORE_CODE VARCHAR(200) NOT NULL,\
	 PHONE VARCHAR(150) DEFAULT NULL,\
	 MOBILE VARCHAR(150) DEFAULT NULL,\
	 EMAIL VARCHAR(250) DEFAULT NULL,\
	 ID_EMPLOYEE INT UNSIGNED NOT NULL AUTO_INCREMENT,\
	 PRIMARY KEY (ID_EMPLOYEE),\
	 FOREIGN KEY (STORE_CODE) REFERENCES STORE (STORE_CODE)\
	 )ENGINE = InnoDB;\
	 "];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_query([connection conn], charQuery) != 0) {
		errorMessage = [[NSString alloc] initWithUTF8String: mysql_error([connection conn])];
		[error openErrorMessage:@"ChangePasswordViewController:changePassword" withMessage: errorMessage];
		[error setErrorNo:0];
		
		[errorMessage release];
		free(charQuery);
		[connection disconnectDatabase];		
		[query release];
		[escapedDatabaseName release];
		[connection release];
		[databaseName release];
		return;
	}	
	
	free(charQuery);
	
	[query setString:@"\
	 CREATE TABLE DISCOUNTS\
	 (\
	 SUPPLIER_CODE VARCHAR(200) NOT NULL,\
	 STORE_CODE VARCHAR(200) NOT NULL,\
	 TITLE VARCHAR(250) DEFAULT NULL,\
	 DISCOUNT DOUBLE NOT NULL DEFAULT 0.0,\
	 FOREIGN KEY (SUPPLIER_CODE) REFERENCES SUPPLIER (SUPPLIER_CODE),\
	 FOREIGN KEY (STORE_CODE) REFERENCES STORE (STORE_CODE),\
	 PRIMARY KEY (SUPPLIER_CODE,STORE_CODE,TITLE)\
	 )ENGINE = InnoDB;\
	 "];
	
	charQuery = (char*)xmalloc(sizeof(char[[query length]]));
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_query([connection conn], charQuery) != 0) {
		errorMessage = [[NSString alloc] initWithUTF8String: mysql_error([connection conn])];
		[error openErrorMessage:@"ChangePasswordViewController:changePassword" withMessage: errorMessage];
		[error setErrorNo:0];
		
		[errorMessage release];
		free(charQuery);
		[connection disconnectDatabase];		
		[query release];
		[escapedDatabaseName release];
		[connection release];
		[databaseName release];
		return;
	}
	
	free(charQuery);
	
	[query setString:@"\
	 CREATE TABLE PRODUCT\
	 (\
	 STORE_CODE VARCHAR(200) NOT NULL,\
	 SUPPLIER_CODE VARCHAR(200) NOT NULL,\
	 SUPPLIER_PART_NO VARCHAR(200) NOT NULL,\
	 PRODUCT_DESCRIPTION VARCHAR(1000) NOT NULL,\
	 BRAND VARCHAR(200) DEFAULT NULL,\
	 UNIT VARCHAR(100) DEFAULT NULL,\
	 LIST_PRICE DOUBLE NOT NULL DEFAULT 0.0,\
	 PACK_LIST_PRICE DOUBLE NOT NULL DEFAULT 0.0,\
	 PACK_DISCOUNT_CATAGORY VARCHAR(250) DEFAULT NULL,\
	 BROKEN_PACK_DISCOUNT_CATAGORY VARCHAR(250) DEFAULT NULL,\
	 NETT_CONTRACT_PRICE DOUBLE DEFAULT NULL,\
	 SUPPLIER_BAR_CODE VARCHAR(1000) DEFAULT NULL,\
	 PACK_QUANTITY DOUBLE DEFAULT NULL,\
	 CATALOGUE_PAGE VARCHAR(150) DEFAULT NULL,\
	 STOCKED_INDENT BOOLEAN NOT NULL DEFAULT TRUE,\
	 PRODUCT_DETAILS VARCHAR(10000)DEFAULT NULL,\
	 PICTURE LONGBLOB DEFAULT NULL,\
	 BRAND_LOGO LONGBLOB DEFAULT NULL,\
	 PROMOTION_DETAILS VARCHAR(10000) DEFAULT NULL,\
	 PROMOTION_ID VARCHAR(150) DEFAULT NULL,\
	 PROMO_BUY_PRICE DOUBLE DEFAULT NULL,\
	 STOCK_ON_HAND DOUBLE DEFAULT 0.0,\
	 QUANTITY_TO_ORDER DOUBLE DEFAULT 0.0,\
	 PROMO_SELL_EX_GST DOUBLE DEFAULT NULL,\
	 PROMO_SELL_INC_GST DOUBLE DEFAULT NULL,\
	 PROMO_PAGE_NO VARCHAR(200) DEFAULT NULL,\
	 COMMENTS VARCHAR(10000) DEFAULT NULL,\
	 DISCONTINUED BOOLEAN NOT NULL DEFAULT FALSE,\
	 PRIMARY KEY (SUPPLIER_PART_NO,SUPPLIER_CODE),\
	 FOREIGN KEY (SUPPLIER_CODE,STORE_CODE,PACK_DISCOUNT_CATAGORY) \
	 REFERENCES DISCOUNTS (SUPPLIER_CODE,STORE_CODE,TITLE),\
	 FOREIGN KEY (SUPPLIER_CODE,STORE_CODE,BROKEN_PACK_DISCOUNT_CATAGORY) \
	 REFERENCES DISCOUNTS (SUPPLIER_CODE,STORE_CODE,TITLE)\
	 )ENGINE = InnoDB;\
	 "];
	
	charQuery = (char*)xmalloc(sizeof(char[[query length]]));
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_query([connection conn], charQuery) != 0) {
		errorMessage = [[NSString alloc] initWithUTF8String: mysql_error([connection conn])];
		[error openErrorMessage:@"ChangePasswordViewController:changePassword" withMessage: errorMessage];
		[error setErrorNo:0];
		
		[errorMessage release];
		free(charQuery);
		[connection disconnectDatabase];		
		[query release];
		[escapedDatabaseName release];
		[connection release];
		[databaseName release];
		return;
	}
	
	free(charQuery);
	
	[query setString:@"\
	 CREATE TABLE CUSTOMER\
	 (\
	 STORE_CODE VARCHAR(200) NOT NULL,\
	 CUSTOMER_CODE VARCHAR(200) NOT NULL,\
	 CUSTOMER_NAME VARCHAR(250) NOT NULL,\
	 POSTAL_ADDRESS VARCHAR(500) DEFAULT NULL,\
	 PHYSICAL_ADDRESS VARCHAR(500) DEFAULT NULL,\
	 PHONE_PERSONAL VARCHAR(150) DEFAULT NULL,\
	 PHONE_WORK VARCHAR(150) DEFAULT NULL,\
	 MOBILE VARCHAR(150) DEFAULT NULL,\
	 EMAIL VARCHAR(250) DEFAULT NULL,\
	 PRIMARY KEY(STORE_CODE,CUSTOMER_CODE),\
	 FOREIGN KEY(STORE_CODE) REFERENCES STORE(STORE_CODE)\
	 )ENGINE = InnoDB;\
	 "];
	
	charQuery = (char*)xmalloc(sizeof(char[[query length]]));
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_query([connection conn], charQuery) != 0) {
		errorMessage = [[NSString alloc] initWithUTF8String: mysql_error([connection conn])];
		[error openErrorMessage:@"ChangePasswordViewController:changePassword" withMessage: errorMessage];
		[error setErrorNo:0];
		
		[errorMessage release];
		free(charQuery);
		[connection disconnectDatabase];		
		[query release];
		[escapedDatabaseName release];
		[connection release];
		[databaseName release];
		return;
	}
	
	free(charQuery);
	
	[query setString:@"\
	 CREATE TABLE PRODUCT_STORE\
	 (\
	 STORE_CODE VARCHAR(200) NOT NULL,\
	 PRODUCT_CODE VARCHAR(200) NOT NULL,\
	 PRODUCT_DESCRIPTION VARCHAR(1000) NOT NULL,\
	 SUPPLIER_PART_NO VARCHAR(200) NOT NULL,\
	 SUPPLIER_CODE VARCHAR(200) NOT NULL,\
	 STOCK_GROUP_CODE VARCHAR(200),\
	 SALES_GROUP_CODE VARCHAR(200),\
	 STANDARD_COST DOUBLE NOT NULL,\
	 LATEST_COST DOUBLE,\
	 AVERAGE_COST DOUBLE,\
	 EXCLUSIVE_MARKUP DOUBLE NOT NULL,\
	 MINIMUM_STOCK DOUBLE DEFAULT 0.0,\
	 MAXIMUM_STOCK DOUBLE DEFAULT 0.0,\
	 MINIMUM_STOCK_RECOMMENDED DOUBLE,\
	 MAXIMUM_STOCK_RECOMMENDED DOUBLE,\
	 STOCK_AVAILABLE DOUBLE DEFAULT 0.0,\
	 INACTIVE BOOLEAN,\
	 PRIMARY KEY (STORE_CODE,PRODUCT_CODE),\
	 FOREIGN KEY (STORE_CODE) REFERENCES STORE(STORE_CODE)\
	 )ENGINE = InnoDB;\
	 "];
	
	charQuery = (char*)xmalloc(sizeof(char[[query length]]));
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_query([connection conn], charQuery) != 0) {
		errorMessage = [[NSString alloc] initWithUTF8String: mysql_error([connection conn])];
		[error openErrorMessage:@"ChangePasswordViewController:changePassword" withMessage: errorMessage];
		[error setErrorNo:0];
		
		[errorMessage release];
		free(charQuery);
		[connection disconnectDatabase];		
		[query release];
		[escapedDatabaseName release];
		[connection release];
		[databaseName release];
		return;
	}
	
	free(charQuery);
	
	[query setString:@"\
	 CREATE TABLE TRANSACTIONS\
	 (\
	 STORE_CODE VARCHAR(200) NOT NULL,\
	 TRANSACTION_ID VARCHAR(100) NOT NULL,\
	 CUSTOMER_CODE VARCHAR(200),\
	 PRODUCT_CODE VARCHAR(200) NOT NULL,\
	 TRANSACTION_DAY DATE NOT NULL,\
	 TIME_DAY DATE,\
	 TIME_TIME TIME,\
	 TRANSACTION_QUANTITY DOUBLE NOT NULL,\
	 COST_VALUE_EXCLUSIVE DOUBLE NOT NULL,\
	 SALES_VALUE_EXCLUSIVE DOUBLE DEFAULT 0.0,\
	 TRANSACTION_TYPE VARCHAR(200) NOT NULL,\
	 PRIMARY KEY (STORE_CODE,TRANSACTION_ID),\
	 FOREIGN KEY (STORE_CODE) REFERENCES STORE(STORE_CODE)\
	 )ENGINE = InnoDB;\
	 "];
	
	charQuery = (char*)xmalloc(sizeof(char[[query length]]));
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_query([connection conn], charQuery) != 0) {
		errorMessage = [[NSString alloc] initWithUTF8String: mysql_error([connection conn])];
		[error openErrorMessage:@"ChangePasswordViewController:changePassword" withMessage: errorMessage];
		[error setErrorNo:0];
		
		[errorMessage release];
		free(charQuery);
		[connection disconnectDatabase];		
		[query release];
		[escapedDatabaseName release];
		[connection release];
		[databaseName release];
		return;
	}
	
	free(charQuery);
	
	[query setString:@"\
	 CREATE TABLE LEAD_TIME\
	 (\
	 STORE_CODE VARCHAR(200) NOT NULL,\
	 TRANSACTION_ID VARCHAR(100) NOT NULL,\
	 ORDER_DATE DATE,\
	 RECIEPT_DATE DATE,\
	 PRIMARY KEY (STORE_CODE,TRANSACTION_ID),\
	 FOREIGN KEY (STORE_CODE,TRANSACTION_ID) REFERENCES TRANSACTIONS(STORE_CODE,TRANSACTION_ID)\
	 )ENGINE = InnoDB;\
	 "];
	
	charQuery = (char*)xmalloc(sizeof(char[[query length]]));
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_query([connection conn], charQuery) != 0) {
		errorMessage = [[NSString alloc] initWithUTF8String: mysql_error([connection conn])];
		[error openErrorMessage:@"ChangePasswordViewController:changePassword" withMessage: errorMessage];
		[error setErrorNo:0];
		
		[errorMessage release];
		free(charQuery);
		[connection disconnectDatabase];		
		[query release];
		[escapedDatabaseName release];
		[connection release];
		[databaseName release];
		return;
	}
	
	free(charQuery);
	[connection disconnectDatabase];
	
	[query release];
	[escapedDatabaseName release];
	[connection release];
	[databaseName release];
	[window close];
}

-(void) dealloc
{
	[userLogin release];
	[error release];
	[super dealloc];
}

@end
