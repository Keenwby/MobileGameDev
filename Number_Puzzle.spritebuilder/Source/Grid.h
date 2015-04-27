//
//  Grid.h
//  Number_Puzzle
//
//  Created by Wang Baiyang on 3/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNodeColor.h"

@interface Grid : CCNodeColor

@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger winscore;
@property (nonatomic, assign) NSInteger timeleft;
@property int n ;
@property int second;
@property NSInteger maxvalue;
@property NSInteger livecells;
@property NSInteger lastvalue;

- (void) setNum:(NSInteger)Value;

@end
