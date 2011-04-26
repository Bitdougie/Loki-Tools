//
//  LoginViewController.h
//  Loki_Tools
//
//  Created by Douglas Mason on 11/04/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "User.h"
#import "DatabaseSetupConnections.h"


@interface LoginViewController : NSObject {
	IBOutlet NSWindow *loginWindow;
	IBOutlet NSTextField *user;
	IBOutlet NSSecureTextField *password;
	User *userLogin;
}

-(LoginViewController *)initWithUser:(User *)userObject;

-(void) openLogin;

-(IBAction) login: (id) sender;

@end
