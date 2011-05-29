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

@synthesize supplierName, brandName, productDescription, supplierCode, productCode;

-(SearchNode *)initWithUser:(User *)userObject
{
	self = [super init];
	
	if(self){
		userLogin = userObject;
		[userLogin retain];
		error = [[ErrorMessageViewController alloc]init];
		children = [[NSMutableArray alloc]init];
	}

	return self;
}

-(void)dealloc
{
	[children release];
	[error release];
	[userLogin release];
	[super dealloc];
}

-(int) searchString:(NSString *)string
{
	return 0;
}

-(NSArray *)children
{
	NSMutableString *query;
	char *charQuery;
	SearchSetupConnections *connection;
	MYSQL_RES *res_set;
	MYSQL_ROW row;
	NSArray *childrenCopy;
	
	query = [[NSMutableString alloc]init];
	connection = [SearchSetupConnections alloc];
	[connection initWithUser:userLogin];
	[connection connectDatabase];
	
	if (supplierCode == nil) {
		
	}
	else {
		if (brandName == nil) {
			
		}
		else {
			if (productCode == nil) {
				
			}
			else {
				
			}

		}

	}
	
	[connection disconnectDatabase];
	[connection release];
	[query release];
	return childrenCopy;
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

-(void)populateChildren
{
	
}

@end

