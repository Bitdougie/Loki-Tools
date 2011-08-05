//
//  MySQLProcedures.h
//  Loki_Tools
//
//  Created by Douglas Mason on 4/08/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MySQLProcedures : NSObject {

}

+(NSString *)escapeSQLQuery:(NSString *) rawQuery andError:(NSError **)anError;
+(NSMutableArray *)searchSQLQuery:(NSString *) searchKey andError:(NSError **)anError;

@end
