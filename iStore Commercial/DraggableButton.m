//
//  DraggableButton.m
//  iStore
//
//  Created by Ryan Britt on 11/7/11.
//  Copyright 2011 Ryan Britt. All rights reserved.
//

#import "DraggableButton.h"

@implementation DraggableButton
@synthesize dragging,rotated;

-(void) setName:(NSString *)name
{
    [self setTitle:name forState:UIControlStateNormal];  
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    dragging = YES;
    [super touchesMoved:touches withEvent:event];
    
    UITouch *theTouch = [[event allTouches] anyObject];
    self.center = [theTouch locationInView:self];

    CGPoint pt = [[[event allTouches] anyObject] locationInView:self];

    if(rotated)
    {
        //The button gets rotated -90 (or 270) degrees. This means that the button or local
        //coordinates are different than the global coordinates.
        //The real deltaY is actually equivalent to the negative deltaX and the the real deltaX is actually
        //equivalent to the deltaY
        deltaY = (-1 *pt.x) + startingLocation.x;
        deltaX = pt.y - startingLocation.y;
    }
    else
    {
        deltaX = pt.x - startingLocation.x;
        deltaY = pt.y - startingLocation.y;        
    }
        
    CGPoint newcenter = CGPointMake(self.center.x + deltaX, self.center.y + deltaY);
        
    // Set new location
    self.center = newcenter;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = YES;
    dragging = NO;
    startingLocation = [[[event allTouches] anyObject] locationInView:self];
    [[self superview] bringSubviewToFront:self];

}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{  
    self.highlighted = NO;
    if(!dragging)
    {         
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
        return;
    }    
    dragging = NO;
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}
-(void) rotateVertical
{
    self.transform = CGAffineTransformMakeRotation((-90 * M_PI ) / 180);
    self.rotated = true;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    self.dragging = NO;
    return self;
}

@end
