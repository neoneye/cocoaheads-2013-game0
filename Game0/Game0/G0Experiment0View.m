//
//  G0Experiment0View.m
//  Game0
//
//  Copyright (c) 2013 Game0 Organization. All rights reserved.
//

#import "G0Experiment0View.h"
#import "G0LevelSlice.h"

float remap(float value, float a, float b, float c, float d) {
	return c + (d - c) * (value - a) / (b - a);
}


@interface G0Experiment0View () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) CADisplayLink* displayLink;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic) CGFloat lastTouchX;
@property (nonatomic) CGFloat lastTouchY;
@property (nonatomic) double lastTouchValidUntilTime;
@property (nonatomic) double lastTouchReady;


@property (nonatomic) CGFloat playerCurrentX;
@property (nonatomic) CGFloat playerCurrentY;
@property (nonatomic) CGFloat playerVelocityX;
@property (nonatomic) CGFloat playerVelocityY;

@property (nonatomic) CGFloat bulletCurrentX;
@property (nonatomic) CGFloat bulletCurrentY;
@property (nonatomic) CGFloat bulletVelocityX;
@property (nonatomic) CGFloat bulletVelocityY;

@property (nonatomic, strong) NSArray *slices;
@property (nonatomic) CGFloat sliceOffset;

@end

@implementation G0Experiment0View

- (id)initWithSlices:(NSArray*)slices {
    self = [super init];
    if (self) {
		self.playerCurrentX = 0;
		self.playerCurrentY = 0;
		self.playerVelocityX = 0;
		self.playerVelocityY = 0;
		
		self.bulletCurrentX = 0;
		self.bulletCurrentY = 0;
		self.bulletVelocityX = 0;
		self.bulletVelocityY = 0;
		
		self.lastTouchReady = NO;
		self.slices = slices;
		self.sliceOffset = 0;
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
		
//		NSLog(@"xy : %.2f %.2f", x, y);
		
		self.lastTouchX = x;
		self.lastTouchY = y;
		self.lastTouchValidUntilTime = CFAbsoluteTimeGetCurrent() + 0.5;
		self.lastTouchReady = YES;
		[self setNeedsDisplay];

	}
}

- (double)xFactor {
	return 50;
}

- (double)yFactor {
	return CGRectGetHeight(self.bounds) / 1.5;
}

- (void)drawSlices {
	
	CGRect bounds = self.bounds;
	CGFloat maxy = CGRectGetMaxY(bounds);
	double yfactor = [self yFactor];
	double xfactor = [self xFactor];
	
	NSInteger n = self.slices.count;
	for (NSInteger i = 0; i<n; i++) {
		G0LevelSlice *slice = [self.slices objectAtIndex:i];
			
		CGFloat height = slice.height * yfactor;
		CGFloat iadjusted = i - self.sliceOffset;
		CGRect r = CGRectMake(iadjusted * xfactor, maxy - height, xfactor, height);
		[[UIColor greenColor] setFill];
		UIBezierPath *path = [UIBezierPath bezierPathWithRect:r];
		[path fill];
	}
}

-(CGPoint)playerPosition {
	CGRect bounds = self.bounds;
//	double yfactor = [self yFactor];
	CGFloat midscreen = (CGRectGetWidth(bounds) / [self xFactor]) / 2.5;
	CGFloat x = self.playerCurrentX + midscreen;
//	CGFloat maxy = CGRectGetMaxY(bounds);
	
	
	NSInteger n = self.slices.count;
	for (NSInteger i = 0; i<n; i++) {
		if (x < i) continue;
		if (x >= (CGFloat)(i + 1)) continue;
		G0LevelSlice *slice = [self.slices objectAtIndex:i];
		
		CGFloat height = slice.height;
		CGFloat iadjusted = i - self.sliceOffset;
		CGRect r = CGRectMake(iadjusted, height, 1, 1);
		CGFloat midx = CGRectGetMidX(r);
		
		return CGPointMake(midx, height);
	}
	return CGPointZero;
}

