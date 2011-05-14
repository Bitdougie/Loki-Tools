//
//  SelectDatabaseViewController.m
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
 */

#import "SelectDatabaseViewController.h"
#import "DatabaseSetupConnections.h"
#import <my_global.h>
#import <my_sys.h>
#import <mysql.h>


@implementation SelectDatabaseViewController

-(SelectDatabaseViewController *)initWithUser: (User *) userObject
{
	self = [super init];
	
	if(self)
	{
		userLogin = userObject;
		[userLogin retain];
		error = [[ErrorMessageViewController alloc]init];
		rootNode = [BrowserList alloc];
		[rootNode initWithDisplayName:@"rootNode"];
	}
	return self;
}

-(void)openSelectDatabase
{	
	if (![NSBundle loadNibNamed:@"SelectDatabaseViewController" owner: self]) {
		[error openErrorMessage:@"SelectDatabaseViewController:openSelectDatabase" withMessage:@"Could not load SelectDatabaseViewController.xib"];
		[error setErrorNo:1];
	}
	
	[self populateList];
}

-(void)populateList
{
	NSMutableString *query;
	query = [[NSMutableString alloc]init];
	char *charQuery;
	MYSQL_RES *res_set;
	MYSQL_ROW row;
	NSString *databaseName;
	DatabaseSetupConnections *connection;
	BrowserList *tempList;

	[rootNode removeAllChildren];
	
	connection = [DatabaseSetupConnections alloc];
	[connection initWithUser:userLogin];
	
	[connection connectDatabase];
	
	[query setString:@"SHOW DATABASES;"];
	
	charQuery = (char *)xmalloc(sizeof(char[[query length]]));
	
	(void)strcpy(charQuery,[query UTF8String]);
	
	if (mysql_query([connection conn], charQuery) != 0) {
		NSString *errorMessage;
		errorMessage = [[NSString alloc] initWithUTF8String: mysql_error([connection conn])];
		[error openErrorMessage:@"SelectDatabaseViewController:populateList" withMessage: errorMessage];
		[error setErrorNo:0];
		
		[errorMessage release];
		[connection disconnectDatabase];
		[connection release];
		free(charQuery);
		[query release];
		return;
	}
		
	res_set = mysql_store_result([connection conn]);
	
	if(res_set == NULL)
	{
		NSString *errorMessage;
		errorMessage = [[NSString alloc] initWithUTF8String: mysql_error([connection conn])];
		[error openErrorMessage:@"ChangePasswordViewController:changePassword" withMessage: errorMessage];
		[error setErrorNo:0];
		
		[errorMessage release];
		[connection disconnectDatabase];
		[connection release];
		free(charQuery);
		[query release];
		return;
	}
	else {
		while ((row = mysql_fetch_row(res_set)) != NULL) {
			databaseName = [[NSString alloc]initWithUTF8String:row[0]];
			tempList = [BrowserList alloc];
			[tempList initWithDisplayName:databaseName];
			[rootNode addChild:tempList];
			
			[tempList release];
			[databaseName release];
		}
		mysql_free_result(res_set);
	}
	
	[databaseBrowser loadColumnZero];

	[connection disconnectDatabase];
	[connection release];
	free(charQuery);
	[query release];
}

-(IBAction)refresh:(id) sender
{
	[self populateList];
}

-(IBAction)connect:(id) sender
{
	NSLog(@"connect");
}

-(IBAction)postSelected:(id) sender
{
	NSLog(@"Post selected");
}

-(void)dealloc
{
	[userLogin release];
	[error release];
	[rootNode release];
	[super dealloc];
}

//browser Delegate code start
-(id) rootItemForBrowser:(NSBrowser *)browser
{
	return rootNode;
}

-(NSInteger)browser:(NSBrowser *)browser numberOfChildrenOfItem:(id)item
{
	BrowserList *node = (BrowserList *)item;
	return [node numberOfChildren];
}

-(id)browser:(NSBrowser *)browser child:(NSInteger)index ofItem:(id)item
{
	BrowserList *node = (BrowserList *)item;
	return[node childAtIndex:index];
}

-(BOOL)browser:(NSBrowser *)browser isLeafItem:(id)item
{
	BrowserList *node = (BrowserList *)item;
	if ([node numberOfChildren] > 0) {
		return FALSE;
	}
	else {
		return TRUE;
	}
}

-(id)browser:(NSBrowser *)browser objectValueForItem:(id)item
{
	BrowserList *node = (BrowserList *)item;
	return [node displayName];
}
//browser Delegate code end

@end
