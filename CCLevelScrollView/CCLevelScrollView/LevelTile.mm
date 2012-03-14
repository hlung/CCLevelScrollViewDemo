//
//  LevelTile.m
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

#import "LevelTile.h"

#define imgLevelTileBox @"levelTileBox.png"
#define imgStarOn @"starOn.png"
#define imgStarOff @"starOff.png"
#define kStarSize CGSize_iPhone(12,12)
#define kBonusStarSize CGSize_iPhone(18,18)

@interface LevelTile (pv)
- (void)initializeTile;
- (void)initializeBonusTile;
@end


@implementation LevelTile

@synthesize size = size_;
@synthesize userInfo = userInfo_;
@synthesize delegate;

// ------------
// Normal Tile
// ------------
+(LevelTile*)tileWithInfo:(NSDictionary*)userInfo
{
    LevelTile *tile = [[self alloc] init];
    tile.userInfo = userInfo;
    [tile initializeTile];
    return tile;
}
- (void)initializeTile {
    
    // ----------
    // input data
    int numStar = rand()%4; // num of stars on [0 - 3]
    
    int maxMonKilled = 10;
    int numMonKilled = rand()%11; // num of killed mon on [0 - 10]
    // ----------
    
    // initialize
    CCMenuItemImage *btn = [CCMenuItemImage itemWithNormalImage:imgLevelTileBox selectedImage:imgLevelTileBox block:^(id sender) {
        if( [delegate respondsToSelector:@selector(didSelectLevelTile:)] ) {
			[delegate didSelectLevelTile:self];
        }
    }];
    btn.size        = CGSize_iPhone(50, 50);
    CCMenu *menu    = [CCMenu menuWithItems:btn, nil];
    menu.position   = CGPointZero;
    [self addChild:menu];
    
    // monLabel
    monLabel = [CCLabelTTF labelWithString:@"" fontName:@"Helvetica" fontSize:14]; // need to set first string to @""
    monLabel.string = [NSString stringWithFormat:@"%d/%d", numMonKilled, maxMonKilled];
    monLabel.position = CGPoint_iPhone(0, -32);
    monLabel.color = ccBLACK;
    [self addChild:monLabel];
    
    // stars
    BOOL starsOn[3] = {NO, NO, NO};
    for (int i = 0; i < 3; i++) {
        if (i < numStar) starsOn[i] = YES;
    }
    CCSprite *star1 = [CCSprite spriteWithFile:starsOn[0] ? imgStarOn : imgStarOff];
    CCSprite *star2 = [CCSprite spriteWithFile:starsOn[1] ? imgStarOn : imgStarOff];
    CCSprite *star3 = [CCSprite spriteWithFile:starsOn[2] ? imgStarOn : imgStarOff];
    star1.size = kStarSize;
    star2.size = kStarSize;
    star3.size = kStarSize;
    star1.position = CGPoint_iPhone(-kStarSize.width, 0);
    star2.position = CGPoint_iPhone(               0, 0);
    star3.position = CGPoint_iPhone( kStarSize.width, 0);
    
    CCNode *starNode = [CCNode node];
    starNode.position = CGPoint_iPhone(0, -15);
    [starNode addChild:star1];
    [starNode addChild:star2];
    [starNode addChild:star3];
    [self addChild:starNode];
}


@end
