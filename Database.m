//
//  Database.m
//  ClientApp
//
//  Created by Chris Bobo on 11/30/11.
//  Copyright 2011 Clemson University. All rights reserved.
//

#import "Database.h"

@implementation Database
@synthesize name, description, imageURL;

-(id)initWithName:(NSString *)n description:(NSString *)d url:(NSString *)u {
	self.name = n;
	self.description = d;
	self.imageURL = u;
	return self;
}

@end
