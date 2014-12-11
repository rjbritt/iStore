//
//  AppDelegate.h
//  iStore Commercial
//
//  Created by Ryan Britt on 11/8/11.
//  Copyright (c) 2011 Ryan Britt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegateInfoTransferProtocol.h"

@class SelectionOptions, ViewController, SecondaryViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    SelectionOptions *anyTransferredAppData;
    ViewController *mainViewController;
    SecondaryViewController *editMapViewController;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (retain) SelectionOptions *anyTransferredAppData;
@property (retain) ViewController *mainViewController;
@property (retain) SecondaryViewController *editMapViewController;

@end
