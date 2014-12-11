//
//  ClientAppAppDelegate.h
//  ClientApp
//
//  Created by Chris Bobo on 10/31/11.
//  Copyright 2011 Clemson University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h> // Import the SQLite database framework

@class ClientAppViewController;

@interface ClientAppAppDelegate : NSObject <UIApplicationDelegate>{
    UIWindow *window;
	
	// Database variables
	NSString *databaseName;
	NSString *databasePath;
	
	// Array to store the animal objects
	NSMutableArray *animals;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet ClientAppViewController *viewController;

@property (retain) NSMutableArray *storeAddressList;
@property int locationZipCode;
@property (copy) NSString *storeIdAppDelegate;
@property (copy) UIImage *currentStoreImageAppDelegateVariable;
@property BOOL useCurrentLocation;

@property (nonatomic, retain) NSMutableArray *animals;

@end