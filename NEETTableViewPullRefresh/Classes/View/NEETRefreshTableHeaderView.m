//
//  NEETRefreshTableHeaderView.m
//  NEETRefreshTableHeaderView
//
//  Modified by mtmta on 2013/10/27.
//  Copyright (c) 2013年 The Neet House. All rights reserved.
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
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
//

#import "NEETRefreshTableHeaderView.h"


#define HEADER_HEIGHT 60.0f
#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

static UIEdgeInsets NEETUIEdgeInsetsSetTop(UIEdgeInsets baseInsets, CGFloat topInset) {
    baseInsets.top = topInset;
    return baseInsets;
}


@interface NEETRefreshTableHeaderView (Private)
- (void)setState:(NEETPullRefreshState)aState;
@end

@implementation NEETRefreshTableHeaderView

@synthesize delegate=_delegate;


- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    if((self = [super initWithFrame:frame])) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];

		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		
        self.alpha = 0;
		
		[self setState:NEETPullRefreshNormal];
		
    }
	
    return self;
	
}

- (id)initWithFrame:(CGRect)frame  {
  return [self initWithFrame:frame arrowImageName:@"blueArrow.png" textColor:TEXT_COLOR];
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
	if ([_delegate respondsToSelector:@selector(neetRefreshTableHeaderDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate neetRefreshTableHeaderDataSourceLastUpdated:self];
		
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];

		_lastUpdatedLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [dateFormatter stringFromDate:date]];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}

}

- (void)setState:(NEETPullRefreshState)aState{
	
	switch (aState) {
		case NEETPullRefreshPulling:
			
			_statusLabel.text = NSLocalizedString(@"Release to refresh...", @"Release to refresh status");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case NEETPullRefreshNormal:
			
			if (_state == NEETPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = NSLocalizedString(@"Pull down to refresh...", @"Pull down to refresh status");
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case NEETPullRefreshLoading:
			
			_statusLabel.text = NSLocalizedString(@"Loading...", @"Loading Status");
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)neetRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
	
	if (_state == NEETPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, HEADER_HEIGHT);
		scrollView.contentInset = NEETUIEdgeInsetsSetTop(scrollView.contentInset, offset + _topLayoutOffset);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(neetRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate neetRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == NEETPullRefreshPulling
            && -self.triggeredOffset < scrollView.contentOffset.y && scrollView.contentOffset.y < -_topLayoutOffset
            && !_loading) {
			[self setState:NEETPullRefreshNormal];
            
		} else if (_state == NEETPullRefreshNormal && scrollView.contentOffset.y < -self.triggeredOffset && !_loading) {
			[self setState:NEETPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != _topLayoutOffset) {
			scrollView.contentInset = NEETUIEdgeInsetsSetTop(scrollView.contentInset, _topLayoutOffset);
		}
		
	}
	
    [self updateTransparencyWithScrollView:scrollView];
}

- (void)neetRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {

	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(neetRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate neetRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - self.triggeredOffset && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(neetRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate neetRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:NEETPullRefreshLoading];

        [UIView animateWithDuration:0.2 animations:^{
            scrollView.contentInset = NEETUIEdgeInsetsSetTop(scrollView.contentInset, HEADER_HEIGHT + _topLayoutOffset);
        }];
		
	}
	
}

- (void)neetRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	

    [self setState:NEETPullRefreshNormal];

    [UIView animateWithDuration:0.3 animations:^{
        scrollView.contentInset = NEETUIEdgeInsetsSetTop(scrollView.contentInset, _topLayoutOffset);
    }];
}


#pragma mark -
#pragma mark Visibility

- (void)updateTransparencyWithScrollView:(UIScrollView *)scrollView {
    
    CGFloat visibleHeight =  - scrollView.contentOffset.y - _topLayoutOffset;
    CGFloat alpha = 0;
    
    if (0 < visibleHeight) {
        // visible
        // alpha becomes 1.0 when visibleHeight equals 10 points
        alpha = visibleHeight / 10.0f;
        alpha = MIN(alpha, 1.0f);
    }
    
    if (self.alpha != alpha) {
        [UIView animateWithDuration:0.01 animations:^{
            self.alpha = alpha;
        }];
    }
}

#pragma mark -
#pragma mark Layout

- (CGFloat)triggeredOffset {
    return _topLayoutOffset + 65.0f;
}

- (void)setTopLayoutOffset:(CGFloat)topLayoutOffset scrollView:(UIScrollView *)scrollView {
    _topLayoutOffset = topLayoutOffset;
    
    [self updateTransparencyWithScrollView:scrollView];
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
}


@end
