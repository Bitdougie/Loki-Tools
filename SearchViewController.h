//
//  SearchViewController.h
//  Loki_Tools
//
//  Created by Douglas Mason on 11/02/11.
//  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SearchSetupConnections.h"


@interface SearchViewController : NSObject <NSBrowserDelegate> {
	IBOutlet NSSearchField *productSearchKey;
	IBOutlet NSBrowser *productBrowser;
	IBOutlet NSWindow *searchWindow;
	BOOL windowLive;
}

@property (nonatomic, retain) IBOutlet NSSearchField *productSearchKey;
@property (nonatomic, retain) IBOutlet NSBrowser *productBrowser;
@property (nonatomic, retain) IBOutlet NSWindow *searchWindow;

-(IBAction) searchNow: (id) sender;
-(void) openSearchWindow;

@end
