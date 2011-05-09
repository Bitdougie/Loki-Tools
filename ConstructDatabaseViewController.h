//
//  ConstructDatabaseViewController.h
//  Loki_Tools
//
//  Created by Douglas Mason on 6/05/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <my_global.h>
#import <my_sys.h>
#import <mysql.h>
#import "User.h"
#import "ErrorMessageViewController.h"


@interface ConstructDatabaseViewController : NSObject {
	IBOutlet NSTextField *newDataBaseName;
	IBOutlet NSWindow *window;
	User *userLogin;
	ErrorMessageViewController *error;
}

-(ConstructDatabaseViewController *)initWithUser: (User *) userObject;

-(void)openConstructDatabase;

-(IBAction)constructDatabase: (id) sender;

@end
