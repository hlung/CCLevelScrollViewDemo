//
//  CCNode+helper.m
//  CCLevelScrollViewDemo
//
//  Copyright 2012 Thongchai Kolyutsakul.
//  Created by Thongchai on 3/12/12.
//

#import "CCNode+helper.h"

@implementation CCNode (helper)

@dynamic size;

// Set size of CCNode classes (CCSprite, CCMenuItem classes, etc.) by using CGSize instead of scaleX, scaleY.
// Ref: http://stackoverflow.com/questions/4075449/how-do-i-create-a-ccsprite-to-set-bounds
-(void)setSize:(CGSize)theSize {
    CGFloat newWidth = theSize.width;
    CGFloat newHeight = theSize.height;
    
    float startWidth = self.contentSize.width;
    float startHeight = self.contentSize.height;
    
    float newScaleX = newWidth/startWidth;
    float newScaleY = newHeight/startHeight;
    
    self.scaleX = newScaleX;
    self.scaleY = newScaleY;
}

- (CGSize)size {
    return CGSizeMake(self.contentSize.width * self.scaleX, self.contentSize.height * self.scaleY);
}

@end



@implementation CCDirector (popScene)

// Allow popping scene with transition.
// Usage: [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionSplitCols class] duration:1];
// Ref: http://www.cocos2d-iphone.org/forum/topic/1076
-(void) popSceneWithTransition: (Class)transitionClass duration:(ccTime)t;
{
	NSAssert( runningScene_ != nil, @"A running Scene is needed");
    
	[scenesStack_ removeLastObject];
	NSUInteger c = [scenesStack_ count];
	if( c == 0 ) {
		[self end];
	} else {
		CCScene* scene = [transitionClass transitionWithDuration:t scene:[scenesStack_ objectAtIndex:c-1]];
		[scenesStack_ replaceObjectAtIndex:c-1 withObject:scene];
		nextScene_ = scene;
	}
}

@end