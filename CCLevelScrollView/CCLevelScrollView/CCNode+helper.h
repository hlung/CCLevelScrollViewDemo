//
//  CCNode+helper.h
//  CCLevelScrollViewDemo
//
//  Copyright 2012 Thongchai Kolyutsakul.
//  Created by Thongchai on 3/12/12.
//

#import "CCNode.h"

@interface CCNode (helper)

@property (nonatomic) CGSize size;
- (void)setSize:(CGSize)theSize;
- (CGSize)size;
@end

@interface CCDirector (popScene)

- (void) popSceneWithTransition: (Class)c duration:(ccTime)t;

@end
