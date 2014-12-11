//
//  Subclass.h
//  ClientApp
//
//  Created by Chris Bobo on 11/30/11.
//  Copyright 2011 Clemson University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Subclass : UIViewController{
    IBOutlet UITextView *animalDesciption;
	IBOutlet UIImageView *animalImage;
    
    NSMutableArray *subCategories;
    NSMutableArray *subImages;
}

-(IBAction)pushBackToTable:(id)sender;

@property (nonatomic, retain) IBOutlet UITextView *animalDesciption;
@property (nonatomic, retain) IBOutlet UIImageView *animalImage;

@end