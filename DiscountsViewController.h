//
//  DiscountsViewController.h
//  Loki_Tools
//
//  Created by Douglas Mason on 20/05/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "User.h"
#import "ErrorMessageViewController.h"


@interface DiscountsViewController : NSObject {
	IBOutlet NSComboBox *supplierCode;
	IBOutlet NSComboBox *storeCode;
	IBOutlet NSComboBox *discountCode;
	IBOutlet NSTextField *discount;
	IBOutlet NSTextField *supplierName;
	IBOutlet NSTextField *storeName;
	
	User *userLogin;
	ErrorMessageViewController *error;
}

-(DiscountsViewController *)initWithUser:(User *)userObject;

-(void)openDiscounts;
-(void)populateDiscountCodes;

-(IBAction)refresh:(id) sender;
-(IBAction)selectSupplier:(id) sender;
-(IBAction)selectStore:(id) sender;
-(IBAction)selectDiscount:(id) sender;
-(IBAction)remove:(id) sender;
-(IBAction)add:(id) sender;
-(IBAction)edit:(id) sender;

@end
