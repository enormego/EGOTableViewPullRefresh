//
//  NEETPullRefreshTableHeaderView.m
//  NEETTableViewPullRefreshDemo
//
//  Created by daichi on 2013/10/27.
//  Copyright (c) 2013年 The Neet House. All rights reserved.
//

#import "NEETPullRefreshTableHeaderView.h"

#define HEADER_HEIGHT 60.0f

static UIEdgeInsets NEETUIEdgeInsetsSetTop(UIEdgeInsets baseInsets, CGFloat topInset) {
    baseInsets.top = topInset;
    return baseInsets;
}

@implementation NEETPullRefreshTableHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
        { // Init contentView
            _contentView = [[UIView alloc] initWithFrame:self.bounds];
            _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            _contentView.backgroundColor = [UIColor clearColor];
            
            _contentView.alpha = 0;
            
            [self addSubview:_contentView];
        }
        
		[self setPullRefreshState:kNEETPullRefreshNormal];
    }
    return self;
}


#pragma mark - Setters

- (void)setPullRefreshState:(NEETPullRefreshState)pullRefreshState {
    
    if (_pullRefreshState != pullRefreshState) {
        [self willChangePullRefreshState:pullRefreshState];
        
        _pullRefreshState = pullRefreshState;
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)willChangePullRefreshState:(NEETPullRefreshState)pullRefreshState {
    
}


#pragma mark - ScrollView Methods

- (void)scrollViewDidLayout:(UIScrollView *)scrollView {
    [self updateTransparencyWithScrollView:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	if (_pullRefreshState == kNEETPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, HEADER_HEIGHT);
		scrollView.contentInset = NEETUIEdgeInsetsSetTop(scrollView.contentInset, offset + self.topLayoutOffset);
		
	} else if (scrollView.isDragging) {
		
		if (_pullRefreshState == kNEETPullRefreshPulling
            && -self.triggeredOffset < scrollView.contentOffset.y && scrollView.contentOffset.y < -self.topLayoutOffset) {
			[self setPullRefreshState:kNEETPullRefreshNormal];
            
		} else if (_pullRefreshState == kNEETPullRefreshNormal && scrollView.contentOffset.y < -self.triggeredOffset) {
			[self setPullRefreshState:kNEETPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != self.topLayoutOffset) {
			scrollView.contentInset = NEETUIEdgeInsetsSetTop(scrollView.contentInset, self.topLayoutOffset);
		}
	}
	
    [self updateTransparencyWithScrollView:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	if (scrollView.contentOffset.y <= - self.triggeredOffset && _pullRefreshState != kNEETPullRefreshLoading) {
        
		[self setPullRefreshState:kNEETPullRefreshLoading];
        
        [UIView animateWithDuration:0.2 animations:^{
            scrollView.contentInset = NEETUIEdgeInsetsSetTop(scrollView.contentInset, HEADER_HEIGHT + self.topLayoutOffset);
        }];
	}
	
}

- (void)scrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
    
    [self setPullRefreshState:kNEETPullRefreshNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
        scrollView.contentInset = NEETUIEdgeInsetsSetTop(scrollView.contentInset, self.topLayoutOffset);
    }];
}


#pragma mark - Visibility

- (void)updateTransparencyWithScrollView:(UIScrollView *)scrollView {
    
    CGFloat visibleHeight =  - scrollView.contentOffset.y - self.topLayoutOffset;
    CGFloat alpha = 0;
    
    if (0 < visibleHeight) {
        // visible
        // alpha becomes 1.0 when visibleHeight equals 10 points
        alpha = visibleHeight / 10.0f;
        alpha = MIN(alpha, 1.0f);
    }
    
    if (_contentView.alpha != alpha) {
        [UIView animateWithDuration:0.01 animations:^{
            _contentView.alpha = alpha;
        }];
    }
}

#pragma mark - Layout

- (CGFloat)triggeredOffset {
    return self.topLayoutOffset + 65.0f;
}

- (CGFloat)topLayoutOffset {
    if ([_layoutViewController respondsToSelector:@selector(topLayoutGuide)]) {
        return _layoutViewController.topLayoutGuide.length;
    }
    return 0;
}

@end
