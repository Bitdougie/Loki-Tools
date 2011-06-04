//
//  DiscountsViewController.h
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

-(void)populateDiscountCodes;

-(IBAction)refresh:(id) sender;
-(IBAction)selectSupplier:(id) sender;
-(IBAction)selectStore:(id) sender;
-(IBAction)selectDiscount:(id) sender;
-(IBAction)remove:(id) sender;
-(IBAction)add:(id) sender;
-(IBAction)edit:(id) sender;

@end
