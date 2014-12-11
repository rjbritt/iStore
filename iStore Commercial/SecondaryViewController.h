//
//  EditMapViewController.h
//  iStore Commercial
//
//  Created by Ryan Britt on 11/9/11.
//  Copyright (c) 2011 Ryan Britt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectionOptions;

@interface SecondaryViewController : UIViewController <UIPopoverControllerDelegate>
{
    IBOutlet UIButton *horizontal;
    IBOutlet UIButton *vertical;
    IBOutlet UIButton *descriptor; // descriptor box. Not an actual inventory "Block" just a general area.
    NSString *draw;
    SelectionOptions *blockOptions;
    BOOL activated;
}
@property (strong, nonatomic) UIStoryboardSegue* popSegue;

@property (retain) IBOutlet UIButton *horizontal;
@property (retain) IBOutlet UIButton *vertical;
@property (retain) IBOutlet UIButton *descriptor;
@property (copy) NSString *draw;
@property (retain) SelectionOptions *blockOptions;
-(IBAction)chooseDirection:(id)sender;
@end
