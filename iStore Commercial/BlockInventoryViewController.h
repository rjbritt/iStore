//
//  BlockInventoryViewController.h
//  iStore Commercial
//
//  Created by Ryan Britt on 11/13/11.
//  Copyright (c) 2011 Ryan Britt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DraggableButton;
@class ViewController;
@class AppDelegate;
@interface BlockInventoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    AppDelegate *myAppDelegate;
    NSMutableArray *inventory; // This is the array containing the inventory items for the current supercategory
    NSMutableArray *source; //This is the source array of all the inventory items
}

@property (retain) IBOutlet UITextField *name; //the uitextfield that allows changing the name of the block
@property (retain) DraggableButton * currentButton; //The instance of the current button that called this class instance
@property (retain) IBOutlet UITableView *inventoryTableView; //The table view that holds the inventory 
@property int arrayIndex; // index in the button array of the button that called this class instance

-(IBAction)dismissMyView:(id)sender; // dismisses this view
-(IBAction)updateName:(id)sender; // updates the name of the button that has called this class instance

@end
