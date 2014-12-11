//
//  BlockInventoryViewController.m
//  iStore Commercial
//
//  Created by Ryan Britt on 11/13/11.
//  Copyright (c) 2011 Ryan Britt. All rights reserved.
//

#import "BlockInventoryViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "DraggableButton.h"
#import "InventoryItem.h"

@implementation BlockInventoryViewController

@synthesize name, arrayIndex,currentButton,inventoryTableView;

/*
 This method extracts all the subcategories for the current supercategory.
 */
- (void) extractCurrentSupercategoryItem
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(int i = 0; i< source.count; i++)
    {
        if([((InventoryItem *)[source objectAtIndex:i]).superCategory isEqualToString:currentButton.titleLabel.text])
        {
            
            [array addObject:[source objectAtIndex:i]];
        }
    }
    inventory = array;
}
/**
 * This is a delegate method of UIAlert view used to handle buttons pressed on the alertview\
 * and therefore used to finish the instantiation of a new item under the current supercategory
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1) //The "OK" Button
    {
        InventoryItem *newItem = [[InventoryItem alloc] init];
        newItem.superCategory = currentButton.titleLabel.text;
        newItem.subCategory = [alertView textFieldAtIndex:0].text;
        
        [source addObject:newItem];
        [self extractCurrentSupercategoryItem];
        [inventoryTableView reloadData];
        
    }
}

-(IBAction)dismissMyView:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
-(IBAction)updateName:(id)sender
{
    [currentButton setName:name.text];
    [self extractCurrentSupercategoryItem];
    [inventoryTableView reloadData];
    [name resignFirstResponder];
}
-(IBAction)changeEditing:(id)sender
{
    if(inventoryTableView.editing)
        inventoryTableView.editing = NO;
    else
        inventoryTableView.editing = YES;
    
    [inventoryTableView reloadData];
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    myAppDelegate = (AppDelegate*)([[UIApplication sharedApplication] delegate]);
    //currentButton must be set before view is shown.
    currentButton =[(myAppDelegate.mainViewController).buttonArray objectAtIndex:arrayIndex];
    source = (myAppDelegate.mainViewController).inventoryArray;
    [self extractCurrentSupercategoryItem];
    

    name.text = currentButton.titleLabel.text;
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
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        return YES;
    }
    return NO;
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int count = [inventory count];
    if(inventoryTableView.editing)
        count ++;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    // adds an extra row if editing
    if(inventoryTableView.editing && indexPath.row == [inventory count])
    {
        cell.textLabel.text = @"Add another inventory item.";
    }
    else
    {
        cell.textLabel.text = ((InventoryItem *)([inventory objectAtIndex:(indexPath.row)])).subCategory;
    }        
    return cell;
}


 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    // If the user is editing and the indexPath.row is at the end of its count
    if(inventoryTableView.editing && indexPath.row == [inventory count])
    {
        return UITableViewCellEditingStyleInsert;
    }
    else if(inventoryTableView.editing)
    {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (editingStyle == UITableViewCellEditingStyleDelete) 
     {
         // Delete the row from the data source
         InventoryItem *currentItem = [inventory objectAtIndex:indexPath.row];
         
         int index = [((NSArray*)source) indexOfObject:currentItem];
         [source removeObjectAtIndex:index];
         [self extractCurrentSupercategoryItem];
         [inventoryTableView reloadData];
     }   
     
     else if (editingStyle == UITableViewCellEditingStyleInsert) 
     {         
         UIAlertView *newSubCategory = [[UIAlertView alloc] initWithTitle:@"Add Item" message:@"Enter the name for the new item in this Block." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
         
         [newSubCategory setAlertViewStyle:UIAlertViewStylePlainTextInput];
         [newSubCategory textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeWords;
         [newSubCategory show];
         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }   
 }
 

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
