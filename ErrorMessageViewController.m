//
//  ErrorMessageViewController.m
//  Loki_Tools
//
//  Created by Douglas Mason on 11/04/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

#import "ErrorMessageViewController.h"


@implementation ErrorMessageViewController

@synthesize errorNo;

-(void) openErrorMessage: (id) sender withMessage: (NSString *) message
{
	[message retain];
	if([errorMessageWindow isVisible])
	{
		[errorMessageWindow orderFront:@"[ErrorMessageViewController openErrorMessage]"];
		[errorMessage setStringValue: message];
	}
	else {
		[NSBundle loadNibNamed:@"ErrorMessageViewController" owner: self];
		[errorMessage setStringValue: message];
	}
	[message autorelease];
}

-(IBAction)procedureOnClose: (id) sender
{
	[errorMessageWindow close];
	
	switch (errorNo) { 
		case 0:
			NSLog(@"Warning: %@",[errorMessage stringValue]);
			break;
		case 1:
			NSLog(@"Error: %@",[errorMessage stringValue]);
			exit(1);
			break;
		default:
			break;
	}
	
}

@end
