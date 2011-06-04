//
//  productViewController.h
//  Loki_Tools
//
//  Created by Douglas Mason on 31/05/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "User.h"
#import "ErrorMessageViewController.h"

@interface ProductViewController : NSObject {
	IBOutlet NSTextField *supplierCodeText;
	IBOutlet NSTextField *productNo;
	IBOutlet NSTextField *description;
	IBOutlet NSTextField *brand;
	IBOutlet NSTextField *productUnits;
	IBOutlet NSTextField *productPackQuantity;
	IBOutlet NSTextField *cataloguePage;
	IBOutlet NSTextField *stocked;
	IBOutlet NSTextView *productDetails;
	IBOutlet NSTextView *productComment;
	
	User *userLogin;
	NSString *supplierCode;
	NSString *productCode;
	ErrorMessageViewController *error;
}

@property(nonatomic,copy)NSString *supplierCode;
@property(nonatomic,copy)NSString *productCode;

-(ProductViewController *)initWithUser:(User *)userObject;

-(void)openProductNo:(NSString *)productNo andSupplierCode:(NSString *) supplier;

-(void)populateWindow;

@end
