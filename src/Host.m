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

@synthesize hostName, portNumber, socketName, flags, title;

/**
	Initializes the host object with values
 */

-(Host *) init
{
	self = [super init];
	
	if(self)
	{
		[self setTitle:@"localHost"];
		[self setHostName:NULL];
		[self setPortNumber:0];
		[self setSocketName:NULL];
		[self setFlags:0];
	}
	
	return self;
}

-(Host *)initWithCoder:(NSCoder *)aDecoder
{
	title = [[aDecoder decodeObjectForKey:@"HostTitle"]retain];
	hostName = [[aDecoder decodeObjectForKey:@"HostHostName"] retain];
	socketName = [[aDecoder decodeObjectForKey:@"HostSocketName"]retain];
	portNumber = [aDecoder decodeIntForKey:@"HostPortNumber"];
	flags = [aDecoder decodeIntForKey:@"HostFlags"];
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:title forKey: @"HostTitle"];
	[aCoder encodeObject:hostName forKey: @"HostHostName"];
	[aCoder encodeObject:socketName forKey: @"HostSocketName"];
	[aCoder encodeInt:portNumber forKey:@"HostPortNumber"];
	[aCoder encodeInt:flags forKey:@"HostFlags"];
}

-(void)dealloc
{
	[super dealloc];
}

@end
