//
//  Grid.h
//  Number_Puzzle
//
//  Created by Wang Baiyang on 3/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNodeColor.h"

@interface Grid : CCNodeColor

@property (nonatomic, assign) NSInteger score;//Step count
@property (nonatomic, assign) NSInteger winscore;//WinScore
@property (nonatomic, assign) NSInteger timeleft;//Timer max
@property int n ;//Timer
@property int second;//Timer
@property NSInteger maxvalue;//Max value in gird
@property NSInteger livecells;//Live cells count
@property NSInteger lastvalue;//Last value

- (void) setNum:(NSInteger)Value;

@end
