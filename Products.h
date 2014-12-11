//
//  Products.h
//  ClientApp
//
//  Created by Chris Bobo on 11/1/11.
//  Copyright 2011 Clemson University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Subclass.h"

#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestConfig.h"
#import "ASIHTTPRequestDelegate.h"

@interface Products : UIViewController <UITableViewDelegate, UITableViewDataSource>  {
    IBOutlet UITableView* recentSearchesTable;
    IBOutlet UIBarButtonItem *backButton;
    Subclass *animalView;
    NSMutableArray *inventoryItems;
    NSMutableArray *superImages;
    NSMutableArray *supercategories;
    NSMutableArray *subcategories;
    NSMutableArray *currentTablePopulation;
    NSString * currentTablePopulationView;
    NSString * currentSupercategory;
}

-(IBAction)pushProductsView:(id)sender;

@property (nonatomic, retain) UITableView* recentSearchesTable;

@property(nonatomic, retain) Subclass *animalView;

@end