//
//  ViewController.m
//  iStore Commercial
//
//  Created by Ryan Britt on 11/8/11.
//  Copyright (c) 2011 Ryan Britt. All rights reserved.
//

#import "ViewController.h"
#import "DraggableButton.h"
#include <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "AppDelegateInfoTransferProtocol.h"
#import "SelectionOptions.h"
#import "BlockInventoryViewController.h"
#import "InventoryItem.h"
#import "ASIFormDataRequest.h"


@implementation ViewController
@synthesize toolbar, editMapButton, editInventoryButton, saveMapButton; // toolbar and according buttons
@synthesize buttonArray,inventoryArray; //Arrays
@synthesize popover,blockSelectionOptions; //additional class instances
@synthesize popSegue, popSegue2;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [[segue identifier] isEqualToString:@"blockPopover"] )
    {
        self.popSegue = (UIStoryboardPopoverSegue*)segue;
        
        //[[segue destinationViewController] setDelegate:self];
    }
}

-(SelectionOptions *) anyTransferredAppData;
{
    id<AppDelegateInfoTransferProtocol> theDelegate = (id<AppDelegateInfoTransferProtocol>) [UIApplication sharedApplication].delegate;
	SelectionOptions *options = (SelectionOptions*) theDelegate.anyTransferredAppData;
	return options;
}

-(void) blockInventoryMethod:(DraggableButton *)button
{
    BlockInventoryViewController *block = (BlockInventoryViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"blockViewID"];
    NSUInteger myInt = [((NSArray *)buttonArray) indexOfObject:button];
    block.arrayIndex = myInt;
    [self presentModalViewController: block animated:YES];

}
/*
 *This Method draws a custom UIButton on the screen according to what the selected options are.
 */
- (void) drawBlock
{
    if ([self.popSegue.popoverController isPopoverVisible]) 
    {
        [self.popSegue.popoverController dismissPopoverAnimated:YES];        
    }
    
    DraggableButton *button = [DraggableButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:@"Name" forState:UIControlStateNormal];  
    [button addTarget:self action:@selector(blockInventoryMethod:) forControlEvents:UIControlEventTouchUpInside];
    if(blockSelectionOptions.sizeSelected == 1) // Small Block
    {
        [button setFrame:CGRectMake(self.view.center.x, self.view.center.y, 76, 44)];
        [button setBackgroundImage:([UIImage imageNamed:@"small_button.png"]) forState:UIControlStateNormal];
        [button setBackgroundImage:([UIImage imageNamed:@"small_button_highlight.png"]) forState:UIControlStateHighlighted];
    }
    else if(blockSelectionOptions.sizeSelected == 2) // Medium Block
    {
        [button setFrame:CGRectMake(self.view.center.x, self.view.center.y, 140, 44)];
        [button setBackgroundImage:([UIImage imageNamed:@"medium_button.png"]) forState:UIControlStateNormal];
        [button setBackgroundImage:([UIImage imageNamed:@"medium_button_highlight.png"]) forState:UIControlStateHighlighted];  
    }
    else if(blockSelectionOptions.sizeSelected == 3) //Large Block
    {
        [button setFrame:CGRectMake(self.view.center.x, self.view.center.y, 214, 44)];
        [button setBackgroundImage:([UIImage imageNamed:@"large_button.png"]) forState:UIControlStateNormal];
        [button setBackgroundImage:([UIImage imageNamed:@"large_button_highlight.png"]) forState:UIControlStateHighlighted];         
    }
    
    if(blockSelectionOptions.selectedHorizontal == NO)
    {
        [button rotateVertical];
    }
    
    [self.view addSubview:button]; 
    [buttonArray addObject:button];

}

-(IBAction)editInventory:(id)sender
{
    
}

