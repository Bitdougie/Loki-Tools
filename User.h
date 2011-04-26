//
//  User.h
//  Loki_Tools
//
//  Created by Douglas Mason on 11/04/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface User : NSObject {
	NSString *hostName;
	NSString *userName;
	NSString *password;
	unsigned int portNumber;
	NSString *socketName; 
	NSString *databaseName;
	unsigned int flags; 
	
	Boolean validLogin;
	/*SECURITY SETUP INFORMATION TO BE PUT IN HERE*/
}

@property(nonatomic, copy) NSString *hostName;
@property(nonatomic, copy) NSString *userName;
@property(nonatomic, copy) NSString *password;
@property(nonatomic) unsigned int portNumber;
@property(nonatomic, copy) NSString *socketName;
@property(nonatomic,copy) NSString *databaseName;
@property(nonatomic) unsigned int flags;
@property(nonatomic) Boolean validLogin;

@end
