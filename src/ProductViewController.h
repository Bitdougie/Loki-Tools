//
//  productViewController.h
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
	IBOutlet NSTextView *promoDetails;
	IBOutlet NSTextField *promoID;
	IBOutlet NSTextField *promoPageNo;
	IBOutlet NSComboBox *storeCode;
	IBOutlet NSTextField *price;
	IBOutlet NSTextField *rebatePrice;
	IBOutlet NSTextField *packPrice;
	IBOutlet NSTextField *rebatePackPrice;
	IBOutlet NSTextField *promoPrice;
	IBOutlet NSTextField *promoRebatePrice;
	IBOutlet NSTextField *promoSellExGST;
	IBOutlet NSTextField *promoSellIncGST;
	
	User *userLogin;
	NSString *supplierCode;
	NSString *productCode;
	ErrorMessageViewController *error;
}

@property(nonatomic,copy)NSString *supplierCode;
@property(nonatomic,copy)NSString *productCode;

-(ProductViewController *)initWithUser:(User *)userObject;

-(void)populateWindow;

-(IBAction)selectStoreCode:(id) sender;

@end
