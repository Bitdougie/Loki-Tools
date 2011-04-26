//
//  SearchSetupConnections.m
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


#import "SearchSetupConnections.h"


@implementation SearchSetupConnections

-(SearchSetupConnections *)init
{
	self = [super init];
	
	if (self) {
		productTableName = @"PRODUCT";
		productDescriptionFieldName = @"PRODUCT_DESCRIPTION";
		supplierTableName = @"SUPPLIER";
		supplierTradeNameFieldName = @"TRADE_NAME";
		supplierCodeFieldName = @"SUPPLIER_CODE";
		productSupplierCodeFieldName = @"SUPPLIER_CODE";
	}
	
	return self;
}




-(NSMutableArray *)searchForSupplier: (NSString *)searchKey
{
	NSMutableArray *foundSupplierArray;
	NSMutableArray *sQLQueryWords;
	NSMutableString *queryProductSearch;
	NSUInteger numberOfSearchParameters;
	//MYSQL_RES *supplierResults;

	foundSupplierArray = [[NSMutableArray alloc] init];
	queryProductSearch = [[NSMutableString alloc] init];
	
	sQLQueryWords = [self searchToSQLQuery:searchKey];
	[sQLQueryWords retain];
	
	//Form search query
	
	[queryProductSearch setString:@"SELECT "];
	[queryProductSearch appendString:supplierTableName];
	[queryProductSearch appendString:@"."];
	[queryProductSearch appendString:supplierTradeNameFieldName];
	[queryProductSearch appendString:@" FROM "];
	[queryProductSearch appendString:productTableName];
	[queryProductSearch appendString:@" INNER JOIN "];
	[queryProductSearch appendString:supplierTableName];
	[queryProductSearch appendString:@" ON "];
	[queryProductSearch appendString:productTableName];
	[queryProductSearch appendString:@"."];
	[queryProductSearch appendString:productSupplierCodeFieldName];
	[queryProductSearch appendString:@" = "];
	[queryProductSearch appendString:supplierTableName];
	[queryProductSearch appendString:@"."];
	[queryProductSearch appendString:supplierCodeFieldName];
	[queryProductSearch appendString:@" WHERE "];
	[queryProductSearch appendString:productTableName];
	[queryProductSearch appendString:@"."];
	[queryProductSearch appendString:productDescriptionFieldName];
	[queryProductSearch appendString:@" LIKE %"];
	[queryProductSearch appendString:[sQLQueryWords objectAtIndex: 0]] ;
	[queryProductSearch appendString:@"% "];
	
	numberOfSearchParameters = [sQLQueryWords count];
	
	for(int i = 1; i < numberOfSearchParameters; i++) {
		[queryProductSearch appendString:@"AND "];
		[queryProductSearch appendString:productTableName];
		[queryProductSearch appendString:@"."];
		[queryProductSearch appendString:productDescriptionFieldName];
		[queryProductSearch appendString:@" LIKE %"];
		[queryProductSearch appendString:[sQLQueryWords objectAtIndex: i]];
		[queryProductSearch appendString:@"% "];
	}
	
	[queryProductSearch appendString:@"GROUP BY "];
	[queryProductSearch appendString:supplierTableName];
	[queryProductSearch appendString:@"."];
	[queryProductSearch appendString:supplierTradeNameFieldName];
	[queryProductSearch appendString:@" ;"];
	
	NSLog(@"%@ \n",queryProductSearch);
	
	//Search query has been formed now will be executed
	
	/*
	
	if (mysql_query(conn, <#const char *q#>)) {
		<#statements#>
	}
	*/
	
	
	[foundSupplierArray autorelease];
	[sQLQueryWords release];
	[queryProductSearch release];
	
	return foundSupplierArray;
}

-(NSMutableArray *) searchToSQLQuery: (NSString *) searchKey
{
	//breaks down the query into a subset of logical comparisons with escaped characters
	
	NSMutableArray *sQLQuery;
	NSMutableString *changingSearchKey;
	char *searchKeySnippet;
	char *sQLEscapedString;
	unsigned long int sQLEscapedStringLength;
	unsigned int ESLength;
	NSString *sQLEscapedStringObject;
	NSRange nextSpace;
	NSRange removalRange;
	
	sQLQuery = [[NSMutableArray alloc] init];	
	changingSearchKey = [[NSMutableString alloc] init];
	
	removalRange.location = 0;
	removalRange.length = 0;
	
	[changingSearchKey setString: searchKey];
	

	while ([changingSearchKey rangeOfString:@" "].location != NSNotFound) {
		nextSpace = [changingSearchKey rangeOfString:@" "];
		
		searchKeySnippet = (char*)xmalloc(sizeof([[changingSearchKey substringToIndex:nextSpace.location] UTF8String]));
		ESLength = (2 * [[changingSearchKey substringToIndex:nextSpace.location] length] + 1);
		sQLEscapedString = (char*)xmalloc(sizeof(char [ESLength]));
		
		(void)strcpy(searchKeySnippet,[[changingSearchKey substringToIndex:nextSpace.location] UTF8String]);
		
		sQLEscapedStringLength = mysql_real_escape_string(conn,sQLEscapedString,searchKeySnippet ,
														  [[changingSearchKey substringToIndex:nextSpace.location] length]);
		 
		sQLEscapedStringObject = [[NSString alloc] initWithUTF8String:sQLEscapedString];
		
		[sQLQuery addObject:sQLEscapedStringObject];
		
		[sQLEscapedStringObject autorelease];
		
		removalRange.length = (nextSpace.location + 1);
		
		[changingSearchKey deleteCharactersInRange:removalRange];
		
		free(sQLEscapedString);
		free(searchKeySnippet);
	}
	
	ESLength = (2 * [changingSearchKey length] + 1);
	
	sQLEscapedString = (char*)xmalloc(sizeof(char [ESLength]));
	
	sQLEscapedStringLength = mysql_real_escape_string(conn, sQLEscapedString, [changingSearchKey UTF8String], [changingSearchKey length]);
	
	[sQLQuery addObject:[[NSString alloc] initWithUTF8String:sQLEscapedString]];
	
	free(sQLEscapedString);
	
	[sQLQuery autorelease];
	[changingSearchKey release];
	
	return sQLQuery;
}

@end
