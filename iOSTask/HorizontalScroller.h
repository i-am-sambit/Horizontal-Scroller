//
//  HorizontalScroller.h
//  HashtagUsersTwitter
//
//  Created by GLB-311-PC on 23/11/17.
//  Copyright © 2017 Globussoft. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@protocol HorizontalScrollerDelegate;
@interface HorizontalScroller : UIView

@property (weak, nonatomic) id <HorizontalScrollerDelegate> delegate;
@property (assign) int questionIndex;

- (void) reload;

@end

@protocol HorizontalScrollerDelegate <NSObject>

@required

- (NSInteger)numberOfViewsForHorizontalScroller:(HorizontalScroller *)scroller;
- (CGSize) contentSizeForView:(HorizontalScroller *)scroller;
- (UIView*)horizontalScroller:(HorizontalScroller *)scroller viewAtIndex:(int)index;

- (void)horizontalScroller:(HorizontalScroller*)scroller clickedViewAtIndex:(int)index;

@optional
- (NSInteger)initialViewIndexForHorizontalScroller:(HorizontalScroller*)scroller;

@end