#if 0
-(void)drawPlayer {
	
	CGRect bounds = self.bounds;
	double yfactor = [self yFactor];
	double xfactor = [self xFactor];
	
	CGPoint point = [self playerPosition];
	
	
	CGFloat midscreen = (CGRectGetWidth(bounds) / [self xFactor]) / 2.5;
	CGFloat x = self.playerCurrentX + midscreen;
	CGFloat maxy = CGRectGetMaxY(bounds);
	
	
	point.x *= xfactor;
	point.y *= yfactor;
	
	
	CGRect r = CGRectMake(iadjusted * xfactor, maxy - height, xfactor, height);
	CGRect rr = CGRectMake(midx - 20, yy - 40, 40, 40);
	
	[[UIColor blackColor] setFill];
	UIBezierPath *path = [UIBezierPath bezierPathWithRect:rr];
	[path fill];
	
	
	NSInteger n = self.slices.count;
	for (NSInteger i = 0; i<n; i++) {
		if (x < i) continue;
		if (x >= (CGFloat)(i + 1)) continue;
		G0LevelSlice *slice = [self.slices objectAtIndex:i];
		
		CGFloat height = slice.height * yfactor;
		CGFloat iadjusted = i - self.sliceOffset;
		CGRect r = CGRectMake(iadjusted * xfactor, maxy - height, xfactor, height);
		CGFloat midx = CGRectGetMidX(r);
		
		CGFloat yy = CGRectGetMinY(r);
		
		CGRect rr = CGRectMake(midx - 20, yy - 40, 40, 40);
		
		[[UIColor blackColor] setFill];
		UIBezierPath *path = [UIBezierPath bezierPathWithRect:rr];
		[path fill];
	}
}
#endif

-(void)drawPlayer {
	
	CGRect bounds = self.bounds;
	double yfactor = [self yFactor];
	double xfactor = [self xFactor];
	CGFloat midscreen = (CGRectGetWidth(bounds) / [self xFactor]) / 2.5;
	CGFloat x = self.playerCurrentX + midscreen;
	CGFloat maxy = CGRectGetMaxY(bounds);
	
	
	NSInteger n = self.slices.count;
	for (NSInteger i = 0; i<n; i++) {
		if (x < i) continue;
		if (x >= (CGFloat)(i + 1)) continue;
		G0LevelSlice *slice = [self.slices objectAtIndex:i];
		
		CGFloat height = slice.height * yfactor;
		CGFloat iadjusted = i - self.sliceOffset;
		CGRect r = CGRectMake(iadjusted * xfactor, maxy - height, xfactor, height);
		CGFloat midx = CGRectGetMidX(r);
		
		CGFloat yy = CGRectGetMinY(r);
		
		CGRect rr = CGRectMake(midx - 20, yy - 40, 40, 40);
		
		[[UIColor blackColor] setFill];
		UIBezierPath *path = [UIBezierPath bezierPathWithRect:rr];
		[path fill];
	}
}


- (void)drawRect:(CGRect)rect {
	{
		[[UIColor redColor] setFill];
		UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
		[path fill];
	}
	
	[self drawSlices];
	[self drawPlayer];

	
	double t = CFAbsoluteTimeGetCurrent();
	
	if (self.lastTouchReady) {
		
		if (self.lastTouchX > 0) {
			self.playerCurrentX += 1.f;
		} else {
			self.playerCurrentX -= 1.f;
		}
		
		if (self.lastTouchY < 0) {
			NSLog(@"fire");
			[[UIColor whiteColor] setFill];
			UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
			[path fill];
			
//			self.bulletCurrentX = self.playerCurrentX;
//			self.bulletCurrentY =
		}
		
		self.lastTouchReady = NO;
	}
	
	if (t < self.lastTouchValidUntilTime) {
		CGRect b = self.bounds;
		CGFloat x = remap(self.lastTouchX, -1, +1, 0, CGRectGetWidth(b));
		CGFloat y = remap(self.lastTouchY, -1, +1, 0, CGRectGetHeight(b));
		CGRect r = CGRectMake(x - 5, y - 5, 10, 10);
		
		[[UIColor whiteColor] setFill];
		UIBezierPath *path = [UIBezierPath bezierPathWithRect:r];
		[path fill];
	}
	
	double diff = self.sliceOffset - self.playerCurrentX;
	if (diff > 5) {
		self.sliceOffset -= 1;
	}
	if (diff < -5) {
		self.sliceOffset += 1;
	}

	
	self.playerCurrentX += self.playerVelocityX;
	self.playerCurrentY += self.playerVelocityY;
	self.playerVelocityX /= 0.9f;
	self.playerVelocityY /= 0.9f;
	if (self.playerVelocityX < 0.2f) {
		self.playerVelocityX = 0.f;
	}
	if (self.playerVelocityY < 0.2f) {
		self.playerVelocityY = 0.f;
	}
	
}

- (void)displayLinkUpdate:(CADisplayLink*)displayLink {
	[self setNeedsDisplay];
}


@end

