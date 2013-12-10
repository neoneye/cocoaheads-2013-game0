//
//  G0LevelGenerator.m
//  Game0
//
//  Created by Simon Strandgaard on 12/10/13.
//  Copyright (c) 2013 Game0 Organization. All rights reserved.
//

#import "G0LevelGenerator.h"
#import "G0LevelSlice.h"

// returns floating point numbers between -1.0 and 1.0
float random_1d(int x) {
	int s = 71 * x; s = s * 8192 ^ s;
	return 1.0 - ((s*(s*s*15731+789221)+1376312589)&0x7fffffff)/1073741824.0;
}

@implementation G0LevelGenerator

+(NSArray*)generateSlice0 {
	NSMutableArray *slices = [NSMutableArray new];
	for (NSUInteger i=0; i<1000; i++) {
		double h = (double)i / 1000.0;
		h += random_1d(i) * 0.5f;
		h += 0.1f;
		
		G0LevelSlice *slice = [[G0LevelSlice alloc] initWithWidth:1.0 height:h];
		
		[slices addObject:slice];
	}
	
	return slices.copy;
}

@end
