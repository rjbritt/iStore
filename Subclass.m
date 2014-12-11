//
//  Subclass.m
//  ClientApp
//
//  Created by Chris Bobo on 11/30/11.
//  Copyright 2011 Clemson University. All rights reserved.
//

#import "Subclass.h"
#import "Products.h"

@implementation Subclass

@synthesize animalDesciption, animalImage;

- (void)downloadSubCategoriesFromExternal
{
    NSURL *url = [NSURL URLWithString:@"http://pba.cs.clemson.edu/~rjbritt/getSubcategory.php"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        NSArray *parseOfSubCategories = [response componentsSeparatedByString:@"\n"];
        
        subCategories = [[NSMutableArray alloc] init];
        
        int i;
        int count = 0;
        //Go through each element of the super categories list and add the names to the super uitable
        for (i=0; i<([parseOfSubCategories count]-1); i++) {
            //If we are at the beginning of a set of four strings
            if (count == 0) {
                
                NSString *tempSub = [parseOfSubCategories objectAtIndex:(i+2)];
                [subCategories addObject:tempSub];
                tempSub = @"";
            }
            //Spin until you have passed through three strings, then reset the count
            if (count == 3) {
                count = 0;
                continue;
            }
            count = count + 1;
        }
        
        int j;
        count = 0;
        //Go through each element of the super categories list and add the images to the superimages list
        for (j=0; j<([parseOfSubCategories count]-1); j++) {
            //If we are at the beginning of a set of four strings
            if (count == 0) {
                
                NSString *tempSubImage = [parseOfSubCategories objectAtIndex:(j+3)];
                [subImages addObject:tempSubImage];
                tempSubImage = @"";
            }
            //Spin until you have passed through three strings, then reset the count
            if (count == 3) {
                count = 0;
                continue;
            }
            count = count + 1;
        }
        
        int k;
        for (k = 0; k <5; k++) {
            NSLog(@"%@",[subImages objectAtIndex:k]);   //got null
        }
        
        
    }
    else {
        //no internet connection, so load store Addresses from internal database
    }
    
    //end php
}


- (IBAction)pushBackToTable:(id)sender 
{
	Products *backToTable =[[Products alloc] initWithNibName:nil bundle:nil];
    backToTable.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:backToTable animated:YES];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (void)dealloc {
    [super dealloc];
}

@end
