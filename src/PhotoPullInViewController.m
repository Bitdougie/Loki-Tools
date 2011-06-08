//
//  PhotoPullInViewController.m
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

#import "PhotoPullInViewController.h"
#import "DatabaseSetupConnections.h"


@implementation PhotoPullInViewController

-(PhotoPullInViewController *)initWithUser:(User*)userObject
{
	self = [super init];
	
	if (self) {
		userLogin = userObject;
		[userLogin retain];
		error = [[ErrorMessageViewController alloc]init];
	}
	
	return self;
}

-(void)dealloc
{
	if (currentNode != nil) {
		[currentNode release];
		currentNode = nil;
	}
	if (rootNode != nil) {
		[rootNode release];
	}
	[userLogin release];
	[super dealloc];
}

-(void)populateWindow
{
	NSMutableString *query;
	char *charQuery;
	DatabaseSetupConnections *connection;
	MYSQL_RES *res_set;
	MYSQL_ROW row;
	NSString *tempString;
	
	[supplierCode removeAllItems];
	
	query = [[NSMutableString alloc]init];
	connection = [DatabaseSetupConnections alloc];
	[connection initWithUser:userLogin];
	[connection connectDatabase];
	
	[query setString:@"SELECT SUPPLIER.SUPPLIER_CODE FROM SUPPLIER;"];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_real_query([connection conn], charQuery, [query length])) {
		NSString *errorMessage;
		errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
		[error openErrorMessage:@"DiscountsViewController:refresh" withMessage:errorMessage];
		[error setErrorNo:0];
		
		[errorMessage release];
		[connection disconnectDatabase];
		[connection release];
		[query release];
		free(charQuery);
		return;
	}
	else {
		res_set = mysql_store_result([connection conn]);
		
		if (res_set == NULL) {
			NSString *errorMessage;
			errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
			[error openErrorMessage:@"DiscountsViewController:refresh" withMessage:errorMessage];
			[error setErrorNo:0];
			
			[errorMessage release];
			[connection disconnectDatabase];
			[connection release];
			[query release];
			free(charQuery);
			return;			
		}
		else {
			
			while ((row = mysql_fetch_row(res_set)) != NULL) {
				tempString = [[NSString alloc]initWithUTF8String:row[0]];
				[supplierCode addItemWithObjectValue:tempString];
				[tempString release];
			}
			mysql_free_result(res_set);
		}
	}
	
	free(charQuery);
	[connection disconnectDatabase];
	[connection release];
	[query release];
}

-(IBAction)pullInPhotos:(id) sender
{
	NSArray *children;
	NSArray *fileNameTemp;
	char *charQuery;
	DatabaseSetupConnections *connection;
	NSImage *productImage;
	NSMutableData *imageArchiveData;
	NSArchiver *imageArchiver;
	NSString *imageAsString;
	
	children = [currentNode children];
	[children retain];

	connection = [DatabaseSetupConnections alloc];
	[connection initWithUser:userLogin];
	[connection connectDatabase];
	
	for( FileBrowser *child in children)
	{
		fileNameTemp = [[[child URL]lastPathComponent] componentsSeparatedByString:@"."];
		if (![[fileNameTemp objectAtIndex: 0]isEqualToString:@""]) {
			NSLog(@" %s ", [[fileNameTemp objectAtIndex:0] UTF8String]);
		
			
		}
	}
	
	[connection disconnectDatabase];
	[connection release];
	[children release];
}

-(IBAction)selectSupplier:(id) sender
{
	NSMutableString *query;
	char *charQuery;
	DatabaseSetupConnections *connection;
	MYSQL_RES *res_set;
	MYSQL_ROW row;
	NSString *tempString;
	
	query = [[NSMutableString alloc]init];
	connection = [DatabaseSetupConnections alloc];
	[connection initWithUser:userLogin];
	[connection connectDatabase];
	
	[query setString:@"SELECT SUPPLIER.TRADE_NAME FROM SUPPLIER WHERE SUPPLIER.SUPPLIER_CODE ='"];
	[query appendString:[supplierCode stringValue]];
	[query appendString:@"';"];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_real_query([connection conn], charQuery, [query length])) {
		NSString *errorMessage;
		errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
		[error openErrorMessage:@"DiscountsViewController:refresh" withMessage:errorMessage];
		[error setErrorNo:0];
		
		[errorMessage release];
		[connection disconnectDatabase];
		[connection release];
		[query release];
		free(charQuery);
		return;
	}
	else {
		res_set = mysql_store_result([connection conn]);
		
		if (res_set == NULL) {
			NSString *errorMessage;
			errorMessage = [[NSString alloc]initWithUTF8String:mysql_error([connection conn])];
			[error openErrorMessage:@"DiscountsViewController:refresh" withMessage:errorMessage];
			[error setErrorNo:0];
			
			[errorMessage release];
			[connection disconnectDatabase];
			[connection release];
			[query release];
			free(charQuery);
			return;			
		}
		else {
			
			while ((row = mysql_fetch_row(res_set)) != NULL) {
				tempString = [[NSString alloc]initWithUTF8String:row[0]];
				[supplierName setStringValue:tempString];
				[tempString release];
			}
			mysql_free_result(res_set);
		}
	}
	
	free(charQuery);
	[connection disconnectDatabase];
	[connection release];
	[query release];
}

-(id)rootItemForBrowser:(NSBrowser *)browser
{
	if(rootNode == nil){
		rootNode = [[FileBrowser alloc] initWithURL:[NSURL fileURLWithPath:@"/Users/"]];
	}
	return rootNode;
}

-(NSInteger)browser:(NSBrowser *)browser numberOfChildrenOfItem:(id)item
{
	FileBrowser *node = (FileBrowser *)item;
	return [[node children] count];
}

-(id)browser:(NSBrowser *)browser child:(NSInteger)index ofItem:(id)item
{
	FileBrowser *node = (FileBrowser *)item;
	return [[node children] objectAtIndex:index];
}

-(BOOL)browser:(NSBrowser *)browser isLeafItem:(id) item{
	FileBrowser *node = (FileBrowser *)item;
	if (![node isDirectory]) {
		if (currentNode != nil) {
			[currentNode release];
			currentNode = nil;
		}
		[path setStringValue:@"Nothing Currently Selected ... :-("];
	}
	else {
		[path setStringValue:[node fullFilePath]];
		currentNode = node;
		[currentNode retain];
	}
	
	return ![node isDirectory];
}

-(id)browser:(NSBrowser *)browser objectValueForItem:(id) item{
	
	FileBrowser *node = (FileBrowser *)item;
	return [node displayName];
}

@end
