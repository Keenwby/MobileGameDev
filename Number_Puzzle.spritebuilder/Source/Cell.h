//
//  Cell.h
//  Number_Puzzle
//
//  Created by Wang Baiyang on 3/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Cell : CCNode

@property (nonatomic, assign) NSInteger value;
- (void)updateValueDisplay;
- (void) setNum:(NSInteger)Value;
@property (nonatomic, assign) BOOL mergedThisRound;

@end
