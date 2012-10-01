//
//  CCScrollLayer.m
//  CCLevelScrollViewDemo
//
//  Copyright 2012 Thongchai Kolyutsakul.
//  Created by Thongchai on 3/12/12.
//
//  Modified version of CCScrollLayer of Giv Parvaneh, Stepan Generalov.
//  See README for changes.
//
//  -------
//
//  Copyright 2010 DK101
//  http://dk101.net/2010/11/30/implementing-page-scrolling-in-cocos2d/
//
//  Copyright 2010 Giv Parvaneh.
//  http://www.givp.org/blog/2010/12/30/scrolling-menus-in-cocos2d/
//
//  Copyright 2011 Stepan Generalov
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

#ifndef __MAC_OS_X_VERSION_MAX_ALLOWED

#import "CCScrollLayer.h"
#import "CCGL.h"

enum 
{
	kCCScrollLayerStateIdle,
	kCCScrollLayerStateSliding,
};

@interface CCTouchDispatcher (targetedHandlersGetter)

- (NSMutableArray *) targetedHandlers;

@end

@implementation CCTouchDispatcher (targetedHandlersGetter)

- (NSMutableArray *) targetedHandlers
{
	return targetedHandlers;
}

@end


@implementation CCScrollLayer

@synthesize minimumTouchLengthToSlide = minimumTouchLengthToSlide_;
@synthesize minimumTouchLengthToChangePage = minimumTouchLengthToChangePage_;
@synthesize totalScreens = totalScreens_;
@synthesize currentScreen = currentScreen_;
@synthesize showPagesIndicator = showPagesIndicator_;

@synthesize delegate;

+(id) nodeWithLayers:(NSArray *)layers widthOffset: (int) widthOffset
{
	return [[[self alloc] initWithLayers: layers widthOffset:widthOffset leftOffset:0 bottomOffset:0] autorelease];
}
-(id) initWithLayers:(NSArray *)layers widthOffset: (int) widthOffset {
    return [[self initWithLayers: layers widthOffset:widthOffset leftOffset:0 bottomOffset:0] autorelease];
}
-(id) initWithLayers:(NSArray *)layers widthOffset:(int)widthOffset leftOffset:(int)leftOffset bottomOffset:(int)bottomOffset
{
	if ( (self = [super init]) )
	{
		NSAssert([layers count], @"CCScrollLayer#initWithLayers:widthOffset: you must provide at least one layer!");
		
		// Enable touches.
		self.isTouchEnabled = YES;
		
		// Set default minimum touch length to scroll.
		self.minimumTouchLengthToSlide = 20.0f;
		self.minimumTouchLengthToChangePage = 50.0f;
		
		// Show indicator by default.
		self.showPagesIndicator = YES;
		
		// Set up the starting variables
		currentScreen_ = 1;
		
		// offset added to show preview of next/previous screens
		scrollWidth_ = [[CCDirector sharedDirector] winSize].width - widthOffset;
        
		// Loop through the array and add the screens
		int i = 0;
		for (CCLayer *l in layers)
		{
			l.anchorPoint = ccp(0,0);
			l.position = ccp((i*scrollWidth_) + leftOffset, bottomOffset);
			[self addChild:l];
			i++;
		}
		
		// Setup a count of the available screens
		totalScreens_ = [layers count];

        // page dots
        CGFloat d = 22.0f * CC_CONTENT_SCALE_FACTOR(); //< Distance between points.
        CGSize dotSize = CGSizeMake(8, 8);

		CGFloat n = (CGFloat)totalScreens_; //< Total points count in CGFloat.
		//CGFloat pY = ceilf ( self.contentSize.height / 20.0f ); //< Points y-coord in parent coord sys.

        overlayLayer = [[CCLayerColor alloc] initWithColor:ccc4(0, 0, 0, 0) width:self.contentSize.width height:10];
        overlayLayer.position = ccp(0, 15);
        overlayLayer.anchorPoint = ccp(0, 0);
        [self addChild:overlayLayer];
        
        pageDots = [[NSMutableArray alloc] initWithCapacity:totalScreens_];
		for (int i=0; i < totalScreens_; ++i)
		{
			CGFloat pX = 0.5f * self.contentSize.width + d * ( (CGFloat)i - 0.5f*(n-1.0f) );
            
            CCSprite *dot = [CCSprite spriteWithFile:@"pagedot.png"];
            dot.size = dotSize;
            dot.position = ccp(pX, 5);
            [overlayLayer addChild:dot];
            [pageDots addObject:dot];
		}
        
        // Arrows
        leftArrow = [CCMenuItemImage itemWithNormalImage:@"leftArrow.png" selectedImage:@"leftArrow.png" block:^(id sender) {
            [self moveToLeftPage];
            isAnimatingMove = YES;
        }];
        rightArrow = [CCMenuItemImage itemWithNormalImage:@"rightArrow.png" selectedImage:@"rightArrow.png" block:^(id sender) {
            [self moveToRightPage];
            isAnimatingMove = YES;
        }];
        CGSize arrowSize = CGSize_iPhone(40, 40); // Arrow Size
        leftArrow.size  = arrowSize;
        rightArrow.size = arrowSize;
        
        arrowMenu = [CCMenu menuWithItems:leftArrow, rightArrow, nil];
        [arrowMenu alignItemsHorizontallyWithPadding:pointX_iPhone(230.0f)];
        arrowMenu.position = CGPoint_iPhone(160, 100); // Arrow Position
        [overlayLayer addChild:arrowMenu];

        isAnimatingMove = NO;
	}
	return self;
}

