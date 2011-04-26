//
//  MaintenaceViewController.m
//  Loki_Tools
//
//  Created by Douglas Mason on 6/04/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

#import "MaintenaceViewController.h"


@implementation MaintenaceViewController

@synthesize maintenaceWindow;

-(void) openMaintenace
{
	
	if([maintenaceWindow isVisible])
	{
		[maintenaceWindow orderFront:@"[MaintenaceViewController openMaintence]"];
	}
	else {
		[NSBundle loadNibNamed:@"MaintenaceViewController" owner: self];
	}
	
}

-(IBAction) changePassword
{
		
}

@end
