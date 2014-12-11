//
//  EditMapViewController.m
//  iStore Commercial
//
//  Created by Ryan Britt on 11/9/11.
//  Copyright (c) 2011 Ryan Britt. All rights reserved.
//

#import "SecondaryViewController.h"

#import "AppDelegateInfoTransferProtocol.h"
#import "SelectionOptions.h"
#import "AppDelegate.h"
#import "ViewController.h"

@implementation SecondaryViewController
@synthesize  horizontal, vertical, descriptor, draw,blockOptions, popSegue;

/*
 *This method returns the options selected for the type of block to draw from 
 *the AppDelegate. 
 */
-(SelectionOptions *) anyTransferredAppData;
{
    id<AppDelegateInfoTransferProtocol> theDelegate = (id<AppDelegateInfoTransferProtocol>) [UIApplication sharedApplication].delegate;
	SelectionOptions *options = (SelectionOptions*) theDelegate.anyTransferredAppData;
	return options;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [[segue identifier] isEqualToString:@"verticalPopover"] || [[segue identifier] isEqualToString:@"horizontalPopover"] )
    {
        self.popSegue = (UIStoryboardSegue*)segue;
        NSLog(@"I got set to: %@", [self.popSegue identifier]);;
    }
}
/*
 *The is the method called by any button to choose the direction and size of the button
 */
-(IBAction)chooseDirection:(id)sender
{

    if ([sender tag] == 121) //horizontal block choice
    {
        blockOptions.selectedHorizontal = YES;  
    }
    else if([sender tag] == 122) //vertical block choice
    {
        blockOptions.selectedHorizontal = NO;
    }
    else
    {
        if ([sender tag] == 123) //Small Block choice
        {
            blockOptions.sizeSelected = 1;
            
        }
        else if ([sender tag] == 124) //Medium Block choice
        {
            blockOptions.sizeSelected = 2;            
        }
        else if([sender tag] == 125) // Large Block choice
        {
            blockOptions.sizeSelected = 3;
        }        
        AppDelegate *test = (AppDelegate*)([[UIApplication sharedApplication] delegate]);
        [test.mainViewController drawBlock];
    }
    //[self.popSegue.popoverController dismissPopoverAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];

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
    [super viewDidLoad];
    AppDelegate *test = (AppDelegate*)([[UIApplication sharedApplication] delegate]);
    test.editMapViewController = self;
    blockOptions = [self anyTransferredAppData];


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
	return YES;
}

@end
