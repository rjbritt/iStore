//
//  ProductsView.m
//  ClientApp
//
//  Created by Chris Bobo on 10/31/11.
//  Copyright 2011 Clemson University. All rights reserved.
//

#import "ProductsView.h"
#import "Products.h"
#import "ClientAppViewController.h"
#import "ClientAppAppDelegate.h"
#import "MapView.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestConfig.h"
#import "ASIHTTPRequestDelegate.h"

@implementation ProductsView
@synthesize imageview, scrollview;

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageview;
}

//This is used to receive an app delegate of the store and set the picture accordingly
//ClientAppAppDelegate *appDelegate = (ClientAppAppDelegate*)([[UIApplication sharedApplication] delegate]);
//NSString *storeId = appDelegate.locationZipCode;

- (IBAction)pushProducts:(id)sender {
	Products *products =[[Products alloc] initWithNibName:nil bundle:nil];
    products.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:products animated:YES];
}  

- (IBAction)pushStoreLocator:(id)sender {
    //[self dismissModalViewControllerAnimated:YES];
	ClientAppViewController *storeLocator =[[ClientAppViewController alloc] initWithNibName:nil bundle:nil];
    storeLocator.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:storeLocator animated:YES];
}  

- (IBAction)pushMapView:(id)sender {
    //[self dismissModalViewControllerAnimated:YES];
	MapView *mapPage =[[MapView alloc] initWithNibName:nil bundle:nil];
    mapPage.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:mapPage animated:YES];
}  

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//-(IBAction)showimage1:(id)sender {
//    
//    UIImage *img = [UIImage imageNamed:@"storeMap.png"];
//    
//    [imageview setImage:img];
//    
//}
//
//-(IBAction)showimage2:(id)sender {
//    
//    UIImage *img = [UIImage imageNamed:@"storeLocator.png"];
//    
//    [imageview setImage:img];
//    
//}

#pragma mark - View lifecycle

- (void)downloadStoreMapFromExternal
{
    NSURL *url = [NSURL URLWithString:@"http://pba.cs.clemson.edu/~rjbritt/getStoreMap.php"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        NSArray *parseOfStoreMaps = [response componentsSeparatedByString:@"\n"];
                
        storeMaps = [[NSMutableArray alloc] init];
        
        int i;
        int count = 0;
        //Go through each element of the store maps list
        for (i=0; i<[parseOfStoreMaps count]-1; i++) {
            //If we are at the beginning of a set of three strings
            if (count == 0) {
                NSString *tempMap = [parseOfStoreMaps objectAtIndex:(i+3)];
                [storeMaps addObject:tempMap];
                tempMap = @"";
            }
            //Spin until you have passed through three strings, then reset the count
            if (count == 3) {
                count = 0;
                continue;
            }
            count = count + 1;
        }
    }
    else 
    {
        //no internet connection, so load store Addresses from internal database
    }

//end php

}

- (void)viewDidLoad
{
    [self downloadStoreMapFromExternal];
    ClientAppAppDelegate *appDelegate = (ClientAppAppDelegate*)([[UIApplication sharedApplication] delegate]);
    NSString *concatenatedImageName = appDelegate.storeIdAppDelegate;
    concatenatedImageName = [concatenatedImageName stringByAppendingString:@".png"];
    int j;
    for (j=0; j<[storeMaps count]; j++) {
        if ([[storeMaps objectAtIndex:j] isEqualToString:concatenatedImageName]) {
            NSString *path = @"http://pba.cs.clemson.edu/~rjbritt/images/";
            path = [path stringByAppendingString:concatenatedImageName];
            path = [path stringByReplacingOccurrencesOfString:@" " withString:@"%20" options:0 range:NSMakeRange(0, [path length])];
            NSURL *tempUrl = [NSURL URLWithString:path];
            ClientAppAppDelegate *imageAppDelegate = (ClientAppAppDelegate*)([[UIApplication sharedApplication] delegate]);
            NSData *myUrlData = [NSData dataWithContentsOfURL:tempUrl];
            imageAppDelegate.currentStoreImageAppDelegateVariable = [[UIImage alloc] initWithData:myUrlData];

            [imageview setImage:imageAppDelegate.currentStoreImageAppDelegateVariable];
        }
        else{
        }
    }
    self.scrollview.minimumZoomScale=1.01;
    self.scrollview.maximumZoomScale=6.0;
    self.scrollview.contentSize=CGSizeMake(1280, 960);
    self.scrollview.delegate = self;
    [self.scrollview addSubview:imageview];

    
    //php code
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
