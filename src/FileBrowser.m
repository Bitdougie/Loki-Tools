//
//  FileBrowser.m
//  Loki_Tools
//
//  Created by Douglas Mason on 25/05/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

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
	id *dirFile;
	NSError *errorInfo;
	
	if ([url getResourceValue:dirFile forKey:NSURLLocalizedNameKey error:&errorInfo]) {
		return (NSString *)dirFile;
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
		else{
			[error openErrorMessage:@"FileBrowser:children" withMessage:@"could not obtain content at path"];
			[error setErrorNo:1];
			[children release];
			return contentsAtPath;
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

@end
