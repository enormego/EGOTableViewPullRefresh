//
//  NEETRefreshTableHeaderView.h
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

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	NEETPullRefreshPulling = 0,
	NEETPullRefreshNormal,
	NEETPullRefreshLoading,	
} NEETPullRefreshState;

@protocol NEETRefreshTableHeaderDelegate;

@interface NEETRefreshTableHeaderView : UIView {
	
	NEETPullRefreshState _state;

	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
    CGFloat _topLayoutOffset;
}

@property(nonatomic,weak) id <NEETRefreshTableHeaderDelegate, NSObject> delegate;

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor;

- (void)refreshLastUpdatedDate;
- (void)neetRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)neetRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)neetRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

- (void)setTopLayoutOffset:(CGFloat)topLayoutOffset scrollView:(UIScrollView *)scrollView;

@end
@protocol NEETRefreshTableHeaderDelegate
- (void)neetRefreshTableHeaderDidTriggerRefresh:(NEETRefreshTableHeaderView*)view;
- (BOOL)neetRefreshTableHeaderDataSourceIsLoading:(NEETRefreshTableHeaderView*)view;
@optional
- (NSDate*)neetRefreshTableHeaderDataSourceLastUpdated:(NEETRefreshTableHeaderView*)view;
@end
