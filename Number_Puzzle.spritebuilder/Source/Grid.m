//
//  Grid.m
//  Number_Puzzle
//
//  Created by Wang Baiyang on 3/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Cell.h"

@implementation Grid{
    
    //Store the size information of Grid
    CGFloat _cellWidth;
    CGFloat _cellInterval;
    //Store the cell using index of Grid
    NSMutableArray *_gridArray;
    NSNull *_emptyCell;
}

static const NSInteger GRID_SIZE = 5;
static const NSInteger INIT_CELL = 5;

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
    [self initRandomCell];
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
            CCNodeColor *defaultNode = [CCNodeColor nodeWithColor:[CCColor cyanColor]];
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
    [cell runAction:sequence];
    
}

-(void) initRandomCell{
    
    for(int i = 0; i < INIT_CELL; i++){
        NSInteger randomRow = arc4random() % GRID_SIZE;
        NSInteger randomColumn = arc4random() % GRID_SIZE;
        NSLog(@"DDDDDDDD%ld, %ld", (long)randomColumn, (long)randomRow);
        //Check if it is occupied
        BOOL initSuccess = false;
        while(!initSuccess){
            if (_gridArray[randomColumn][randomRow] == _emptyCell){
                [self addCellAtColunm:randomColumn Row: randomRow];
                initSuccess = true;
            }
        }
    }
}


@end
