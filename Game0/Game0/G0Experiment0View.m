//
//  G0Experiment0View.m
//  Game0
//
//  Copyright (c) 2013 Game0 Organization. All rights reserved.
//

#import "G0Experiment0View.h"


@interface G0Experiment0View () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation G0Experiment0View

- (id)init {
    self = [super init];
    if (self) {
		[self installGestures];
    }
    return self;
}

-(void)installGestures {
	self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:self.tapGestureRecognizer];
    self.tapGestureRecognizer.delegate = self;
}

-(void)tapAction:(UITapGestureRecognizer*)recognizer {
    if ([recognizer state] == UIGestureRecognizerStateEnded) {
        CGPoint loc = [recognizer locationInView:self];
        //DLog(@"loc: %@", NSStringFromCGPoint(loc));
        
        CGRect bounds = self.bounds;
        //DLog(@"bounds: %@", NSStringFromCGSize(bounds.size));
        
        float aspect = bounds.size.height / bounds.size.width;
        float inv_aspect = 1.f / aspect;
        //DLog(@"aspect: %.2f", aspect);
        
        float x = loc.x / bounds.size.width;
        float y = loc.y / bounds.size.height;
        x = x * 2.f - 1.f;
        y = y * 2.f - 1.f;
        
        x *= inv_aspect;
        y *= -1.f;
		
		NSLog(@"xy : %.2f %.2f", x, y);
	}
}


- (void)drawRect:(CGRect)rect {
	[[UIColor redColor] setFill];
	UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
	[path fill];
}

@end
