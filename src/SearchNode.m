//
//  SearchNode.m
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
 
 Loki Tools  Copyright (C) 2011  Douglas Mason
 This program comes with ABSOLUTELY NO WARRANTY;
 */


#import "SearchNode.h"
#import "SearchSetupConnections.h"

@implementation SearchNode

@synthesize supplierName, brandName, productDescription, supplierCode, productCode, searchString;

-(SearchNode *)initWithUser:(User *)userObject
{
	self = [super init];
	
	if(self){
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

-(NSMutableArray *)children
{
	NSMutableString *query;
	char *charQuery;
	SearchSetupConnections *connection;
	MYSQL_RES *res_set;
	MYSQL_ROW row;
	NSArray *searchStrings;
	NSMutableArray *children;
	NSString *tempString;
	SearchNode *tempNode;

	query = [[NSMutableString alloc]init];
	connection = [SearchSetupConnections alloc];
	[connection initWithUser:userLogin];
	[connection connectDatabase];
	children = [[NSMutableArray alloc]init];
	
	if (supplierCode == nil) {
		[query setString:@" SELECT PRODUCT.SUPPLIER_CODE, SUPPLIER.TRADE_NAME FROM PRODUCT INNER JOIN SUPPLIER ON \
		 SUPPLIER.SUPPLIER_CODE = PRODUCT.SUPPLIER_CODE WHERE PRODUCT.PRODUCT_DESCRIPTION LIKE '%"];
		searchStrings = [connection searchToSQLQuery:[self searchString]];
		[query appendString:[[searchStrings objectAtIndex:0]stringValue]];
		[query appendString:@"%' "];

		for(int i = 1; i < [searchStrings count]; i++)
		{
			[query appendString:@"AND PRODUCT.PRODUCT_DESCRIPTION LIKE '%"];
			[query appendString:[[searchStrings objectAtIndex:i]stringValue]];
			[query appendString:@"%' "];
		}

		[query appendString:@";"];
		
		charQuery = (char *)xmalloc(sizeof(char[[query length]]));
		(void)strcpy(charQuery,[query UTF8String]);
		
		if (mysql_real_query([connection conn], charQuery, [query length])) {
			NSString *errorMessage;
			errorMessage = [[NSString alloc] initWithUTF8String:mysql_error([connection conn])];
			[error openErrorMessage:@"SearchNode:children" withMessage:errorMessage];
			[error setErrorNo:0];
			
			[errorMessage release];
			free(charQuery);
			[connection disconnectDatabase];
			[connection release];
			[query release];
			[children autorelease];
			return children;
		}
		else {
			res_set = mysql_store_result([connection conn]);
			
			if (res_set == NULL) {
				NSString *errorMessage;
				errorMessage = [[NSString alloc] initWithUTF8String:mysql_error([connection conn])];
				[error openErrorMessage:@"SearchNode:children" withMessage:errorMessage];
				[error setErrorNo:0];
				
				[errorMessage release];
				[connection disconnectDatabase];
				[connection release];
				[query release];
				free(charQuery);
				[children autorelease];
				return children;
			}
			else{
				while ((row = mysql_fetch_row(res_set)) != NULL) {
					tempNode = [SearchNode alloc];
					[tempNode initWithUser:userLogin];
					[tempNode setSearchString:[self searchString]];
					tempString = [[NSString alloc]initWithUTF8String:row[0]];
					[tempNode setSupplierCode:tempString];
					[tempString release];
					tempString = [[NSString alloc]initWithUTF8String:row[1]];
					[tempNode setSupplierName:tempString];
					[children addObject:tempNode];
					[tempNode release];
				}
				mysql_free_result(res_set);
			}
			
		}

	}
	else {
		if (brandName == nil) {
			[query setString:@" SELECT PRODUCT.BRAND FROM PRODUCT WHERE PRODUCT.SUPPLIER_CODE ='"];
			[query appendString:[connection escapedSQLQuery:[self supplierCode]]];
			[query appendString:@"' AND PRODUCT.PRODUCT_DESCRIPTION LIKE '%"];
			searchStrings = [connection searchToSQLQuery:[self searchString]];
			[query appendString:[[searchStrings objectAtIndex:0]stringValue]];
			[query appendString:@"%' "];
			
			for(int i = 1; i < [searchStrings count]; i++)
			{
				[query appendString:@"AND PRODUCT.PRODUCT_DESCRIPTION LIKE '%"];
				[query appendString:[[searchStrings objectAtIndex:i]stringValue]];
				[query appendString:@"%' "];
			}
			
			[query appendString:@";"];
			
			charQuery = (char *)xmalloc(sizeof(char[[query length]]));
			
			(void)strcpy(charQuery,[query UTF8String]);
			
			if (mysql_real_query([connection conn], charQuery, [query length])) {
				NSString *errorMessage;
				errorMessage = [[NSString alloc] initWithUTF8String:mysql_error([connection conn])];
				[error openErrorMessage:@"SearchNode:children" withMessage:errorMessage];
				[error setErrorNo:0];
				
				[errorMessage release];
				free(charQuery);
				[connection disconnectDatabase];
				[connection release];
				[query release];
				[children autorelease];
				return children;
			}
			else {
				res_set = mysql_store_result([connection conn]);
				
				if (res_set == NULL) {
					NSString *errorMessage;
					errorMessage = [[NSString alloc] initWithUTF8String:mysql_error([connection conn])];
					[error openErrorMessage:@"SearchNode:children" withMessage:errorMessage];
					[error setErrorNo:0];
					
					[errorMessage release];
					[connection disconnectDatabase];
					[connection release];
					[query release];
					free(charQuery);
					[children autorelease];
					return children;
				}
				else{
					while ((row = mysql_fetch_row(res_set)) != NULL) {
						tempNode = [SearchNode alloc];
						[tempNode initWithUser:userLogin];
						[tempNode setSearchString:[self searchString]];
						[tempNode setSupplierCode:[self supplierCode]];
						[tempNode setSupplierName:[self supplierName]];
						tempString = [[NSString alloc]init];
						[tempString initWithUTF8String:row[0]];
						[tempNode setBrandName:tempString];
						[children addObject:tempNode];
						[tempNode release];
						[tempString release];
					}
					mysql_free_result(res_set);
				}
			}

			
		}
		else {
			if (productCode == nil) {
				[query setString:@"SELECT PRODUCT.PRODUCT_DESCRIPTION, PRODUCT.SUPPLIER_PART_NO FROM PRODUCT WHERE PRODUCT.SUPPLIER_CODE ='"];
				[query appendString:[connection escapedSQLQuery:[self supplierCode]]];
				[query appendString:@"' AND PRODUCT.BRAND = '"];
				[query appendString:[connection escapedSQLQuery:[self brandName]]];
				[query appendString:@"' AND PRODUCT.PRODUCT_DESCRIPTION LIKE '%"];
				searchStrings = [connection searchToSQLQuery:[self searchString]];
				[query appendString:[[searchStrings objectAtIndex:0]stringValue]];
				[query appendString:@"%' "];
				
				for(int i = 1; i < [searchStrings count]; i++)
				{
					[query appendString:@"AND PRODUCT.PRODUCT_DESCRIPTION LIKE '%"];
					[query appendString:[[searchStrings objectAtIndex:i]stringValue]];
					[query appendString:@"%' "];
				}
				
				charQuery = (char *)xmalloc(sizeof(char[[query length]]));
				
				(void)strcpy(charQuery,[query UTF8String]);
				
				if (mysql_real_query([connection conn], charQuery, [query length])) {
					NSString *errorMessage;
					errorMessage = [[NSString alloc] initWithUTF8String:mysql_error([connection conn])];
					[error openErrorMessage:@"SearchNode:children" withMessage:errorMessage];
					[error setErrorNo:0];
					
					[errorMessage release];
					free(charQuery);
					[connection disconnectDatabase];
					[connection release];
					[query release];
					[children autorelease];
					return children;
				}
				else {
					res_set = mysql_store_result([connection conn]);
					
					if (res_set == NULL) {
						NSString *errorMessage;
						errorMessage = [[NSString alloc] initWithUTF8String:mysql_error([connection conn])];
						[error openErrorMessage:@"SearchNode:children" withMessage:errorMessage];
						[error setErrorNo:0];
						
						[errorMessage release];
						[connection disconnectDatabase];
						[connection release];
						[query release];
						free(charQuery);
						[children autorelease];
						return children;
					}
					else{
						while ((row = mysql_fetch_row(res_set)) != NULL) {
							tempNode = [SearchNode alloc];
							[tempNode initWithUser:userLogin];
							[tempNode setSearchString:[self searchString]];
							[tempNode setSupplierCode:[self supplierCode]];
							[tempNode setSupplierName:[self supplierName]];
							[tempNode setBrandName:[self brandName]];
							tempString = [[NSString alloc]initWithUTF8String:row[0]];
							[tempNode setProductDescription:tempString];
							[tempString release];
							tempString = [[NSString alloc]initWithUTF8String:row[1]];
							[tempNode setProductDescription:tempString];
							[tempString release];
							[children addObject:tempNode];
							[tempNode release];
						}
						mysql_free_result(res_set);
					}
				}
			}
		}

	}
	
	[connection disconnectDatabase];
	[connection release];
	[query release];
	free(charQuery);
	[children autorelease];
	return children;
}

-(BOOL)isProduct
{
	if (productCode == nil) {
		return FALSE;
	}
	else {
		return TRUE;
	}

}

@end

