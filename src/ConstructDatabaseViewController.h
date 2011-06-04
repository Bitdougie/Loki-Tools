//
//  ConstructDatabaseViewController.h
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
#import <my_global.h>
#import <my_sys.h>
#import <mysql.h>
#import "User.h"
#import "ErrorMessageViewController.h"


@interface ConstructDatabaseViewController : NSObject {
	IBOutlet NSTextField *newDataBaseName;
	IBOutlet NSWindow *window;
	User *userLogin;
	ErrorMessageViewController *error;
}

-(ConstructDatabaseViewController *)initWithUser: (User *) userObject;

-(IBAction)constructDatabase: (id) sender;

@end
