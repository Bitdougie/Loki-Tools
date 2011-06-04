//
//  StoreViewController.h
//  Loki_Tools
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


#import <Cocoa/Cocoa.h>
#import "ErrorMessageViewController.h"
#import "User.h"
#import "BrowserList.h"


@interface StoreViewController : NSObject <NSBrowserDelegate> {
	IBOutlet NSBrowser *browser;
	IBOutlet NSComboBox *storeCode;
	IBOutlet NSTextField *name;
	IBOutlet NSTextView *postalAddress;
	IBOutlet NSTextView *physicalAddress;
	IBOutlet NSTextField *phone;
	IBOutlet NSTextField *fax;
	IBOutlet NSTextField *email;
	IBOutlet NSTextField *website;
	IBOutlet NSTextField *freePhone;
	IBOutlet NSTextField *freeFax;
	IBOutlet NSTextView *companyProfile;
	IBOutlet NSTextView *productCustomerMarket;
	IBOutlet NSTextView *expertise;
	IBOutlet NSTextView *keyBrands;
	
	ErrorMessageViewController *error;
	User *userLogin;
	BrowserList *rootNode;
}

-(StoreViewController *)initWithUser:(User *)userObject;

-(IBAction)refresh: (id) sender;
-(IBAction)select:(id) sender;
-(IBAction)addStore:(id) sender;
-(IBAction)editStore:(id) sender;
-(IBAction)removeStore:(id) sender;

@end
