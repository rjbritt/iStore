//
//  ProductsView.h
//  ClientApp
//
//  Created by Chris Bobo on 10/31/11.
//  Copyright 2011 Clemson University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestConfig.h"
#import "ASIHTTPRequestDelegate.h"

@interface ProductsView : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UIImageView *imageview;
    ASIHTTPRequest *globalRequest;
    NSMutableArray *storeMaps;
}

//-(IBAction)showimage1:(id)sender;
//-(IBAction)showimage2:(id)sender;
-(IBAction)pushProducts:(id)sender;
-(IBAction)pushStoreLocator:(id)sender;
-(IBAction)pushMapView:(id)sender;
@property (retain) IBOutlet UIImageView *imageview;
@property (retain) IBOutlet UIScrollView *scrollview;




@end
