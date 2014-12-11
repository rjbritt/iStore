//
//  Products.m
//  ClientApp
//
//  Created by Chris Bobo on 11/1/11.
//  Copyright 2011 Clemson University. All rights reserved.
//

#import "Products.h"
#import "ProductsView.h"
#import "ClientAppAppDelegate.h"
#import "Database.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestConfig.h"
#import "ASIHTTPRequestDelegate.h"
#import "StoreLocation.h"
#import "ASIFormDataRequest.h"
#import "StoreInventoryItem.h"


@implementation Products

@synthesize recentSearchesTable;
@synthesize animalView;

- (IBAction)back:(id)sender 
{
    if([currentTablePopulationView isEqualToString:@"subcategory"])
    {
        currentTablePopulation = supercategories;
        currentTablePopulationView = @"supercategory";
        [recentSearchesTable reloadData];
    }
    else
    {
//        [self dismissModalViewControllerAnimated:YES];
        [self pushProductsView:self];
    }

}  
- (void)downloadSuperCategoriesFromExternal
{
    currentTablePopulation = [[NSMutableArray alloc] init];
    currentTablePopulationView = @"supercategory";
    currentSupercategory = @"";
    
    NSArray *storeLocations;
    ClientAppAppDelegate *listOfStoreLocations = (ClientAppAppDelegate*)([[UIApplication sharedApplication] delegate]);
    storeLocations = listOfStoreLocations.storeAddressList;
    NSString *addressClicked = listOfStoreLocations.storeIdAppDelegate;
    NSString *currentStoreId = @"";
    for(int i = 0; i< [storeLocations count]; i++)
    {
        StoreLocation *temp = ((StoreLocation *)[storeLocations objectAtIndex:i]);
        if([temp.storeAddress  isEqualToString:addressClicked])
        {
            currentStoreId = temp.storeid;
        }
    }
    

    NSURL *url = [NSURL URLWithString:@"http://pba.cs.clemson.edu/~rjbritt/getInventoryItemListForStore.php"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:currentStoreId forKey:@"storeId"];
    [request startSynchronous];
    NSString *inventoryList = [request responseString];
    
    NSError *error = [request error];
    if (!error) {
        
        NSArray *parseOfInventoryItems = [inventoryList componentsSeparatedByString:@"\n"];
        
        inventoryItems = [[NSMutableArray alloc] init];
        
        int i;
        int count = 0;
        //Go through each element of the super categories list and add the names to the super uitable
        for (i=0; i<([parseOfInventoryItems count]-1); i++) {
            StoreInventoryItem *tempStoreInventoryItem = [[StoreInventoryItem alloc] init];
            //If we are at the beginning of a set of five strings
            if (count == 0) {
                tempStoreInventoryItem.superCategory = [parseOfInventoryItems objectAtIndex:(i+2)];
                tempStoreInventoryItem.subCategory = [parseOfInventoryItems objectAtIndex:(i+3)];
                tempStoreInventoryItem.highlightedImageName = [parseOfInventoryItems objectAtIndex:(i+4)];
                [inventoryItems addObject:tempStoreInventoryItem];
            }
            //Spin until you have passed through four strings, then reset the count
            if (count == 4) {
                count = 0;
                continue;
            }
            count = count + 1;
        }
        
        supercategories = [[NSMutableArray alloc]init];
        subcategories = [[NSMutableArray alloc]init];
        BOOL safeToAdd = YES;
        
        for(int i = 0; i< [inventoryItems count]; i++)
        {
            
            for (int j = 0; j<[supercategories count]; j++) {
                if ([((StoreInventoryItem*)[inventoryItems objectAtIndex:i]).superCategory isEqualToString: ([supercategories objectAtIndex:j])]) {
                    safeToAdd = NO;
                }
            }
            
            if (safeToAdd) {
                [supercategories addObject:((StoreInventoryItem*)[inventoryItems objectAtIndex:i]).superCategory];
            }
            safeToAdd = YES;
        }
        
        NSLog(@"%@",supercategories);
        NSLog(@"%@",subcategories);
        //supercategories and subcategories now contain a list of unique super and subcategories for this store.

//        int j;
//        count = 0;
//        //Go through each element of the super categories list and add the images to the superimages list
//        for (j=0; j<([parseOfInventoryItems count]-1); j++) {
//            //If we are at the beginning of a set of four strings
//            if (count == 0) {
//                
//                NSString *tempSuperImage = [parseOfInventoryItems objectAtIndex:(j+3)];
//                [superImages addObject:tempSuperImage];
//                tempSuperImage = @"";
//            }
//            //Spin until you have passed through three strings, then reset the count
//            if (count == 3) {
//                count = 0;
//                continue;
//            }
//            count = count + 1;
//        }
    }
    else {
        //no internet connection, so load store Addresses from internal database
    }
        
    //end php
    
    currentTablePopulation = supercategories;
    [recentSearchesTable reloadData];
}


