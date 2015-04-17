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

static const NSInteger GRID_SIZE = 5;
static int Fibonacci[GRID_SIZE * GRID_SIZE - 1];
static int num = -1;

- (void)didLoadFromCCB {
    [self initFibonacci];
    [self updateValueDisplay];
}

- (id)init {
    self = [super init];
    if (self) {
        self.value = Fibonacci[num++];
    }
    return self;
}

- (void)updateValueDisplay {
    _valueLabel.string = [NSString stringWithFormat:@"%d", self.value];
    
    CCColor *defaultNode = nil;
    
    switch (self.value) {
        case 2:
            defaultNode = [CCColor colorWithRed:20.f/255.f green:20.f/255.f blue:80.f/255.f];
            break;
        case 4:
            defaultNode = [CCColor colorWithRed:20.f/255.f green:20.f/255.f blue:140.f/255.f];
            break;
        case 8:
            defaultNode = [CCColor colorWithRed:20.f/255.f green:60.f/255.f blue:220.f/255.f];
            break;
        case 16:
            defaultNode = [CCColor colorWithRed:20.f/255.f green:120.f/255.f blue:120.f/255.f];
            break;
        case 32:
            defaultNode = [CCColor colorWithRed:20.f/255.f green:160.f/255.f blue:120.f/255.f];
            break;
        case 64:
            defaultNode = [CCColor colorWithRed:20.f/255.f green:160.f/255.f blue:60.f/255.f];
            break;
        case 128:
            defaultNode = [CCColor colorWithRed:50.f/255.f green:160.f/255.f blue:60.f/255.f];
            break;
        case 256:
            defaultNode = [CCColor colorWithRed:80.f/255.f green:120.f/255.f blue:60.f/255.f];
            break;
        case 512:
            defaultNode = [CCColor colorWithRed:140.f/255.f green:70.f/255.f blue:60.f/255.f];
            break;
        case 1024:
            defaultNode = [CCColor colorWithRed:170.f/255.f green:30.f/255.f blue:60.f/255.f];
            break;
        case 2048:
            defaultNode = [CCColor colorWithRed:220.f/255.f green:30.f/255.f blue:30.f/255.f];
            break;
        default:
            defaultNode = [CCColor greenColor];
            break;
    }
    
    _defaultNode.color = defaultNode;
}

- (void)initFibonacci{
    Fibonacci[0] = 1;
    Fibonacci[1] = 1;
    for(int i = 2; i < GRID_SIZE * GRID_SIZE - 1; i++){
        Fibonacci[i] = Fibonacci[i - 1] + Fibonacci[i - 2];
    }
}

@end
