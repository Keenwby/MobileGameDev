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

static const NSInteger WIN_NUM = 25;
static int Fibonacci[WIN_NUM];
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
        case 1:
            defaultNode = [CCColor colorWithRed:0.f/255.f green:240.f/255.f blue:0.f/255.f];
            break;
        case 2:
            defaultNode = [CCColor colorWithRed:0.f/255.f green:220.f/255.f blue:0.f/255.f];
            break;
        case 3:
            defaultNode = [CCColor colorWithRed:0.f/255.f green:200.f/255.f blue:0.f/255.f];
            break;
        case 5:
            defaultNode = [CCColor colorWithRed:0.f/255.f green:180.f/255.f blue:0.f/255.f];
            break;
        case 8:
            defaultNode = [CCColor colorWithRed:0.f/255.f green:160.f/255.f blue:0.f/255.f];
            break;
        case 13:
            defaultNode = [CCColor colorWithRed:0.f/255.f green:140.f/255.f blue:0.f/255.f];
            break;
        case 21:
            defaultNode = [CCColor colorWithRed:0.f/255.f green:120.f/255.f blue:0.f/255.f];
            break;
        case 34:
            defaultNode = [CCColor colorWithRed:0.f/255.f green:100.f/255.f blue:0.f/255.f];
            break;
        case 55:
            defaultNode = [CCColor colorWithRed:0.f/255.f green:88.f/255.f blue:0.f/255.f];
            break;
        case 89:
            defaultNode = [CCColor colorWithRed:0.f/255.f green:65.f/255.f blue:0.f/255.f];
            break;
        case 144:
            defaultNode = [CCColor colorWithRed:0.f/255.f green:42.f/255.f blue:0.f/255.f];
            break;
        case 233:
            defaultNode = [CCColor colorWithRed:0.f/255.f green:21.f/255.f blue:0.f/255.f];
            break;
        case 377:
            defaultNode = [CCColor colorWithRed:0.f/255.f green:10.f/255.f blue:0.f/255.f];
            break;
        case 610:
            defaultNode = [CCColor colorWithRed:0.f/255.f green:0.f/255.f blue:0.f/255.f];
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
    for(int i = 2; i < WIN_NUM; i++){
        Fibonacci[i] = Fibonacci[i - 1] + Fibonacci[i - 2];
    }
}

@end
