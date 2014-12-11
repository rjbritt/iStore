//
//  ClientAppViewController.h
//  ClientApp
//
//  Created by Chris Bobo on 10/31/11.
//  Copyright 2011 Clemson University. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kleftmostComponent 0
#define ksecondLeftmostComponent 1
#define kmiddleComponent 2
#define ksecondRightmostComponent 3
#define krightmostComponent 4

#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestConfig.h"
#import "ASIHTTPRequestDelegate.h"

@interface ClientAppViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
{ 
    UIPickerView *doublePicker;
    NSArray *leftmostDigit;
    NSArray *secondLeftmostDigit;
    NSArray *middleDigit;
    NSArray *secondRightmostDigit;
    NSArray *rightmostDigit;
    
    ASIHTTPRequest *globalRequest;
}

@property int zipCode;
@property BOOL useCurrentLocation;
@property(nonatomic, retain) IBOutlet UIPickerView *doublePicker;
@property(nonatomic, retain) NSArray *leftmostDigit;
@property(nonatomic, retain) NSArray *secondLeftmostDigit;
@property(nonatomic, retain) NSArray *middleDigit;
@property(nonatomic, retain) NSArray *secondRightmostDigit;
@property(nonatomic, retain) NSArray *rightmostDigit;

-(IBAction)pushMap:(id)sender;

@end
