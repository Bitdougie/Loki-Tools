//
//  ChangePasswordViewController.h
//  Loki_Tools
//
//  Created by Douglas Mason on 15/04/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ChangePasswordViewController : NSObject {
	IBOutlet NSSecureTextField *currentPassword;
	IBOutlet NSSecureTextField *newPassword;
	IBOutlet NSSecureTextField *retypedNewPassword;
}



@end
