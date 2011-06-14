//
//  Host
//  Loki_Tools
//
//  Created by Douglas Mason on 13/06/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

#import "Host.h"


@implementation Host

@synthesize hostName, portNumber, socketName, flags;

-(Host *) init
{
	self = [super init];
	
	if(self)
	{
		[self setHostName:NULL];
		[self setPortNumber:0];
		[self setSocketName:NULL];
		[self setFlags:0];
	}
	
	return self;
}

-(void)dealloc
{
	[super dealloc];
}

@end
