//
//  Grid.m
//  Number_Puzzle
//
//  Created by Wang Baiyang on 3/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Cell.h"
#import "GameEnd.h"

@implementation Grid{
    
    //Store the size information of Grid
    CGFloat _cellWidth;
    CGFloat _cellInterval;
    //Store the cell using index of Grid
    NSMutableArray *_gridArray;
    NSNull *_emptyCell;
}

static const NSInteger GRID_SIZE = 3;
static const NSInteger INIT_CELL = GRID_SIZE * GRID_SIZE - 1;
static const NSInteger STOP_NUM = 610;
static const NSInteger TIME_LIM = 15;

- (void)didLoadFromCCB{
    //Set up the grid immediately the scene is initialized
    [self setup];
    
    //Init the start cells
    _gridArray = [NSMutableArray array];
    _emptyCell = [NSNull null];
    for(int i = 0; i < GRID_SIZE; i++){
        _gridArray[i] = [NSMutableArray array];
        for(int j = 0; j < GRID_SIZE; j++){
            _gridArray[i][j] = _emptyCell;
        }
    }
    [self spawnStartCells];
    [self addGesture];
    [self iniTimer];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
}

- (void) setup{
    //Load the cell
    CCNode *cell = [CCBReader load:@"Cell"];
    _cellWidth = cell.contentSize.width;
    //Calculate the interval
    _cellInterval = (self.contentSize.width - GRID_SIZE * _cellWidth)/(GRID_SIZE + 1);
    
    [cell performSelector:@selector(cleanup)];
    
    //Set up the Grid
    float x = 0.0;
    float y = _cellInterval;
    for(int i = 0; i < GRID_SIZE; i++){
        x = _cellInterval;

        for(int j = 0; j < GRID_SIZE; j++){
            CCNodeColor *defaultNode = [CCNodeColor nodeWithColor:[CCColor grayColor]];
            defaultNode.position = ccp(x,y);
            defaultNode.contentSize = CGSizeMake(_cellWidth, _cellWidth);
            [self addChild: defaultNode];
            x+= _cellInterval + _cellWidth;
        }
        y += _cellInterval + _cellWidth;
    }
}

- (void) addCellAtColunm: (NSInteger)column Row: (NSInteger) row {
    
    //Load the cell
    Cell *cell = (Cell*)[CCBReader load:@"Cell"];
    //Store the cell into _gridArray
    _gridArray[column][row] = cell;
    //Set the position of the cell
    float x = _cellInterval * (column + 1)  + _cellWidth * column;
    float y = _cellInterval * (row + 1)  + _cellWidth * row;
    cell.scale = 0.0f;
    cell.position = CGPointMake(x,y);
    [self addChild: cell];
    //Create a scale-up animation for the cell
    CCActionDelay *delay = [CCActionDelay actionWithDuration:0.2f];
    CCActionScaleTo *scaleUp = [CCActionScaleTo actionWithDuration:0.3f scale:1.0f];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[delay, scaleUp]];
    //Run the animation
    self.maxvalue = cell.value;
    [cell runAction:sequence];
}

- (void)spawnStartCells {
    for (int i = 0; i < INIT_CELL; i++) {
        [self spawnRandomCell];
    }
}

- (void)spawnRandomCell {
    BOOL spawned = NO;
    
    while (!spawned) {
        NSInteger randomRow = arc4random() % GRID_SIZE;
        NSInteger randomColumn = arc4random() % GRID_SIZE;
        
        BOOL positionFree = (_gridArray[randomColumn][randomRow] == _emptyCell);
        
        if (positionFree) {
            [self addCellAtColunm:randomColumn Row: randomRow];
            spawned = YES;
        }
    }
}

- (void)addGesture
{
    UISwipeGestureRecognizer * toLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [toLeft setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[[CCDirector sharedDirector] view] addGestureRecognizer:toLeft];
    
    UISwipeGestureRecognizer * toRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [toRight setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[[CCDirector sharedDirector] view] addGestureRecognizer:toRight];
    
    UISwipeGestureRecognizer * toUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp:)];
    [toUp setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [[[CCDirector sharedDirector] view] addGestureRecognizer:toUp];
    
    UISwipeGestureRecognizer * toDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
    [toDown setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[[CCDirector sharedDirector] view] addGestureRecognizer:toDown];
}

- (void)handleSwipeRight:(UIGestureRecognizer *)gesture
{
    [self move:ccp(1, 0)];
}

