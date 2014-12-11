//
//  SelectionOptions.h
//  iStore Commercial
//
//  Created by Ryan Britt on 11/9/11.
//  Copyright (c) 2011 Ryan Britt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppData.h"

@interface SelectionOptions : AppData
{
    BOOL selectedHorizontal;
    int sizeSelected; // 1 for small, 2 for medium, 3 for large;
}
@property BOOL selectedHorizontal;
@property int sizeSelected;
@end
