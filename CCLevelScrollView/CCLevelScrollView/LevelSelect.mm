//
//  LevelSelect.m
//  CCLevelScrollViewDemo
//
//  Copyright 2012 Thongchai Kolyutsakul.
//  Created by Thongchai on 3/12/12.
//
//  Modified version of CCScrollLayer of Giv Parvaneh, Stepan Generalov.
//  See README for changes.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "LevelSelect.h"

#define scrollPageSize CGSize_iPhone(300, 400)
#define kBonusLevelNumber 0

@implementation LevelSelect

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	LevelSelect *layer = [LevelSelect node];
	[scene addChild: layer z:0];
	return scene;
}

- (CCLayerColor*)layerForPage:(int)page {
    CCLayerColor *pageLayer = nil;
    
    pageLayer = [CCLayerColor layerWithColor:ccc4(128, 200, 200, 128)];
    pageLayer.contentSize = scrollPageSize;

    // ------------
    // Levels
    // ------------
    int itemCount = 14;
    int col = 4, row = 4;   // row and col limit
    int paddingX = 70, paddingY = 70; // space from each tile centers
    int topPadding = 30;    // space from top
    BOOL forceCenterIfColNotFull = NO;
    
    int sidePadding = (pageLayer.contentSize.width - (paddingX * (col-1))) / 2; // space from left and right, auto-calculated
	for (int y = 0; y < row ; y++ )
	{
        // determine how many cols will there be in this row
        int colsInRow = col;
        int extraPaddingX = 0;
        itemCount = itemCount - col; // if last row is has less cols, itemCount will be negative
        if (itemCount < 0) { 
            colsInRow += itemCount;
            itemCount = 0;
            if (forceCenterIfColNotFull) extraPaddingX = (col - colsInRow) * paddingX / 2;
        }
        
        for (int x = 0; x < colsInRow ; x++ )
        {
            NSDictionary *tileInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInt:page], @"page", // [1-4]
                                      [NSNumber numberWithInt:y*col + x + 1], @"level", // [1-15]
                                      nil];
            LevelTile *tile = [LevelTile tileWithInfo:tileInfo];
            tile.delegate = self;
            tile.position = CGPointMake(sidePadding + self.position.x + (x * paddingX) + extraPaddingX, 
                                        pageLayer.contentSize.height - self.position.y - y * paddingY - topPadding);
            [pageLayer addChild:tile];
        }
        
        if (itemCount == 0) break;
	}

    
    return pageLayer;
}
-(id) init
{
	if( (self=[super init]) ) {
        
        CCLayerColor *bg = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)];
        [self addChild:bg];
        
        // top title
        stageNameLabel = [CCLabelTTF labelWithString:@"" fontName:@"Helvetica" fontSize:36]; // need to set first string to @""
        stageNameLabel.position = CGPoint_iPhone(160, 460);
        stageNameLabel.color = ccBLACK;
        [self addChild:stageNameLabel];
        
        // total star
        totalStarLabel = [CCLabelTTF labelWithString:@"Total : 0/140" fontName:@"Helvetica" fontSize:16]; // need to set first string to @""
        totalStarLabel.position = CGPoint_iPhone(160, 439);
        totalStarLabel.color = ccBLACK;
        [self addChild:totalStarLabel];
        
        // now create the scroller and pass-in the pages (set widthOffset to 0 for fullscreen pages)
        scroller = [[CCScrollLayer alloc] initWithLayers:[NSMutableArray arrayWithObjects:
                                                          [self layerForPage:1],
                                                          [self layerForPage:2],
                                                          [self layerForPage:3],
                                                          [self layerForPage:4], nil] 
                                             widthOffset:15 leftOffset:10 bottomOffset:30];
        scroller.contentSize = scrollPageSize;
        scroller.isTouchEnabled = YES;
        scroller.delegate = self;
        [scroller moveToPage:1];
        [self addChild:scroller];
    }
	return self;
}

#pragma mark CCScrollLayerDelegate

-(void)CCScrollLayer:(CCScrollLayer *)layer willMoveToPage:(int)page {
    
    switch (page) {
        case 1:
            stageNameLabel.string = @"STAGE 1";
            break;
        case 2:
            stageNameLabel.string = @"STAGE 2";
            break;
        case 3:
            stageNameLabel.string = @"STAGE 3";
            break;
        case 4:
            stageNameLabel.string = @"STAGE 4";
            break;
        default:
            break;
    }

}

#pragma mark LevelTileDelegate

- (void)didSelectLevelTile:(LevelTile*)tile {
    NSDictionary *tileInfo = tile.userInfo;
    int page = [[tileInfo objectForKey:@"page"] intValue];
    int level = [[tileInfo objectForKey:@"level"] intValue];
    NSLog(@"select page:%d level:%d", page, level);
}

@end
