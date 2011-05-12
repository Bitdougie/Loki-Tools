//
//  SupplierProduct.h
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
 */

#import <Cocoa/Cocoa.h>


@interface SupplierProduct : NSObject {
	NSString *storeCode;
	NSString *supplierCode;
	NSString *supplierPartNo;
	NSString *productDescription;
	NSString *brand;
	NSString *unit;
	double listPrice;
	double packListPrice;
	NSString *packDiscountCatagory;
	NSString *brokenPackDiscountCatagory;
	double nettContractPrice;
	NSString *supplierBarCode;
	double packQuantity;
	NSString *cataloguePage;
	int stockedIndent;
	NSString *productDetails;
	//picture retrieved by calling for it
	NSString *promotionDetails;
	NSString *promotionID;
	double promoBuyPrice;
	double stockOnHand;
	double quantityToOrder;
	double promoSellExGST;
	double promoSellIncGST;
	NSString *promoPageNo;
	NSString *comments;
	int discontinued;
}

@property(nonatomic,copy)NSString *storeCode;
@property(nonatomic,copy)NSString *supplierCode;
@property(nonatomic,copy)NSString *supplierPartNo;
@property(nonatomic,copy)NSString *productDescription;
@property(nonatomic,copy)NSString *brand;
@property(nonatomic,copy)NSString *unit;
@property(nonatomic)double listPrice;
@property(nonatomic)double packListPrice;
@property(nonatomic,copy)NSString *packDiscountCatagory;
@property(nonatomic,copy)NSString *brokenPackDiscountCatagory;
@property(nonatomic)double nettContractPrice;
@property(nonatomic, copy)NSString *supplierBarCode;
@property(nonatomic)double packQuantity;
@property(nonatomic,copy)NSString *cataloguePage;
@property(nonatomic)int stockedIndent;
@property(nonatomic,copy)NSString *productDetails;
//method to load picture independant
@property(nonatomic,copy)NSString *promotionDetails;
@property(nonatomic,copy)NSString *promotionID;
@property(nonatomic)double promoBuyPrice;
@property(nonatomic)double stockOnHand;
@property(nonatomic)double quantityToOrder;
@property(nonatomic)double promoSellExGST;
@property(nonatomic)double promoSellIncGST;
@property(nonatomic,copy)NSString *promoPageNo;
@property(nonatomic,copy)NSString *comments;
@property(nonatomic)int discontinued;

@end
