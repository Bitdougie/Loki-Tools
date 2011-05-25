//
//  FileBrowser.m
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
 
 Loki Tools  Copyright (C) 2011  Douglas Mason
 This program comes with ABSOLUTELY NO WARRANTY;
 */

#import "FileBrowser.h"


@implementation FileBrowser

-(FileBrowser *)initWithURL:(NSURL *)urlObject
{
	self = [super init];
	
	if (self) {
		url = urlObject;
		[url retain];
		error = [[ErrorMessageViewController alloc]init];
	}
	return self;
}

-(void)dealloc{
	[url release];
	[children release];
	[error release];
	[super dealloc];
}

-(NSString *)description
{
	return [NSString stringWithFormat:@"%@ - %@",super.description,url];
}

@synthesize URL = url;
@dynamic displayName, children, isDirectory, labelColor;

-(NSString *)displayName
{
	id dirFile;
	NSError *errorInfo;
	
	if ([url getResourceValue: &dirFile forKey:NSURLLocalizedNameKey error:&errorInfo]) {
		return dirFile;
	}
	else {
		NSString *errorMessage;
		errorMessage = [[NSString alloc]initWithString:[errorInfo localizedDescription]];
		[error openErrorMessage:@"FileBrowser:description" withMessage:errorMessage];
		[error setErrorNo:1];
		
		[errorMessage release];
		return [errorInfo localizedDescription];
	}
}

-(BOOL)isDirectory
{
	id value;
	[url getResourceValue:&value forKey:NSURLIsDirectoryKey error:NULL];
	return [value boolValue];
}

-(NSArray *)children
{
	if (children == nil || childrenDirty) {
		NSMutableDictionary *newChildren;
		newChildren = [NSMutableDictionary new];
		
		NSString *parentPath = [url path];
		NSArray *contentsAtPath = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:parentPath error:NULL];
		 
		if(contentsAtPath){
			for(NSString *fileName in contentsAtPath)
			{
				if(children != nil){
					FileBrowser *oldChild = [children objectForKey:fileName];
					if (oldChild != nil) {
						[newChildren setObject:oldChild forKey:fileName];
						continue;
					}
				}
				
				NSString *fullPath = [parentPath stringByAppendingFormat:@"/%@",fileName];
				NSURL *childURL = [NSURL fileURLWithPath:fullPath];
				
				if (childURL != nil) {
					FileBrowser *node = [[FileBrowser alloc] initWithURL:childURL];
					[newChildren setObject:node forKey:fileName];
					[node release];
				}
			}
		}
		
		[children release];
		children = newChildren;
		childrenDirty = NO;
	}
	
	NSArray *result = [children allValues];
	
	result = [result sortedArrayUsingComparator:^(id obj1, id obj2){
		NSString *objName = [obj1 displayName];
		NSString *obj2Name = [obj2 displayName];
		NSComparisonResult result = [objName compare:obj2Name options: NSNumericSearch | NSCaseInsensitiveSearch | NSWidthInsensitiveSearch | NSForcedOrderingSearch range:NSMakeRange(0, [objName length]) locale:[NSLocale currentLocale]];
		return result;
	}];
	return result;
}

-(void)invalidateChildren
{
	childrenDirty = YES;
	for(FileBrowser *child in [children allValues]){
		[child invalidateChildren];
	}
}

-(NSString *)fullFilePath
{
	return [url path];
}

@end
