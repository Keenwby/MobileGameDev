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

<<<<<<< HEAD
static const NSInteger MAX_NUM = 24;
static int Fibonacci[MAX_NUM];
=======
static const NSInteger WIN_NUM = 25;
static int Fibonacci[WIN_NUM];
>>>>>>> origin/master
int num = -1;
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
    
    if (self.value == 1) {
        defaultNode = [CCColor colorWithRed:0.f/255.f green:255.f/255.f blue:0.f/255.f];
    }else if(self.value == 2){
        defaultNode = [CCColor colorWithRed:0.f/255.f green:245.f/255.f blue:0.f/255.f];
    }else if(self.value == 3){
        defaultNode = [CCColor colorWithRed:0.f/255.f green:235.f/255.f blue:0.f/255.f];
    }else if(self.value > 3 && self.value <= 5){
        defaultNode = [CCColor colorWithRed:0.f/255.f green:225.f/255.f blue:0.f/255.f];
    }else if(self.value > 5 && self.value <= 8){
        defaultNode = [CCColor colorWithRed:0.f/255.f green:215.f/255.f blue:0.f/255.f];
    }else if(self.value > 8 && self.value <= 13){
        defaultNode = [CCColor colorWithRed:0.f/255.f green:200.f/255.f blue:0.f/255.f];
    }else if(self.value > 13 && self.value <= 21){
        defaultNode = [CCColor colorWithRed:0.f/255.f green:195.f/255.f blue:0.f/255.f];
    }else if(self.value > 21 && self.value <= 34){
        defaultNode = [CCColor colorWithRed:0.f/255.f green:170.f/255.f blue:0.f/255.f];
    }else if(self.value > 34 && self.value <= 55){
        defaultNode = [CCColor colorWithRed:0.f/255.f green:155.f/255.f blue:0.f/255.f];
    }else if(self.value > 55 && self.value <= 89){
        defaultNode = [CCColor colorWithRed:0.f/255.f green:140.f/255.f blue:0.f/255.f];
    }else if(self.value > 89 && self.value <= 144){
        defaultNode = [CCColor colorWithRed:0.f/255.f green:125.f/255.f blue:0.f/255.f];
    }else if(self.value > 144 && self.value <= 233){
        defaultNode = [CCColor colorWithRed:0.f/255.f green:110.f/255.f blue:0.f/255.f];
    }else if(self.value > 233 && self.value <= 377){
        defaultNode = [CCColor colorWithRed:0.f/255.f green:95.f/255.f blue:0.f/255.f];
    }else if(self.value > 377 && self.value <= 610){
        defaultNode = [CCColor colorWithRed:0.f/255.f green:80.f/255.f blue:0.f/255.f];
    }else if(self.value > 610 && self.value <= 987){
        defaultNode = [CCColor colorWithRed:0.f/255.f green:65.f/255.f blue:0.f/255.f];
    }else if(self.value > 987 && self.value <= 1597){
        defaultNode = [CCColor colorWithRed:0.f/255.f green:50.f/255.f blue:0.f/255.f];
    }else if(self.value > 1597 && self.value <= 2584){
        defaultNode = [CCColor colorWithRed:0.f/255.f green:35.f/255.f blue:0.f/255.f];
    }
    
    _defaultNode.color = defaultNode;
}

- (void)initFibonacci{
    Fibonacci[0] = 1;
    Fibonacci[1] = 1;
    for(int i = 2; i < MAX_NUM; i++){
        Fibonacci[i] = Fibonacci[i - 1] + Fibonacci[i - 2];
    }
}

- (void) setNum:(NSInteger)Value {
    num = Value;
}

@end
