//
//  MaintenaceViewController.h
//  Loki_Tools
//
//  Created by Douglas Mason on 6/04/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MaintenaceViewController : NSObject {
	IBOutlet NSWindow *maintenaceWindow;
}

@property(nonatomic, retain)NSWindow *maintenaceWindow;

-(void) openMaintenace;

-(IBAction) changePassword;


@end
