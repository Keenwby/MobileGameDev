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
}

- (void)newGame {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    Cell.initnum;
    [[CCDirector sharedDirector]replaceScene:mainScene];
}

- (void)setMessage:(NSString *)message score:(NSInteger)score {
    _messageLabel.string = message;
    _scoreLabel.string = [NSString stringWithFormat:@"%d", score];
}

@end
