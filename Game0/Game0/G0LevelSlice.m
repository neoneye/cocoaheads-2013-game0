//
//  G0LevelSlice.m
//  Game0
//
//  Created by Simon Strandgaard on 12/10/13.
//  Copyright (c) 2013 Game0 Organization. All rights reserved.
//

#import "G0LevelSlice.h"

@interface G0LevelSlice ()

@property (nonatomic) double height;
@property (nonatomic) double width;

@end

@implementation G0LevelSlice

-(id)initWithWidth:(double)width height:(double)height {
	self = [super init];
	self.height = height;
	self.width = width;
	return self;
}

@end
