//
//  Host.h
//  Loki_Tools
//
//  Created by Douglas Mason on 13/06/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Host : NSObject {
	NSString *hoseName;
	unsigned int portNumber;
	NSString *socketName;
	unsigned int flags;
}

@property(nonatomic, copy)NSString *hostName;
@property(nonatomic) unsigned int portNumber;
@property(nonatomic, copy)NSString *socketName;
@property(nonatomic) unsigned int flags;

@end
