#import "MainScene.h"
#import "Grid.h"

@implementation MainScene{
    
    Grid *_grid;
    CCLabelTTF *_stepLabel;
    CCLabelTTF *_lowestReachLabel;
    CCLabelTTF *_timerLabel;
}

- (void)didLoadFromCCB {
    
    [_grid addObserver:self forKeyPath:@"score" options:0 context:NULL];
    [_grid addObserver:self forKeyPath:@"timeleft" options:0 context:NULL];
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:@"highscore"
                                               options:0
                                               context:NULL];
    // load highscore
    [self updatelowestReach];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"score"]) {
        _stepLabel.string = [NSString stringWithFormat:@"%d", _grid.score];
    }else if ([keyPath isEqualToString:@"timeleft"]) {
        if(_grid.timeleft>=10){
            _timerLabel.string = [NSString stringWithFormat:@"0:%d", _grid.timeleft];
        }else{
            _timerLabel.string = [NSString stringWithFormat:@"0:0%d", _grid.timeleft];
        }
        
    }else if ([keyPath isEqualToString:@"highscore"]) {
        [self updatelowestReach];
    }
}

- (void)dealloc {
    [_grid removeObserver:self forKeyPath:@"score"];
    [_grid removeObserver:self forKeyPath:@"timeleft"];
}

- (void)updatelowestReach {
    NSNumber *newHighscore = [[NSUserDefaults standardUserDefaults] objectForKey:@"highscore"];
    if (newHighscore) {
        _lowestReachLabel.string = [NSString stringWithFormat:@"%d", [newHighscore intValue]];
    }
}

@end