- (void)handleSwipeLeft:(UIGestureRecognizer *)gesture
{
    [self move:ccp(-1, 0)];
    
}

- (void)handleSwipeUp:(UIGestureRecognizer *)gesture
{
    [self move:ccp(0, 1)];
    
}

- (void)handleSwipeDown:(UIGestureRecognizer *)gesture
{
    [self move:ccp(0, -1)];

}

- (void)move:(CGPoint)direction {

    // apply negative vector until reaching boundary, this way we get the Cell that is the furthest away
    //bottom left corner
    NSInteger currentX = 0;
    NSInteger currentY = 0;
    
    BOOL movedCellsThisRound = FALSE;
    
    // Move to relevant edge by applying direction until reaching border
    while ([self indexValid:currentX y:currentY]) {
        CGFloat newX = currentX + direction.x;
        CGFloat newY = currentY + direction.y;
        if ([self indexValid:newX y:newY]) {
            currentX = newX;
            currentY = newY;
        } else {
            break;
        }
    }
    // store initial row value to reset after completing each column
    NSInteger initialY = currentY;
    // define changing of x and y value (moving left, up, down or right?)
    NSInteger xChange = -direction.x;
    NSInteger yChange = -direction.y;
    if (xChange == 0) {
        xChange = 1;
    }
    if (yChange == 0) {
        yChange = 1;
    }
    // visit column for column
    while ([self indexValid:currentX y:currentY]) {
        while ([self indexValid:currentX y:currentY]) {
            // get Cell at current index
            Cell *cell = _gridArray[currentX][currentY];
            if ([cell isEqual:_emptyCell]) {
                // if there is no Cell at this index -> skip
                currentY += yChange;
                continue;
            }
            // store index in temp variables to change them and store new location of this Cell
            NSInteger newX = currentX;
            NSInteger newY = currentY;
            /* find the farthest position by iterating in direction of the vector until we reach border of grid or an occupied cell*/
            while ([self indexValidAndUnoccupied:newX+direction.x y:newY+direction.y]) {
                newX += direction.x;
                newY += direction.y;
            }
            BOOL performMove = FALSE;
            /* If we stopped moving in vector direction, but next index in vector direction is valid, this means the cell is occupied. Let's check if we can merge them*/
            if ([self indexValid:newX+direction.x y:newY+direction.y]) {
                // get the other Cell
                NSInteger otherCellX = newX + direction.x;
                NSInteger otherCellY = newY + direction.y;
                Cell *otherCell = _gridArray[otherCellX][otherCellY];
                // compare value of other Cell and also check if the other thile has been merged this round
                if (cell.value >= otherCell.value && !otherCell.mergedThisRound) {
                    // merge tiles
                    [self mergeCellAtIndex:currentX y:currentY withCellAtIndex:otherCellX y:otherCellY];
                    movedCellsThisRound = YES;
                } else {
                    // we cannot merge so we want to perform a move
                    performMove = YES;
                }
            } else {
                // we cannot merge so we want to perform a move
                performMove = YES;
            }
            if (performMove) {
                // Move Cell to furthest position
                if (newX != currentX || newY !=currentY) {
                    // only move Cell if position changed
                    [self moveCell:cell fromIndex:currentX oldY:currentY newX:newX newY:newY];
                    //movedCellsThisRound = TRUE;
                    [self playSound:@"swipe" ofType:@"mp3"];
                }
            }
            // move further in this column
            currentY += yChange;
        }
        // move to the next column, start at the inital row
        currentX += xChange;
        currentY = initialY;
    }
   
    self.score++;
    if (movedCellsThisRound) {
        if (self.maxvalue < STOP_NUM) {
         [self spawnRandomCell];
        }
        [self iniTimer];
        for (int i = 0; i < GRID_SIZE; i++) {
            for (int j = 0; j < GRID_SIZE; j++) {
                Cell *cell = _gridArray[i][j];
                if (![cell isEqual:_emptyCell]) {
                    // reset merged flag
                    cell.mergedThisRound = FALSE;
                }
            }
        }
    }
    
}

- (BOOL)indexValid:(NSInteger)x y:(NSInteger)y {
    BOOL indexValid = TRUE;
    indexValid &= x >= 0;
    indexValid &= y >= 0;
    if (indexValid) {
        indexValid &= x < (int) [_gridArray count];
        if (indexValid) {
            indexValid &= y < (int) [(NSMutableArray*) _gridArray[x] count];
        }
    }
    return indexValid;
}

