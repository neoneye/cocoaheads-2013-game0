//
//  G0Experiment0View.m
//  Game0
//
//  Copyright (c) 2013 Game0 Organization. All rights reserved.
//

#import "G0Experiment0View.h"

float remap(float value, float a, float b, float c, float d) {
	return c + (d - c) * (value - a) / (b - a);
}


@interface G0Experiment0View () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) CADisplayLink* displayLink;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic) CGFloat lastTouchX;
@property (nonatomic) CGFloat lastTouchY;
@property (nonatomic) double lastTouchValidUntilTime;

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

- (void)didMoveToWindow {
    if (self.window) {
        [self startRenderLoop];
    }
}


- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow == nil) {
        [self stopRenderLoop];
	}
}

- (void)startRenderLoop {
    // check whether the loop is already running
    if (!self.displayLink) {
        // by adding the display link to the run loop our draw method will be called 60 times per second
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkUpdate:)];
		self.displayLink.frameInterval = 3;
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//        DLog(@"Starting Render Loop");
    }
}

- (void)stopRenderLoop {
    if (self.displayLink) {
        //if the display link is present, we invalidate it (so the loop stops)
        [self.displayLink invalidate];
        self.displayLink = nil;
//        DLog(@"Stopping Render Loop");
    }
}



-(void)tapAction:(UITapGestureRecognizer*)recognizer {
    if ([recognizer state] == UIGestureRecognizerStateEnded) {
        CGPoint loc = [recognizer locationInView:self];
        //DLog(@"loc: %@", NSStringFromCGPoint(loc));
        
        CGRect bounds = self.bounds;
        //DLog(@"bounds: %@", NSStringFromCGSize(bounds.size));
        
//        float aspect = bounds.size.height / bounds.size.width;
//        float inv_aspect = 1.f / aspect;
        //DLog(@"aspect: %.2f", aspect);
        
        float x = loc.x / bounds.size.width;
        float y = loc.y / bounds.size.height;
        x = x * 2.f - 1.f;
        y = y * 2.f - 1.f;
        
//        x *= inv_aspect;
//        y *= -1.f;
		
		NSLog(@"xy : %.2f %.2f", x, y);
		
		self.lastTouchX = x;
		self.lastTouchY = y;
		self.lastTouchValidUntilTime = CFAbsoluteTimeGetCurrent() + 0.5;
		[self setNeedsDisplay];

	}
}


- (void)drawRect:(CGRect)rect {
	{
		[[UIColor redColor] setFill];
		UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
		[path fill];
	}

	
	double t = CFAbsoluteTimeGetCurrent();
	
	if (t < self.lastTouchValidUntilTime) {
		CGRect b = self.bounds;
		CGFloat x = remap(self.lastTouchX, -1, +1, 0, CGRectGetWidth(b));
		CGFloat y = remap(self.lastTouchY, -1, +1, 0, CGRectGetHeight(b));
		CGRect r = CGRectMake(x - 5, y - 5, 10, 10);
		
		[[UIColor whiteColor] setFill];
		UIBezierPath *path = [UIBezierPath bezierPathWithRect:r];
		[path fill];
	}

	
	
	
}

- (void)displayLinkUpdate:(CADisplayLink*)displayLink {
	[self setNeedsDisplay];
}


@end





















