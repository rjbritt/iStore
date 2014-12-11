//
//  DraggableButton.h
//  iStore
//
//  Created by Ryan Britt on 11/7/11.
//  Copyright 2011 Ryan Britt. All rights reserved.
//
//  Assistance from www.stackoverflow.com was used for the creation of this class
//

#import <Foundation/Foundation.h>

@interface DraggableButton : UIButton
{
    BOOL dragging;
    BOOL rotated;

    CGPoint startingLocation;
    
    float deltaX;
    float deltaY;
}
@property BOOL dragging;
@property BOOL rotated;
-(void) setName:(NSString *)name;
-(void) rotateVertical;
@end
