//
//  G0ViewController.m
//  Game0
//
//  Copyright (c) 2013 Game0 Organization. All rights reserved.
//

#import "G0ViewController.h"
#import "G0Experiment0View.h"
#import "G0LevelGenerator.h"

@interface G0ViewController ()
@property (nonatomic, strong) G0Experiment0View *gameView;
@end

@implementation G0ViewController

-(void)loadView {
	// Ensure that we don't load an .xib file for this viewcontroller
	self.view = [UIView new];
	
	NSArray *slices = [G0LevelGenerator generateSlice0];
	self.gameView = [[G0Experiment0View alloc] initWithSlices:slices];
	[self.view addSubview:self.gameView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
	self.gameView.frame = self.view.bounds;
}

@end
