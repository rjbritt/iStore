//
//  SelectionOptions.m
//  iStore Commercial
//
//  Created by Ryan Britt on 11/9/11.
//  Copyright (c) 2011 Ryan Britt. All rights reserved.
//

#import "SelectionOptions.h"

@implementation SelectionOptions
@synthesize sizeSelected, selectedHorizontal;
/**
 *This method sets the default initialization to a small
 *horizontal block for the inventory
 */
-(id) init
{
    self = [super init];
    if (self) 
    {
        selectedHorizontal = YES;
        sizeSelected = 1;
    }
    
    return self;  
}
@end
