//
//  ClientAppViewController.m
//  ClientApp
//
//  Created by Chris Bobo on 10/31/11.
//  Copyright 2011 Clemson University. All rights reserved.
//

#import "ClientAppViewController.h"
#import "ClientAppAppDelegate.h"
#import "MapView.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestConfig.h"
#import "ASIHTTPRequestDelegate.h"
#import "StoreLocation.h"

@implementation ClientAppViewController

@synthesize doublePicker;
@synthesize leftmostDigit;
@synthesize secondLeftmostDigit;
@synthesize middleDigit;
@synthesize secondRightmostDigit;
@synthesize rightmostDigit;
@synthesize zipCode;
@synthesize useCurrentLocation; // whether to use the current location or to use a zip code (NO value)

//php code

- (void)downloadFromExternal
{
    NSURL *url = [NSURL URLWithString:@"http://pba.cs.clemson.edu/~rjbritt/getStoreInformation.php"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        NSArray *parseOfStoreInfo = [response componentsSeparatedByString:@"\n"];
                
        NSMutableArray *storeAddresses = [[NSMutableArray alloc] init];
        
        int i;
        int count = 0;
        NSString *tempAddress = @"";
        //Go through each element of the store information list
        for (i=0; i<[parseOfStoreInfo count]-1; i++) {
            //If we are at the beginning of a set of five strings
            if (count == 0) {
                //Concatenate the address with the town and with the zip in that order
                tempAddress = [tempAddress stringByAppendingString:[parseOfStoreInfo objectAtIndex:(i+3)]];
                tempAddress = [tempAddress stringByAppendingString:@" "];
                tempAddress = [tempAddress stringByAppendingString:[parseOfStoreInfo objectAtIndex:(i+4)]];
                StoreLocation *tempStoreLocation = [[StoreLocation alloc] init];
                tempStoreLocation.storeAddress = tempAddress;
                tempStoreLocation.storeid = [parseOfStoreInfo objectAtIndex:(i+2)];
                NSLog(@"%@",tempStoreLocation.storeid);
                [storeAddresses addObject:tempStoreLocation];
                tempAddress = @"";
                //[tempStoreLocation release];
                //Store this new address in the list of addresses
            }
            //Spin until you have passed through five strings, then reset the count
            if (count == 4) {
                count = 0;
                continue;
            }
            count = count + 1;
        }
        
        ClientAppAppDelegate *storeListAppDelegate = (ClientAppAppDelegate*)([[UIApplication sharedApplication] delegate]);
        storeListAppDelegate.storeAddressList = storeAddresses;
//        int k;
//        for (k = 0; k<[storeAddresses count]; k++) {
//            NSLog(@"HERE WE GO AGAIN %@",((StoreLocation *)[storeAddresses objectAtIndex:k]).storeAddress);
//        }
                
    }
    else {
        //no internet connection, so load store Addresses from internal database
    }
}
//end php

- (void)viewDidLoad
{
    
    //Get store info from the database through php
    //[self grabURLInBackground:self];
    //[self requestFinished:globalRequest];
    [self downloadFromExternal];
    //end php code
    
    useCurrentLocation = YES;
    
    NSArray *numberArray = [[NSArray alloc] initWithObjects:@"0",
                             @"1", @"2", @"3",
                             @"4", @"5", @"6", @"7",
                             @"8", @"9", nil];
    self.leftmostDigit = numberArray;
    [numberArray release];
    
    NSArray *secondLeft = numberArray;
    self.secondLeftmostDigit = secondLeft;
    [secondLeft release];
    
    NSArray *mid = numberArray;
    self.middleDigit = mid;
    [mid release];
    
    NSArray *secondRight = numberArray;
    self.secondRightmostDigit = secondRight;
    [secondRight release];
    
    NSArray *rightmost = numberArray;
    self.rightmostDigit = rightmost;
    [rightmost release];    
}

- (IBAction)pushMap:(id)sender 
{
    NSInteger leftmostRow = [doublePicker selectedRowInComponent:
                            kleftmostComponent];
    NSInteger secondLeftRow = [doublePicker selectedRowInComponent:
                          ksecondLeftmostComponent];
    NSInteger middleRow = [doublePicker selectedRowInComponent:
                              kmiddleComponent];
    NSInteger secondRightRow = [doublePicker selectedRowInComponent:
                          ksecondRightmostComponent];
    NSInteger rightmostRow = [doublePicker selectedRowInComponent:
                         krightmostComponent];
    int leftmostInt = [[leftmostDigit objectAtIndex:leftmostRow] intValue];
    int secondLeftInt = [[secondRightmostDigit objectAtIndex:secondLeftRow] intValue];
    int middleInt = [[middleDigit objectAtIndex:middleRow] intValue];
    int secondRightInt = [[secondRightmostDigit objectAtIndex:secondRightRow] intValue];
    int rightInt = [[rightmostDigit objectAtIndex:rightmostRow] intValue];
    zipCode = ((leftmostInt * 10000) + (secondLeftInt * 1000) + (middleInt * 100) + (secondRightInt * 10) + rightInt);
    
    ClientAppAppDelegate *appDelegate = (ClientAppAppDelegate*)([[UIApplication sharedApplication] delegate]);
    appDelegate.locationZipCode = zipCode;
     
//    NSString *message = [[NSString alloc] initWithFormat:
//                         @"%i",zipCode];
//   
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:
//                          @"Zip"
//                                                    message:message 
//                                                   delegate:nil 
//                                          cancelButtonTitle:@"Great!" 
//                                          otherButtonTitles:nil];
// 
//    [alert show];
//    [alert release];
//    [message release];
    
	MapView *mapview =[[MapView alloc] initWithNibName:nil bundle:nil];
    mapview.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;

    if(((UIButton *)sender).tag == 123) // use current location button triggered this pushMap()
    {
        appDelegate.useCurrentLocation = YES;
    }
    else if(((UIButton *)sender).tag == 124) // use zip code button triggered this pushMap()
    {
        appDelegate.useCurrentLocation = NO;
    }

    
	[self presentModalViewController:mapview animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.doublePicker = nil;
    self.leftmostDigit = nil;
    self.secondLeftmostDigit = nil;
    self.middleDigit = nil;
    self.secondRightmostDigit = nil;
    self.rightmostDigit = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [doublePicker release];
    [leftmostDigit release];
    [secondLeftmostDigit release];
    [middleDigit release];
    [secondRightmostDigit release];
    [rightmostDigit release];
    [super dealloc];
}

//Code for the picker begins here
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 5;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == kleftmostComponent)
        return [self.leftmostDigit count];
    else if (component == ksecondLeftmostComponent)
        return [self.secondLeftmostDigit count];
    else if (component == kmiddleComponent )
        return [self.middleDigit count];
    else if (component == ksecondRightmostComponent )
        return [self.secondRightmostDigit count];
    else
        return [self.rightmostDigit count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == kleftmostComponent)
        return [self.leftmostDigit objectAtIndex:row];
    else if (component == ksecondLeftmostComponent )
        return [self.secondLeftmostDigit objectAtIndex:row];
    else if (component == kmiddleComponent)
        return [self.middleDigit objectAtIndex:row];
    else if (component == ksecondRightmostComponent)
        return [self.secondRightmostDigit objectAtIndex:row];
    else
        return [self.rightmostDigit objectAtIndex:row];
}

@end
