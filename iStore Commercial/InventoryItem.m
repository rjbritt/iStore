//
//  InventoryItem.m
//  iStore
//
//  Created by Ryan Britt on 11/7/11.
//  Copyright 2011 Ryan Britt. All rights reserved.
//

#import "InventoryItem.h"

@implementation InventoryItem
@synthesize superCategory, subCategory;

- (id)init
{
    self = [super init];
    if (self) 
    {
        superCategory = @"";
        subCategory = @"";
    }
    
    return self;
}

@end