#pragma mark CCLayer Methods ReImpl

// Register with more priority than CCMenu's but don't swallow touches
-(void) registerWithTouchDispatcher
{	
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:kCCMenuHandlerPriority - 1 swallowsTouches:NO];
}

// move dotLayer as scroll moves
-(void)draw{
    overlayLayer.position = ccp(-self.position.x, overlayLayer.position.y);
}

#pragma mark Pages Control 
-(void)doNotifyDelegateDidMove {
    if ([self.delegate respondsToSelector:@selector(CCScrollLayer:didMoveToPage:)]) {
        [self.delegate CCScrollLayer:self didMoveToPage:currentScreen_];
    }
    isAnimatingMove = NO;
}
-(void) moveToPage:(int)page
{
    // avoid rapid moving to the same page
    if (isAnimatingMove) return;
    
    page = MAX(1, page); // floor filter
    page = MIN(totalScreens_, page); // floor ceil
    
    if ([self.delegate respondsToSelector:@selector(CCScrollLayer:willMoveToPage:)]) {
        [self.delegate CCScrollLayer:self willMoveToPage:page];
    }
    
  	currentScreen_ = page;

    id changePage = [CCEaseSineOut actionWithAction:[CCMoveTo actionWithDuration:0.3 position:ccp(-((page-1)*scrollWidth_) , 0)] ]; // smoother
	[self runAction:[CCSequence actions:changePage, 
                     [CCCallFunc actionWithTarget:self selector:@selector(doNotifyDelegateDidMove)],
                     nil]];
    
    if (self.showPagesIndicator) {
        for (int i = 1; i <= totalScreens_ ; i++) {
            CCSprite *dot = [pageDots objectAtIndex:i-1];
            dot.opacity = (i == currentScreen_) ? 255 : 100 ;
        }
    }
    
    leftArrow.visible  = !(currentScreen_ == 1);
    rightArrow.visible = !(currentScreen_ == totalScreens_);

}
-(void) moveToLeftPage {
    [self moveToPage:currentScreen_-1 ];
}
-(void) moveToRightPage {
    [self moveToPage:currentScreen_+1 ];
}

#pragma mark Hackish Stuff

- (void) claimTouch: (UITouch *) aTouch
{
	// Enumerate through all targeted handlers.
	for ( CCTargetedTouchHandler *handler in [[[CCDirector sharedDirector] touchDispatcher] targetedHandlers] )
	{
		// Only our handler should claim the touch.
		if (handler.delegate == self)
		{
			if (![handler.claimedTouches containsObject: aTouch])
			{
				[handler.claimedTouches addObject: aTouch];
			}
			else 
			{
				CCLOGERROR(@"CCScrollLayer#claimTouch: %@ is already claimed!", aTouch);
			}
			return;
		}
	}
}

- (void) cancelAndStoleTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	// Throw Cancel message for everybody in TouchDispatcher.
	[[[CCDirector sharedDirector] touchDispatcher] touchesCancelled: [NSSet setWithObject: touch] withEvent:event];
	
	//< after doing this touch is already removed from all targeted handlers
	
	// Squirrel away the touch
	[self claimTouch: touch];
}

#pragma mark Touches 

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
	
	startSwipe_ = touchPoint.x;
	state_ = kCCScrollLayerStateIdle;
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
	CGFloat xDiff = touchPoint.x-startSwipe_;
	
	// If finger is dragged for more distance then minimum - start sliding and cancel pressed buttons.
	// Of course only if we not already in sliding mode
	if ( (state_ != kCCScrollLayerStateSliding) 
		&& (fabsf(xDiff) >= self.minimumTouchLengthToSlide) )
	{
		state_ = kCCScrollLayerStateSliding;
		
		// Avoid jerk after state change.
		startSwipe_ = touchPoint.x;
		xDiff = 0;
        
		[self cancelAndStoleTouch: touch withEvent: event];		
	}
	
	if (state_ == kCCScrollLayerStateSliding) {
        
        // dampen make scrolling off edge pages more sticky
        dampen = 1.0f;
        if (currentScreen_ == 1) {
            if (xDiff >= 0) dampen = 0.5f;
        }
        else if (currentScreen_ == totalScreens_) {
            if (xDiff <= 0) dampen = 0.5f;
        }
        
		self.position = ccp((-(currentScreen_-1)*scrollWidth_)+( xDiff * dampen ) , 0);	
	}
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Check for touch with specific location
	CGPoint touchPoint = [touch locationInView:[touch view]];
    touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];

//    // Intercepts touch in arrow
//    for (CCNode *n in arrowMenu.children) {
//        CGPoint p = [arrowMenu convertToNodeSpace:touchPoint];
//        if (CGRectContainsPoint(n.boundingBox, p)) {
//            NSLog(@"arrowMenu");
//            return;
//        }
//    }
	
	int newX = touchPoint.x;	
	
	if ( (newX - startSwipe_) < -self.minimumTouchLengthToChangePage && (currentScreen_+1) <= totalScreens_ )
	{		
		[self moveToPage: currentScreen_+1];		
	}
	else if ( (newX - startSwipe_) > self.minimumTouchLengthToChangePage && (currentScreen_-1) > 0 )
	{		
		[self moveToPage: currentScreen_-1];		
	}
	else
	{		
		[self moveToPage:currentScreen_];	
	}	
}

@end

#endif
