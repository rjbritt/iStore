//
//  Database.h
//  ClientApp
//
//  Created by Chris Bobo on 11/30/11.
//  Copyright 2011 Clemson University. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Database : NSObject{
    NSString *name;
	NSString *description;
	NSString *imageURL;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *imageURL;

-(id)initWithName:(NSString *)n description:(NSString *)d url:(NSString *)u;

@end
