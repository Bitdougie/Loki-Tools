//
//  HostArchiver.m
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

#import "HostArchiver.h"
#import "lokierr.h"


@implementation HostArchiver

-(HostArchiver *)init
{
	self = [super init];
	
	if (self) {
		configFilePath = [[NSString alloc]initWithString:@"~/.Loki_Profile"];
	}
	
	return self;
}

-(HostArchiver *)initWithProfile:(NSString *)filePath
{
	self = [super init];
	
	if (self) {
		configFilePath = [[NSString alloc]initWithString:filePath];
	}
	
	return self;
}

-(void)dealloc
{
	[configFilePath release];
	[super dealloc];
}

-(NSArray *)getHosts:(NSError **)anError
{
	@try{
		NSArray *hostsFromArchiveCopy;
		NSMutableArray *hostsFromArchive;
	
		hostsFromArchive = [NSKeyedUnarchiver unarchiveObjectWithFile:configFilePath];
	
		[hostsFromArchive retain];
	
		if (hostsFromArchive == nil) {
			[hostsFromArchive release];
		
			NSMutableArray *newProfile;
			Host *firstHost;
			firstHost = [[Host alloc]init];
			newProfile = [[NSMutableArray alloc]init];
			[newProfile addObject:firstHost];
		
			if (![NSKeyedArchiver archiveRootObject:newProfile toFile:configFilePath]) {
				if (anError != NULL) {
					NSString *description = nil;
					int errCode;
				
					if (errno == EACCES) {
						//permission denied
						NSString *message;
					
						message = [[NSString alloc]initWithFormat:@"Permission to host file or directory denied: %@",configFilePath];
						description = NSLocalizedString(message,@"");
						errCode = LTPD;
						[message release];
					}
				
					// Make underlying error.
					NSError *underlyingError = [[[NSError alloc] initWithDomain:NSPOSIXErrorDomain
																		code:errno userInfo:nil] autorelease];
					// Make and return custom domain error.
					NSArray *objArray = [NSArray arrayWithObjects:description, underlyingError, configFilePath, nil];
				
					NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,
										NSUnderlyingErrorKey, NSFilePathErrorKey, nil];
					NSDictionary *eDict = [NSDictionary dictionaryWithObjects:objArray
																	forKeys:keyArray];
				
					*anError = [[[NSError alloc] initWithDomain:LokiTools
														   code:errCode userInfo:eDict] autorelease];
				}
				[newProfile release];
				return nil;
			}
		
			[newProfile release];
		
			hostsFromArchive = [NSKeyedUnarchiver unarchiveObjectWithFile:configFilePath];
		
			[hostsFromArchive retain];
		
			if (hostsFromArchive == nil) {
				if (anError != NULL) {
					NSString *description = nil;
					int errCode;
				
					if (errno == ENOENT) {
						//no such file or directory
						NSString *message;
					
						message = [[NSString alloc]initWithFormat:@"No host file at requested location: %@",configFilePath];
						description = NSLocalizedString(message,@"");
						errCode = LTNSFOD;
						[message release];
					} 
					else if(errno == EACCES)
					{
						//permission denied
						description = NSLocalizedString(@"Permission to host file or directory denied",@"");
						errCode = LTPD;
					}
				
					// Make underlying error.
					NSError *underlyingError = [[[NSError alloc] initWithDomain:NSPOSIXErrorDomain
																	   code:errno userInfo:nil] autorelease];
					// Make and return custom domain error.
					NSArray *objArray = [NSArray arrayWithObjects:description, underlyingError, configFilePath, nil];
				
					NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,
										NSUnderlyingErrorKey, NSFilePathErrorKey, nil];
					NSDictionary *eDict = [NSDictionary dictionaryWithObjects:objArray
																	  forKeys:keyArray];
				
					*anError = [[[NSError alloc] initWithDomain:LokiTools
														   code:errCode userInfo:eDict] autorelease];
				}
			
				[hostsFromArchive release];
				return nil;
			}
		
		}
	
		hostsFromArchiveCopy = [[NSArray alloc]initWithArray:hostsFromArchive];
	
		[hostsFromArchive release];
		[hostsFromArchiveCopy autorelease];
		return hostsFromArchiveCopy;
	}@catch (NSException *exception) {
		NSLog(@"Exception occured in: %@", NSStringFromClass([self class]));
		NSLog(@"Method: %@",[exception name]);
		NSLog(@"Line: %i at Function: %s",__LINE__, __PRETTY_FUNCTION__);
		NSLog(@"Reason: %@",[exception reason]);
		return nil;
	}
	return nil;
}

