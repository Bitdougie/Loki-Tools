//
//  User.h
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
 
 Loki Tools  Copyright (C) 2011  Douglas Mason
 This program comes with ABSOLUTELY NO WARRANTY;
 */
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
