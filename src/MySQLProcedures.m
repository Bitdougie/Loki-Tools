//
//  MySQLProcedures.m
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

#import "MySQLProcedures.h"
#import "DatabaseLogin.h"
#import "xLokiProcedures.h"
#import "lokierr.h"


@implementation MySQLProcedures

+(NSString *)escapeSQLQuery:(NSString *) rawQuery andError:(NSError **) anError
{
	@try {
		if (rawQuery != NULL) {
			[rawQuery retain];
			NSString *sQLEscapedString;
			char *rawCharQuery;
			char *charSQLEscapedString;
			unsigned int ESLength;
			MYSQL *connection;
			NSString *query;
			
			query = [[NSString alloc]initWithString:rawQuery];
			[rawQuery release];
			
			rawCharQuery = (char*)xmalloc(sizeof(char[[query length]]));
			ESLength = (2*[query length] +1);
			charSQLEscapedString = (char*)xmalloc(sizeof(char [ESLength]));
			
			(void)strcpy(rawCharQuery,[query UTF8String]);
			
			connection = [DatabaseLogin openConnection:anError];
			
			mysql_real_escape_string(connection, charSQLEscapedString, rawCharQuery, [query length]);
			
			[DatabaseLogin closeConnection:connection];
			
			sQLEscapedString = [[NSString alloc] initWithUTF8String:charSQLEscapedString];
			
			free(rawCharQuery);
			free(charSQLEscapedString);
			[query release];
			
			[sQLEscapedString autorelease];
			
			return sQLEscapedString;
		}
		
		if (anError != nil) {
			NSString *description = nil;
			int errCode;
			errCode = LTNA;
			
			description = NSLocalizedString(@"The query given was NULL",@"");
			
			// Make underlying error.
			NSError *underlyingError = [[[NSError alloc] initWithDomain:LokiTools
																   code:LTNA userInfo:nil] autorelease];
			// Make and return custom domain error.
			NSArray *objArray = [NSArray arrayWithObjects:description, underlyingError, @"", nil];
			
			NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,
								 NSUnderlyingErrorKey, NSFilePathErrorKey, nil];
			NSDictionary *eDict = [NSDictionary dictionaryWithObjects:objArray
															  forKeys:keyArray];
			
			*anError = [[[NSError alloc] initWithDomain:LokiTools
												   code:errCode userInfo:eDict] autorelease];
		}
		
		return NULL;
			
	}
	@catch (NSException * e) {
		NSLog(@"Exception occured in: %@", NSStringFromClass([self class]));
		NSLog(@"Method: %@",[e name]);
		NSLog(@"Line: %i at Function: %s",__LINE__, __PRETTY_FUNCTION__);
		NSLog(@"Reason: %@",[e reason]);
	}
	return NULL;
}

+(NSArray *)searchSQLQuery:(NSString *) searchKey andError:(NSError **) anError
{	
	@try {
		if (searchKey != NULL) {
			NSMutableArray *sQLQuery;
			NSMutableString *changingSearchKey;
			NSRange nextSpace;
			NSRange removalRange;
			NSError *error;
			NSArray *results;
			
			sQLQuery = [[NSMutableArray alloc] init];	
			changingSearchKey = [[NSMutableString alloc] init];
			
			removalRange.location = 0;
			removalRange.length = 0;
			
			[changingSearchKey setString: searchKey];
			
			while ([changingSearchKey rangeOfString:@" "].location != NSNotFound) {
				nextSpace = [changingSearchKey rangeOfString:@" "];
				
				[sQLQuery addObject:[self escapeSQLQuery:[changingSearchKey substringToIndex:nextSpace.location] andError:&error]];
				
				if ([sQLQuery lastObject] == NULL) {
					[sQLQuery release];
					[changingSearchKey release];
					return NULL;
				}
				
				removalRange.length = (nextSpace.location + 1);
				
				[changingSearchKey deleteCharactersInRange:removalRange];
			}
			
			[sQLQuery addObject:[self escapeSQLQuery:changingSearchKey andError:&error]];
			
			if ([sQLQuery lastObject] == NULL) {
				[sQLQuery release];
				[changingSearchKey release];
				return NULL;
			}
			
			results = [[[NSArray alloc]initWithArray:sQLQuery]autorelease];
			[sQLQuery release];
			[changingSearchKey release];
			
			return results;
		}
		
		if (anError != nil) {
			NSString *description = nil;
			int errCode;
			errCode = LTNA;
			
			description = NSLocalizedString(@"The searchKey given was NULL",@"");
			
			// Make underlying error.
			NSError *underlyingError = [[[NSError alloc] initWithDomain:LokiTools
																   code:LTNA userInfo:nil] autorelease];
			// Make and return custom domain error.
			NSArray *objArray = [NSArray arrayWithObjects:description, underlyingError, @"", nil];
			
			NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,
								 NSUnderlyingErrorKey, NSFilePathErrorKey, nil];
			NSDictionary *eDict = [NSDictionary dictionaryWithObjects:objArray
															  forKeys:keyArray];
			
			*anError = [[[NSError alloc] initWithDomain:LokiTools
												   code:errCode userInfo:eDict] autorelease];
		}
		
		return NULL;
		
	}
	@catch (NSException * e) {
		NSLog(@"Exception occured in: %@", NSStringFromClass([self class]));
		NSLog(@"Method: %@",[e name]);
		NSLog(@"Line: %i at Function: %s",__LINE__, __PRETTY_FUNCTION__);
		NSLog(@"Reason: %@",[e reason]);
	}
	return NULL;
}

+(BOOL)loadFileToDatabase:(NSURL *)path andError:(NSError **)anError
{
	return FALSE;
}

@end
