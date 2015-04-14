//
//  Cell.m
//  Number_Puzzle
//
//  Created by Wang Baiyang on 3/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Cell.h"

@implementation Cell{
    
    CCNodeColor *_defaultNode;
    CCLabelTTF *_valueLabel;
}

- (void)didLoadFromCCB {
    [self updateValueDisplay];
}

- (id)init {
    self = [super init];
    if (self) {
        self.value = (arc4random()%2+1)*2;
    }
    return self;
}

- (void)updateValueDisplay {
    _valueLabel.string = [NSString stringWithFormat:@"%d", self.value];
}

@end
