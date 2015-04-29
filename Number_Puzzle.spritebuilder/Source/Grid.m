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
    //Store the touch position
    float touch_x;
    float touch_y;
}

static NSInteger GRID_SIZE = 3;//Grid size
static const NSInteger TIME_LIM = 15;//Time limitation for each merge
static const NSInteger STOP_NUM_SMALL = 610;//Stop number for 3*3 grid
static const NSInteger STOP_NUM_BIG = 2584;//Stop number for 4*4 grid

- (void)didLoadFromCCB{
    //Set up the grid
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
    //Enable UI touch & Gesture recognizer
    self.userInteractionEnabled = TRUE;
    [self addGesture];
    //Init Timer
    [self iniTimer];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
}

-(void) touchBegan:(CCTouch *)touch withEvent:(UIEvent *)event//Touch recognizer
{
    CGPoint touchLocation = [touch locationInNode:self];
    BOOL spawned = NO;
    //Get Touch Location
    touch_x = touchLocation.x;
    touch_y = touchLocation.y;
}

- (void) setup{//Set up the grid
    //Init the number of live Cells
    self.livecells = 0;
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

- (void) addCellAtColunm: (NSInteger)column Row: (NSInteger) row {//Add cell at (row, col)
    
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
    //Record the max value in grid
    self.maxvalue = cell.value;
    //Increase live cell num
    self.livecells++;
    //Create a scale-up animation for the cell
    CCActionDelay *delay = [CCActionDelay actionWithDuration:0.2f];
    CCActionScaleTo *scaleUp = [CCActionScaleTo actionWithDuration:0.3f scale:1.0f];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[delay, scaleUp]];
    //Run the animation
    [cell runAction:sequence];
}

- (void)spawnStartCells {//Spawn start cells
    int initnum;
    if (GRID_SIZE == 3) {
        initnum = GRID_SIZE * GRID_SIZE - 1;
    }
    
    if (GRID_SIZE == 4) {
        initnum = GRID_SIZE * GRID_SIZE - 4;
    }
    
    for (int i = 0; i < initnum; i++) {
        [self spawnRandomCell];
    }
}