- (BOOL)indexValidAndUnoccupied:(NSInteger)x y:(NSInteger)y {
    BOOL indexValid = [self indexValid:x y:y];
    if (!indexValid) {
        return FALSE;
    }
    BOOL unoccupied = [_gridArray[x][y] isEqual:_emptyCell];
    return unoccupied;
}

- (void)moveCell:(Cell *)cell fromIndex:(NSInteger)oldX oldY:(NSInteger)oldY newX:(NSInteger)newX newY:(NSInteger)newY {
    _gridArray[newX][newY] = _gridArray[oldX][oldY];
    _gridArray[oldX][oldY] = _emptyCell;
    CGPoint newPosition = [self positionForColumn:newX row:newY];
    CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:0.2f position:newPosition];
    [cell runAction:moveTo];
}

- (CGPoint)positionForColumn:(NSInteger)column row:(NSInteger)row {
    NSInteger x = _cellInterval + column * (_cellInterval + _cellWidth);
    NSInteger y = _cellInterval + row * (_cellInterval + _cellWidth);
    return CGPointMake(x,y);
}

- (void)mergeCellAtIndex:(NSInteger)x y:(NSInteger)y withCellAtIndex:(NSInteger)xOtherCell y:(NSInteger)yOtherCell {
    // 1) update the game data
    Cell *mergedCell = _gridArray[x][y];
    Cell *otherCell = _gridArray[xOtherCell][yOtherCell];
    //Tracking scores
    otherCell.value = mergedCell.value - otherCell.value;
    otherCell.mergedThisRound = TRUE;
    _gridArray[x][y] = _emptyCell;
    // 2) update the UI
    CGPoint otherCellPosition = [self positionForColumn:xOtherCell row:yOtherCell];
    CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:0.2f position:otherCellPosition];
    CCActionRemove *remove = [CCActionRemove action];
    CCActionCallBlock *mergeCell = [CCActionCallBlock actionWithBlock:^{
        [otherCell updateValueDisplay];
        [self playSound:@"merge" ofType:@"mp3"];
    }];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[moveTo, mergeCell, remove]];
    [mergedCell runAction:sequence];
}

- (void)win {
    Cell *cell = (Cell*)[CCBReader load:@"Cell"];
    [cell setNum: -1];
    [self endGameWithMessage:@"You win!"];
}

- (void)lose {
    Cell *cell = (Cell*)[CCBReader load:@"Cell"];
    [cell setNum: -1];
    [self endGameWithMessage:@"You lose!"];
}

- (void)endGameWithMessage:(NSString*)message {
    GameEnd *gameEndPopover = (GameEnd *)[CCBReader load:@"GameEnd"];
    gameEndPopover.positionType = CCPositionTypeNormalized;
    gameEndPopover.position = ccp(0.5, 0.5);
    gameEndPopover.zOrder = INT_MAX;
    
    [gameEndPopover setMessage:message score:self.score];
    
    [self addChild:gameEndPopover];
    
    NSNumber *highScore = [[NSUserDefaults standardUserDefaults] objectForKey:@"highscore"];
    if (self.score > [highScore intValue]) {
        // new highscore!
        highScore = [NSNumber numberWithInt:self.score];
        [[NSUserDefaults standardUserDefaults] setObject:highScore forKey:@"highscore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (id)cellForIndex:(NSInteger)x y:(NSInteger)y {
    if (![self indexValid:x y:y]) {
        return _emptyCell;
    } else {
        return _gridArray[x][y];
    }
}

//Sound Effect
-(void)playSound:(NSString*)sound ofType:(NSString*)soundType
{
    
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(dispatchQueue, ^(void) {
        
        CFBundleRef mainBundle = CFBundleGetMainBundle();
        CFURLRef soundFileURLref;
        soundFileURLref = CFBundleCopyResourceURL(mainBundle ,(__bridge CFStringRef)sound,CFSTR ("wav"),NULL);
        UInt32 soundID;
        AudioServicesCreateSystemSoundID(soundFileURLref, &soundID);
        AudioServicesPlaySystemSound(soundID);
        CFRelease(soundFileURLref);
        
    });
}

-(void) iniTimer{
    
    self.n = TIME_LIM;
    self.second = TIME_LIM;
    
}

-(void)updateTimer:(NSTimer *)timer
{
    self.second = self.second - 1;
    if(self.second < 0){
        [timer invalidate];
        [self lose];
    }
    self.timeleft = self.n;
    self.n = self.n - 1;
}


@end
