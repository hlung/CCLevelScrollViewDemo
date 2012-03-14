//
//  LevelTile.h
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

@class LevelTile;

@protocol LevelTileDelegate <NSObject>

@optional
- (void)didSelectLevelTile:(LevelTile*)tile;

@end

@interface LevelTile : CCNode {
    CCSprite *levelTileSprite;
    CGSize size_;
    CCLabelTTF *monLabel;
    NSDictionary *userInfo_;
    __unsafe_unretained NSObject <LevelTileDelegate> *delegate ;
}

@property (nonatomic,readonly) CGSize size;
@property (nonatomic,strong) NSDictionary *userInfo;
@property (nonatomic,assign) NSObject <LevelTileDelegate> *delegate;

+(LevelTile*)tileWithInfo:(NSDictionary*)userInfo;

@end
