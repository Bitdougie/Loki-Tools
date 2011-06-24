//
//  Host
//  Loki_Tools
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

#import "Host.h"


/**
 
 Host Interface
 
 */
                     
@implementation Host

@synthesize hostName, portNumber, socketName, flags;

/**
	Initializes the host object with values
 */

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