-(BOOL)addHost:(Host *)host withError:(NSError **)anError
{
	@try {
		NSArray *oldHostList;
		NSError *error;
		NSMutableArray *newHostList;
		NSArray *finalisedList;
		
		oldHostList = [[self getHosts:&error]retain];
		
		if (oldHostList == nil) {
			NSAlert *theAlert = [NSAlert alertWithError:error];
			[theAlert runModal];
		}
		
		newHostList = [[NSMutableArray alloc]initWithArray:oldHostList];
		[newHostList addObject:host];
		[oldHostList release];
		
		finalisedList = [[NSArray alloc]initWithArray:newHostList];
		
		if (![NSKeyedArchiver archiveRootObject:finalisedList toFile:configFilePath]) {
			if (anError != NULL) {
				NSString *description = nil;
				int errCode;
				
				if (errno == ENOENT) {
					//no such file or directory
					NSString *message;
					
					message = [[NSString alloc]initWithFormat:@"No host file at requested location: %@",configFilePath];
					description = NSLocalizedString(message,@"");
					errCode = LTNSFOD;
					[message release];
				} 
				else if(errno == EACCES)
				{
					//permission denied
					description = NSLocalizedString(@"Permission to host file or directory denied",@"");
					errCode = LTPD;
				}
				
				// Make underlying error.
				NSError *underlyingError = [[[NSError alloc] initWithDomain:NSPOSIXErrorDomain
																	   code:errno userInfo:nil] autorelease];
				// Make and return custom domain error.
				NSArray *objArray = [NSArray arrayWithObjects:description, underlyingError, configFilePath, nil];
				
				NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,
									 NSUnderlyingErrorKey, NSFilePathErrorKey, nil];
				NSDictionary *eDict = [NSDictionary dictionaryWithObjects:objArray
																  forKeys:keyArray];
				
				*anError = [[[NSError alloc] initWithDomain:LokiTools
													   code:errCode userInfo:eDict] autorelease];
			}
			
			[newHostList release];
			[finalisedList release];
			return FALSE;
		}
		
		[newHostList release];
		[finalisedList release];
		
	}@catch (NSException * e) {
		NSLog(@"Exception occured in: %@", NSStringFromClass([self class]));
		NSLog(@"Method: %@",[e name]);
		NSLog(@"Line: %i at Function: %s",__LINE__, __PRETTY_FUNCTION__);
		NSLog(@"Reason: %@",[e reason]);
		return FALSE;
	}
	@finally {
	} 
	return TRUE;
}

-(BOOL)removeHostAtIndex:(NSUInteger)index withError:(NSError **)anError
{
	@try {
		NSArray *oldHostList;
		NSError *error;
		NSMutableArray *newHostList;
		NSArray *finalisedList;
		
		oldHostList = [[self getHosts:&error]retain];
		
		if (oldHostList == nil) {
			NSAlert *theAlert = [NSAlert alertWithError:error];
			[theAlert runModal];
		}
		
		newHostList = [[NSMutableArray alloc]initWithArray:oldHostList];
		[oldHostList release];
		
		[newHostList removeObjectAtIndex:index];
		
		finalisedList = [[NSArray alloc]initWithArray:newHostList];
		
		if (![NSKeyedArchiver archiveRootObject:finalisedList toFile:configFilePath]) {
			if (anError != NULL) {
				NSString *description = nil;
				int errCode;
				
				if (errno == ENOENT) {
					//no such file or directory
					NSString *message;
					
					message = [[NSString alloc]initWithFormat:@"No host file at requested location: %@",configFilePath];
					description = NSLocalizedString(message,@"");
					errCode = LTNSFOD;
					[message release];
				} 
				else if(errno == EACCES)
				{
					//permission denied
					description = NSLocalizedString(@"Permission to host file or directory denied",@"");
					errCode = LTPD;
				}
				
				// Make underlying error.
				NSError *underlyingError = [[[NSError alloc] initWithDomain:NSPOSIXErrorDomain
																	   code:errno userInfo:nil] autorelease];
				// Make and return custom domain error.
				NSArray *objArray = [NSArray arrayWithObjects:description, underlyingError, configFilePath, nil];
				
				NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,
									 NSUnderlyingErrorKey, NSFilePathErrorKey, nil];
				NSDictionary *eDict = [NSDictionary dictionaryWithObjects:objArray
																  forKeys:keyArray];
				
				*anError = [[[NSError alloc] initWithDomain:LokiTools
													   code:errCode userInfo:eDict] autorelease];
			}
			
			[newHostList release];
			[finalisedList release];
			return FALSE;
		}
	}
	@catch (NSException * e) {
		NSLog(@"Exception occured in: %@", NSStringFromClass([self class]));
		NSLog(@"Method: %@",[e name]);
		NSLog(@"Line: %i at Function: %s",__LINE__, __PRETTY_FUNCTION__);
		NSLog(@"Reason: %@",[e reason]);
		return FALSE;
	}
	@finally {
	}
	return TRUE;
}

@end
