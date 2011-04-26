//
//  SearchSetupConnections.h
//  Loki_Tools
//
//  Created by Douglas Mason on 11/02/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DatabaseSetupConnections.h"


@interface SearchSetupConnections : DatabaseSetupConnections {
	NSString *productTableName;
	NSString *productDescriptionFieldName;
	NSString *supplierTradeNameFieldName;
	NSString *supplierTableName;
	NSString *supplierCodeFieldName;
	NSString *productSupplierCodeFieldName;
}

-(NSMutableArray *)searchForSupplier: (NSString *) searchKey;

-(NSMutableArray *)searchToSQLQuery: (NSString *) searchKey;

@end
