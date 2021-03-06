//
//  MaintenaceViewController.h
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
#import "ChangePasswordViewController.h"
#import "User.h"
#import "ConstructDatabaseViewController.h"

@interface MaintenaceViewController : NSObject {
	IBOutlet NSWindow *maintenaceWindow;
	ChangePasswordViewController *changePasswordViewController;
	User *userLogin;
	ConstructDatabaseViewController *constructDatabaseViewController;
}

@property(nonatomic, retain)NSWindow *maintenaceWindow;

-(MaintenaceViewController *)initWithUser:(User *)userObject;

-(void) openMaintenace;

-(IBAction) changePassword: (id) sender;
-(IBAction) constructDatabase: (id) sender;

@end