- (void)spawnRandomCell {//Spawn a cell at a random positon
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

- (void)addGesture//Gesture recognizer in four directions
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

- (void)move:(CGPoint)direction{//Cell moving algorithm
    
    //Get the touch postions
    NSInteger currentX = (int)(touch_x / (_cellWidth + _cellInterval));
    NSInteger currentY = (int)(touch_y / (_cellWidth + _cellInterval));
    //Flag of merge
    BOOL mergedCellsThisRound = FALSE;
    
    //Move the cursor to the futherest end in the line contains touching position along moving direction
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
   
    // define changing of x and y value of the cursor
    NSInteger xChange = -direction.x;
    NSInteger yChange = -direction.y;

    while ([self indexValid:currentX y:currentY]) {
        // get Cell at current index
        Cell *cell = _gridArray[currentX][currentY];
        if ([cell isEqual:_emptyCell]) {
            //Skip if empty
            currentY += yChange;
            currentX += xChange;
            continue;
        }
        //Store new location if not empty
        NSInteger newX = currentX;
        NSInteger newY = currentY;
        //Find the furthest position
        while ([self indexValidAndUnoccupied:newX+direction.x y:newY+direction.y]) {
            newX += direction.x;
            newY += direction.y;
        }
        //Flag of move
        BOOL performMove = FALSE;
        if ([self indexValid:newX+direction.x y:newY+direction.y]) {
            // get the other Cell
            NSInteger otherCellX = newX + direction.x;
            NSInteger otherCellY = newY + direction.y;
            Cell *otherCell = _gridArray[otherCellX][otherCellY];
            //Check if merging condition is satisfied
            if (cell.value >= otherCell.value && !otherCell.mergedThisRound) {
                //Merge cell
                [self mergeCellAtIndex:currentX y:currentY withCellAtIndex:otherCellX y:otherCellY];
                mergedCellsThisRound = YES;
            } else {
                //Move if cannot merge
                performMove = YES;
            }
        } else {
            //Move if cannot merge
            performMove = YES;
        }
        if (performMove) {
            //Move Cell to furthest position
            if (newX != currentX || newY !=currentY) {
                //Only move Cell if position changed
                [self moveCell:cell fromIndex:currentX oldY:currentY newX:newX newY:newY];
                //Sound effect of move
                [self playSound:@"swipe" ofType:@"mp3"];
            }
        }
        // move further
        currentY += yChange;
        currentX += xChange;
    }
    //Step count increases
    self.score++;
    //Spawn new cell after each merge
    if (mergedCellsThisRound) {
        switch (GRID_SIZE){
            case 3:
                if (self.maxvalue < STOP_NUM_SMALL) {
                    [self spawnRandomCell];
                }
                break;
            case 4:
                if (self.maxvalue < STOP_NUM_BIG) {
                    [self spawnRandomCell];
                }
                break;
        }
        //Init timer after merge
        [self iniTimer];
        for (int i = 0; i < GRID_SIZE; i++) {
            for (int j = 0; j < GRID_SIZE; j++) {
                Cell *cell = _gridArray[i][j];
                if (![cell isEqual:_emptyCell]) {
                    // reset merge flag
                    cell.mergedThisRound = FALSE;
                }
            }
        }
    }
    //Check if win or lose condition is satisfied
   if(self.livecells == 1){
        if (self.lastvalue == 0) {
            [self win];
        }else{
            [self lose];
        }
    }
}

- (BOOL)indexValid:(NSInteger)x y:(NSInteger)y {//Check if position is valid
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

- (BOOL)indexValidAndUnoccupied:(NSInteger)x y:(NSInteger)y {//Check if position is occupied
    BOOL indexValid = [self indexValid:x y:y];
    if (!indexValid) {
        return FALSE;
    }
    //Flag of occupation
    BOOL unoccupied = [_gridArray[x][y] isEqual:_emptyCell];
    return unoccupied;
}

- (void)moveCell:(Cell *)cell fromIndex:(NSInteger)oldX oldY:(NSInteger)oldY newX:(NSInteger)newX newY:(NSInteger)newY {//Move Cell from old position to new position
    //Store the old & new position
    _gridArray[newX][newY] = _gridArray[oldX][oldY];
    _gridArray[oldX][oldY] = _emptyCell;
    CGPoint newPosition = [self positionForColumn:newX row:newY];
    //Add animation
    CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:0.3f position:newPosition];
    [cell runAction:moveTo];
}

- (CGPoint)positionForColumn:(NSInteger)column row:(NSInteger)row {
    NSInteger x = _cellInterval + column * (_cellInterval + _cellWidth);
    NSInteger y = _cellInterval + row * (_cellInterval + _cellWidth);
    return CGPointMake(x,y);
}

- (void)mergeCellAtIndex:(NSInteger)x y:(NSInteger)y withCellAtIndex:(NSInteger)xOtherCell y:(NSInteger)yOtherCell {//Merge algorithm
    //Store two cells before merging
    Cell *mergedCell = _gridArray[x][y];
    Cell *otherCell = _gridArray[xOtherCell][yOtherCell];
    //Set new value as the difference
    otherCell.value = mergedCell.value - otherCell.value;
    otherCell.mergedThisRound = TRUE;
    _gridArray[x][y] = _emptyCell;
    //Decrease the number of livecell
    self.livecells--;
    //Record the lastvalue
    self.lastvalue = otherCell.value;
    
    //Set and run animation
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
    //Record winscore
    self.winscore = 0;
    //Init the num in Cell
    Cell *cell = (Cell*)[CCBReader load:@"Cell"];
    [cell setNum: -1];
    //Advance to the next level
    if (GRID_SIZE == 3) {
        GRID_SIZE = 4;
    }
    //Sound effect
    [self playSound:@"win" ofType:@"wav"];
    //End with message
    [self endGameWithMessage:@"You win!"];
}

- (void)lose {
    //Record lastscore
    self.winscore = self.lastvalue;
    //Init the num in Cell
    Cell *cell = (Cell*)[CCBReader load:@"Cell"];
    [cell setNum: -1];
    //Sound effect
    [self playSound:@"fail" ofType:@"mp3"];
    //End with message
    [self endGameWithMessage:@"You lose!"];
}

- (void)endGameWithMessage:(NSString*)message {//End with message
    GameEnd *gameEndPopover = (GameEnd *)[CCBReader load:@"GameEnd"];
    gameEndPopover.positionType = CCPositionTypeNormalized;
    gameEndPopover.position = ccp(0.5, 0.5);
    gameEndPopover.zOrder = INT_MAX;
    
    [gameEndPopover setMessage:message score:self.score with:self.lastvalue];
    
    [self addChild:gameEndPopover];
    
    NSNumber *highScore = [[NSUserDefaults standardUserDefaults] objectForKey:@"highscore"];
    if (self.winscore < [highScore intValue]) {
        // new highscore!
        highScore = [NSNumber numberWithInt:self.winscore];
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

-(void)playSound:(NSString*)sound ofType:(NSString*)soundType{//Sound Effect
    
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

-(void) iniTimer{//Init Timer
    
    self.n = TIME_LIM;
    self.second = TIME_LIM;
    
}

-(void)updateTimer:(NSTimer *)timer{//Update Timer
    self.second = self.second - 1;
    if(self.second < 0){
        [timer invalidate];
        [self lose];
    }
    self.timeleft = self.n;
    self.n = self.n - 1;
}


@end
