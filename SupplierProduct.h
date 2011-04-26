//
//  SupplierProduct.h
//  Loki_Tools
//
//  Created by Douglas Mason on 17/02/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

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
