//
//  GameEnd.m
//  Number_Puzzle
//
//  Created by Wang Baiyang on 4/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameEnd.h"
#import "Cell.h"

@implementation GameEnd {
    CCLabelTTF *_messageLabel;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_lastValueLabel;
}

- (void)newGame {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector]replaceScene:mainScene];
}

- (void)setMessage:(NSString *)message score:(NSInteger)score with:(NSInteger) lastvalue{
    _messageLabel.string = message;
    _scoreLabel.string = [NSString stringWithFormat:@"Step: %ld", (long)score];
    _lastValueLabel.string = [NSString stringWithFormat:@"Lowest Reached: %ld", (long)lastvalue];
}

@end
