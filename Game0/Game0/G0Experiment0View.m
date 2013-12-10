//
//  G0Experiment0View.m
//  Game0
//
//  Copyright (c) 2013 Game0 Organization. All rights reserved.
//

#import "G0Experiment0View.h"

@implementation G0Experiment0View

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	[[UIColor redColor] setFill];
	UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
	[path fill];
}

@end
