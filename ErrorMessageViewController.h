//
//  ErrorMessageViewController.h
//  Loki_Tools
//
//  Created by Douglas Mason on 11/04/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ErrorMessageViewController : NSObject {
	IBOutlet NSWindow *errorMessageWindow;
	IBOutlet NSTextField *errorMessage;
	int errorNo;
}

@property(nonatomic)int errorNo;

-(void)openErrorMessage: (id) sender withMessage: (NSString *) message;

-(IBAction)procedureOnClose: (id) sender;


@end
