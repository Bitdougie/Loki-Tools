//
//  DatabaseSetupConnections.h
//  Loki_Tools
//
//  Created by Douglas Mason on 11/02/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <my_global.h>
#import <my_sys.h>
#import <mysql.h>
#import "xLokiProcedures.h"
#import "User.h"

char * stringConvert(NSString *);


@interface DatabaseSetupConnections : NSObject {
	User *userLogin;
	
	MYSQL *conn; //pointer to a connection handler
}

-(DatabaseSetupConnections *) initWithUser: (User *) userObject;

-(int)connectDatabase;
-(void)disconnectDatabase;

@end
