#import "MainScene.h"
#import "Grid.h"

@implementation MainScene{
    
    Grid *_grid;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_highestscoreLabel;
}

- (void)didLoadFromCCB {
    [_grid addObserver:self forKeyPath:@"score" options:0 context:NULL];
    //Display the highest score
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:@"highscore"
                                               options:0
                                               context:NULL];
    // load highscore
    [self updateHighscore];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"score"]) {
        _scoreLabel.string = [NSString stringWithFormat:@"%d", _grid.score];
    }else if ([keyPath isEqualToString:@"highscore"]) {
        [self updateHighscore];
    }
}

- (void)dealloc {
    [_grid removeObserver:self forKeyPath:@"score"];
}

- (void)updateHighscore {
    NSNumber *newHighscore = [[NSUserDefaults standardUserDefaults] objectForKey:@"highscore"];
    if (newHighscore) {
        _highestscoreLabel.string = [NSString stringWithFormat:@"%d", [newHighscore intValue]];
    }
}

@end