/**
 * This is a delegate method of UIAlert view used to handle buttons pressed on the alertview\
 * and therefore used to finish the instantiation of a new item under the current supercategory
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1337)
    {
        if(buttonIndex == 1) //The "Next" Button
        {
            storeID = [alertView textFieldAtIndex:0].text;
            
            UIAlertView *storeInfoAlert2 = [[UIAlertView alloc] initWithTitle:@"Store Address" message:@"Enter your store Address." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Next", nil];
            [storeInfoAlert2 setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [storeInfoAlert2 textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeWords;
            storeInfoAlert2.tag = 1338; 
            [storeInfoAlert2 show];
            
        }
    }
    else if(alertView.tag == 1338)
    {
        if(buttonIndex == 1) //The "Next" Button
        {
            storeAddr = [alertView textFieldAtIndex:0].text;
            
            UIAlertView *storeInfoAlert3 = [[UIAlertView alloc] initWithTitle:@"Store Zip" message:@"Enter your store Zip code." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
            [storeInfoAlert3 setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [storeInfoAlert3 textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeWords;
            storeInfoAlert3.tag = 1339; 
            [storeInfoAlert3 show];
            
        }
    }
    else if(alertView.tag == 1339)
    {
        if(buttonIndex == 1) //The "Done" Button
        {
            storeZip = [[alertView textFieldAtIndex:0].text intValue];
        }
    }
}
-(IBAction)saveMap:(id)sender
{
    self.toolbar.hidden = YES;  
    UIView *mapView = [self view];
    UIGraphicsBeginImageContextWithOptions(mapView.bounds.size, mapView.opaque, [[UIScreen mainScreen] scale]);
    [mapView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //Change for later use. Will give option to save to photo album and export to database.
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);  
    self.toolbar.hidden = NO;
    NSData *data = UIImagePNGRepresentation(image);
    NSString *lastSupercategory = @""; // This string is used to check what the last supercategory is so that there won't be duplicate supercategory entries.
    
    /***************************************Send data to webservice ***************************************/
    for (int i = 0; i < [inventoryArray count]; i++)
    {
        //Change picture to highlightedPicture
        //Find the current button
        DraggableButton *currentButton;
        int index;
        for(index = 0; index < [buttonArray count]; index ++)
        {
            //if the button text 
            if ([((DraggableButton *)[buttonArray objectAtIndex:index]).titleLabel.text isEqualToString:((InventoryItem *)[                                                                                                                                                             inventoryArray objectAtIndex:i]).superCategory]) 
            {
                currentButton = ((DraggableButton *)[buttonArray objectAtIndex:index]);
            }
        }
        UIImage *previousImage = [currentButton backgroundImageForState:UIControlStateNormal];
        
        if(previousImage == [UIImage imageNamed:@"large_button.png"])
        {
            [currentButton setBackgroundImage:([UIImage imageNamed:@"large_button_red.png"]) forState:UIControlStateNormal];
        }
        else if(previousImage == [UIImage imageNamed:@"medium_button.png"])
        {
            [currentButton setBackgroundImage:([UIImage imageNamed:@"medium_button_red.png"]) forState:UIControlStateNormal];

        }
        else if(previousImage == [UIImage imageNamed:@"small_button.png"])
        {
            [currentButton setBackgroundImage:([UIImage imageNamed:@"small_button_red.png"]) forState:UIControlStateNormal];
        }
        //save highlightedImage
        self.toolbar.hidden = YES;  
        mapView = [self view];
        UIGraphicsBeginImageContextWithOptions(mapView.bounds.size, mapView.opaque, [[UIScreen mainScreen] scale]);
        [mapView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *highlighedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(highlighedImage, self, nil, nil);  
        self.toolbar.hidden = NO;
        NSData *highlightedData = UIImagePNGRepresentation(highlighedImage);
        
        [currentButton setBackgroundImage:previousImage forState:UIControlStateNormal];
        
        //Add current Supercategory       
        if(i == 0 || [lastSupercategory isEqualToString:(((InventoryItem*)[inventoryArray objectAtIndex:i]).superCategory)] == NO)
        {
            NSURL *addSupercategoryUrl = [NSURL URLWithString:@"http://pba.cs.clemson.edu/~rjbritt/addSupercategory.php"];   
            ASIFormDataRequest *supercategoryRequest = [ASIFormDataRequest requestWithURL:addSupercategoryUrl];   
            [supercategoryRequest setPostValue:  (((InventoryItem*)[inventoryArray objectAtIndex:i]).superCategory) forKey:@"supercatName"];
            
            NSString *photoName = [NSString stringWithFormat:@"%@_",storeID];
            photoName = [photoName stringByAppendingString:(((InventoryItem*)[inventoryArray objectAtIndex:i]).superCategory)];
            photoName = [photoName stringByAppendingString:@"_highlighted.png"];
            [supercategoryRequest setData:highlightedData withFileName:photoName andContentType:@"image/png" forKey:@"photo"];
            
            [supercategoryRequest startAsynchronous];
            lastSupercategory = ((InventoryItem*)[inventoryArray objectAtIndex:i]).superCategory;
        }

        
        //Add current Subcategory
        NSURL *addSubcategoryUrl = [NSURL URLWithString:@"http://pba.cs.clemson.edu/~rjbritt/addSubcategory.php"];   
        ASIFormDataRequest *subcategoryRequest = [ASIFormDataRequest requestWithURL:addSubcategoryUrl];   
        [subcategoryRequest setPostValue:  (((InventoryItem*)[inventoryArray objectAtIndex:i]).subCategory) forKey:@"subcatName"];
        [subcategoryRequest startSynchronous];
        
        
        //Add current inventory Item
        NSURL *addInventoryUrl = [NSURL URLWithString:@"http://pba.cs.clemson.edu/~rjbritt/addInventoryItem.php"];   
        ASIFormDataRequest *inventoryRequest = [ASIFormDataRequest requestWithURL:addInventoryUrl];   
        
        NSURL *getSubCatUid = [NSURL URLWithString:@"http://pba.cs.clemson.edu/~rjbritt/getSubcategoryUID.php"];
        ASIFormDataRequest *subcategoryUID = [ASIFormDataRequest requestWithURL:getSubCatUid];
        [subcategoryUID setPostValue:((InventoryItem*)[inventoryArray objectAtIndex:i]).subCategory  forKey:@"subcat"];
        [subcategoryUID startSynchronous];
        NSString *subuid =[subcategoryUID responseString];
        
        /*This passes the storeId, the supercategory NAME (even though the field says ID) and the subcategoryID
         to the php script. The php script then translates the supercategory name to the correct ID based off the external database.
         */
        NSString *superCat = ((InventoryItem*)[inventoryArray objectAtIndex:i]).superCategory;
        [inventoryRequest setPostValue: storeID forKey:@"storeID"];
        [inventoryRequest setPostValue: superCat forKey:@"supercategoryID"];
        [inventoryRequest setPostValue: subuid forKey:@"subcategoryID"];
        [inventoryRequest startSynchronous];

        
    }// end subcategory/super category for loop
    
    
    //Add StoreMap
    NSURL *addStoreMapURL = [NSURL URLWithString:@"http://pba.cs.clemson.edu/~rjbritt/addStoreMap.php"];   
    ASIFormDataRequest *storeMapRequest = [ASIFormDataRequest requestWithURL:addStoreMapURL];   
    [storeMapRequest setPostValue: storeID forKey:@"storeID"];
    
    NSString *mapPhotoName = [NSString stringWithFormat:@"%@ %i", storeAddr,storeZip];
    mapPhotoName = [mapPhotoName stringByAppendingString:@".png"];
    [storeMapRequest setData:data withFileName:mapPhotoName andContentType:@"image/png" forKey:@"photo"];
    
    [storeMapRequest startAsynchronous];
    
    //Add store information
    NSString *zipString = [NSString stringWithFormat:@"%i", storeZip];
    
    NSURL *addStoreInfoURL = [NSURL URLWithString:@"http://pba.cs.clemson.edu/~rjbritt/addStoreInformation.php"];   
    ASIFormDataRequest *storeInfoRequest = [ASIFormDataRequest requestWithURL:addStoreInfoURL];   
    [storeInfoRequest setPostValue: storeID forKey:@"storeID"];
    [storeInfoRequest setPostValue:storeAddr forKey:@"storeAddr"];
    [storeInfoRequest setPostValue:zipString forKey:@"storeZip"];
    
    [storeInfoRequest startAsynchronous];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.autoresizesSubviews = YES;
	// Do any additional setup after loading the view
    buttonArray = [[NSMutableArray alloc] init];
    inventoryArray = [[NSMutableArray alloc] init];
    
    AppDelegate *test = (AppDelegate*)([[UIApplication sharedApplication] delegate]);
    
    test.mainViewController = self;
    blockSelectionOptions = [self anyTransferredAppData];
    
    
    if(!alreadySetup)
    {
        UIAlertView *storeInfoAlert1 = [[UIAlertView alloc] initWithTitle:@"StoreID" message:@"Enter your store ID." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Next", nil];
        
        [storeInfoAlert1 setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [storeInfoAlert1 textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeWords;
        storeInfoAlert1.tag = 1337; //haha, it's too late at night...
        [storeInfoAlert1 show];
        
        alreadySetup = YES;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        return NO;
    }
    return YES;
}

@end
