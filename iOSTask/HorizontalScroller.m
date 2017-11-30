//
//  HorizontalScroller.m
//  HashtagUsersTwitter
//
//  Created by GLB-311-PC on 23/11/17.
//  Copyright © 2017 Globussoft. All rights reserved.
//

#import "HorizontalScroller.h"

#define VIEW_PADDING 0
#define VIEW_DIMENSIONS_WIDTH 150
#define VIEW_DIMENSIONS_HEIGHT 60
#define VIEWS_OFFSET 0

IB_DESIGNABLE
@interface HorizontalScroller () <UIScrollViewDelegate>
@end

@implementation HorizontalScroller {
    
    CGSize viewRect;
    
    UIScrollView *scroller;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addObserver:self forKeyPath:@"questionIndex" options:NSKeyValueObservingOptionNew context:nil];
        
        scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scroller.delegate = self;
        scroller.showsHorizontalScrollIndicator = false;
        scroller.scrollEnabled = false;
        [self addSubview:scroller];
    }
    return self;
}

- (void) dealloc {
    
    [self removeObserver:self forKeyPath:@"questionIndex"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"questionIndex"]) {
        NSLog(@"Hey there!!! : %@", [change objectForKey:@"new"]);
        
        [scroller setContentOffset:CGPointMake(([[change objectForKey:@"new"] intValue] * scroller.frame.size.width), 0) animated:YES];
    }
}

- (void)didMoveToSuperview {
    [self reload];
}

- (void)scrollerTapped:(UITapGestureRecognizer*)gesture {
    
    CGPoint location = [gesture locationInView:gesture.view];
    for (int index=0; index<[self.delegate numberOfViewsForHorizontalScroller:self]; index++)
    {
        UIView *view = scroller.subviews[index];
        if (CGRectContainsPoint(view.frame, location)) {
            [scroller setContentOffset:CGPointMake(view.frame.origin.x - self.frame.size.width/2 + view.frame.size.width/2, 0) animated:YES];
            break;
        }
    }
}

- (void)reload {
    
    if (self.delegate == nil) {
        return;
    }
    
    //remove all subviews
    [scroller.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    CGFloat xValue = VIEWS_OFFSET;
    viewRect = CGSizeMake(self.bounds.size.width, 40);
    if ([_delegate respondsToSelector:@selector(contentSizeForView:)]) {
        viewRect = [_delegate contentSizeForView:self];
    }
    
    for (int i=0; i<[self.delegate numberOfViewsForHorizontalScroller:self]; i++) {
        
        xValue += VIEW_PADDING;
        UIView *view = [self.delegate horizontalScroller:self viewAtIndex:i];
        view.frame = CGRectMake(xValue, VIEW_PADDING, viewRect.width, viewRect.height);
        [scroller addSubview:view];
        xValue += viewRect.width + VIEW_PADDING;
    }
    
    [scroller setContentSize:CGSizeMake(xValue+VIEWS_OFFSET, self.frame.size.height)];
}

- (void)centerCurrentView {
    int xFinal = scroller.contentOffset.x + (VIEWS_OFFSET/2) + VIEW_PADDING;
    int viewIndex = xFinal / (viewRect.width + (2*VIEW_PADDING));
    xFinal = viewIndex * (viewRect.width + (2*VIEW_PADDING));
    [scroller setContentOffset:CGPointMake(xFinal,0) animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self centerCurrentView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self centerCurrentView];
}

//- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    if (scrollView.contentOffset.x == 0) {
//        // user is scrolling to the left from image 1 to image 10.
//        // reposition offset to show image 10 that is on the right in the scroll view
//        [scrollView scrollRectToVisible:CGRectMake(600,0,150,480) animated:NO];
//    }
//    else if (scrollView.contentOffset.x == 125) {
//        // user is scrolling to the right from image 10 to image 1.
//        // reposition offset to show image 1 that is on the left in the scroll view
//        [scrollView scrollRectToVisible:CGRectMake(0,0,150,480) animated:NO];
//    }
//}

@end
