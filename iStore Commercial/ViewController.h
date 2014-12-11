//
//  ViewController.h
//  iStore Commercial
//
//  Created by Ryan Britt on 11/8/11.
//  Copyright (c) 2011 Ryan Britt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SecondaryViewController;
@class SelectionOptions;

@interface ViewController : UIViewController 
{
    IBOutlet UIToolbar *toolbar;
    IBOutlet UIBarButtonItem *editMapButton;
    IBOutlet UIBarButtonItem *editInventoryButton;
    IBOutlet UIBarButtonItem *saveMapButton;
    
    NSMutableArray *buttonArray;//collection of dynamically created Draggable Buttons
    NSMutableArray *inventoryArray; // collection of all inventory items within this app
    SecondaryViewController *popover;
    SelectionOptions *blockSelectionOptions;    
    BOOL alreadySetup;
    
    NSString *storeID;
    NSString *storeAddr;
    int storeZip;
}
@property (strong, nonatomic) UIStoryboardPopoverSegue* popSegue;
@property (strong, nonatomic) UIStoryboardPopoverSegue* popSegue2;


@property (retain) IBOutlet UIToolbar *toolbar;
@property (retain) IBOutlet UIBarButtonItem *editMapButton;
@property (retain) IBOutlet UIBarButtonItem *editInventoryButton;
@property (retain) IBOutlet UIBarButtonItem *saveMapButton;

@property (retain) NSMutableArray *buttonArray;
@property (retain) NSMutableArray *inventoryArray;

@property (retain) SecondaryViewController *popover;
@property (retain) SelectionOptions *blockSelectionOptions;

-(IBAction)editInventory:(id)sender;
-(IBAction)saveMap:(id)sender;
-(void)drawBlock; 

@end
