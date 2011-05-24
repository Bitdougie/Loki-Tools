//
//  ErrorMessageViewController.m
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
 
 */


#import "ErrorMessageViewController.h"


@implementation ErrorMessageViewController

@synthesize errorNo;

-(void) openErrorMessage: (id) sender withMessage: (NSString *) message
{
	[message retain];
	
	if(![NSBundle loadNibNamed:@"ErrorMessageViewController" owner: self]){
		NSLog(@"Could not load ErrorMessageViewController.xib \n");
	}
	else{
		[errorMessage setStringValue: message];
	}
	[message release];
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
