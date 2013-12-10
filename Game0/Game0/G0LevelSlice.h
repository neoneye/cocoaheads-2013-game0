//
//  G0LevelSlice.h
//  Game0
//
//  Created by Simon Strandgaard on 12/10/13.
//  Copyright (c) 2013 Game0 Organization. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface G0LevelSlice : NSObject

@property (nonatomic, readonly) double height;
@property (nonatomic, readonly) double width;

-(id)initWithWidth:(double)width height:(double)height;

@end
