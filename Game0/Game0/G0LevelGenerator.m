//
//  G0LevelGenerator.m
//  Game0
//
//  Created by Simon Strandgaard on 12/10/13.
//  Copyright (c) 2013 Game0 Organization. All rights reserved.
//

#import "G0LevelGenerator.h"
#import "G0LevelSlice.h"

@implementation G0LevelGenerator

+(NSArray*)generateSlice0 {
	NSMutableArray *slices = [NSMutableArray new];
	for (NSUInteger i=0; i<1000; i++) {
		double h = (double)i / 1000.0;
		
		G0LevelSlice *slice = [[G0LevelSlice alloc] initWithWidth:1.0 height:h];
		
		[slices addObject:slice];
	}
	
	return slices.copy;
}

@end
