//
//  MaintenaceViewController.m
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


#import "MaintenaceViewController.h"


@implementation MaintenaceViewController

@synthesize maintenaceWindow;

-(MaintenaceViewController *)init
{
	self = [super init];
	
	if (self) {
		changePasswordViewController = [[ChangePasswordViewController alloc]init];
	}
	
	return self;
}

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

-(IBAction) changePassword: (id) sender
{
	[changePasswordViewController openChangePassword];	
}

-(void)dealloc
{
	[changePasswordViewController autorelease];
	[super dealloc];
}

@end