- (IBAction)pushProductsView:(id)sender 
{
	ProductsView *productsview =[[ProductsView alloc] initWithNibName:nil bundle:nil];
    productsview.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:productsview animated:YES];
}  

#pragma mark Table view methods
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    ClientAppAppDelegate *appDelegate = (ClientAppAppDelegate *)[[UIApplication sharedApplication] delegate];
//	return appDelegate.animals.count;
    return currentTablePopulation.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
                 //initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	
    // Set up the cell
    //ClientAppAppDelegate *appDelegate = (ClientAppAppDelegate *)[[UIApplication sharedApplication] delegate];
	//Database *animal = (Database *)[appDelegate.animals objectAtIndex:indexPath.row];
    
    //Database *animal = (Database *)[inventoryItems objectAtIndex:indexPath.row];
	NSString *cellName = [currentTablePopulation objectAtIndex:indexPath.row];
    cell.textLabel.text = cellName;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Navigation logic -- create and push a new view controller
    if([currentTablePopulationView isEqualToString:@"supercategory"])
    {
        //switch rows to subcategory
        
        currentSupercategory = [supercategories objectAtIndex:indexPath.row];
        
        //create temporary subcategory array to populate the uitable
        NSMutableArray *tempsubcategories = [[NSMutableArray alloc] init];
        
        BOOL safeToAdd = YES;
        for (int i= 0; i< [inventoryItems count]; i++) 
        {
            for (int j = 0; j<[tempsubcategories count]; j++) {
                if ([((StoreInventoryItem*)[inventoryItems objectAtIndex:i]).subCategory isEqualToString: ([tempsubcategories objectAtIndex:j])]) {
                    safeToAdd = NO;
                }
            }
            
            if (safeToAdd) //After we've made sure there are no duplicates
            {
                if([((StoreInventoryItem*)[inventoryItems objectAtIndex:i]).superCategory isEqualToString:currentSupercategory])
                {
                    [tempsubcategories addObject:((StoreInventoryItem*)[inventoryItems objectAtIndex:i]).subCategory];
                }
            }
            safeToAdd = YES;
        }
        
        currentTablePopulation = tempsubcategories;
        currentTablePopulationView = @"subcategory";
        [tableView reloadData];
    }
    else
    {
        //show appropriated image for the selected supercategory

        int index;
        for(int i = 0; i< [inventoryItems count]; i++)
        {
            if([((StoreInventoryItem*)[inventoryItems objectAtIndex:i]).superCategory isEqualToString:currentSupercategory])
            {
                index = i;
                break;
            }
        }
        
        NSString *currentHighlightedPictureName = ((StoreInventoryItem*)[inventoryItems objectAtIndex:index]).highlightedImageName;
        NSLog(@"highlighedImageName %@", currentHighlightedPictureName);
        
        NSString *path = @"http://pba.cs.clemson.edu/~rjbritt/images/";
        path = [path stringByAppendingString:currentHighlightedPictureName];
        path = [path stringByReplacingOccurrencesOfString:@" " withString:@"%20" options:0 range:NSMakeRange(0, [path length])];
        
        NSLog(@"The Path %@",path);
        NSURL *tempUrl = [NSURL URLWithString:path];
        NSData *myUrlData = [NSData dataWithContentsOfURL:tempUrl];
        
        UIImage *newImage = [[UIImage alloc] initWithData:myUrlData];
        
        //For any ios 5 build, this must be self.presentingViewController. For lower ios builds
        // this is self.parentViewController.
        
        ProductsView *tempView; 
        
//        if(self.parentViewController)
            tempView = (ProductsView*)self.parentViewController;
//        else
//            tempView = (ProductsView*)self.presentingViewController;
            
        [tempView.imageview setImage:newImage];
        
        [self dismissModalViewControllerAnimated:YES];
        
    }
    
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

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [self downloadSuperCategoriesFromExternal];
    self.title = @"Inventory";
    [super viewDidLoad];
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
