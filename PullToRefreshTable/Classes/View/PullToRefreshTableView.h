//
//  PullToRefreshTableHeaderView.h
//
//  Based on EGORefreshTableHeaderView.h by Devin Doty on 10/14/09October14
//  Copyright 2009 enormego. All rights reserved.
// 
//  Modified and improved by Paul Chapman on 20/03/21.
//  Modifications copyright (c) 2012 Moneytree. All rights reserved.
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
	PullToRefreshTableStatePulling = 0,
	PullToRefreshTableStateNormal,
	PullToRefreshTableStateLoading,	
} kPullToRefreshTableState;

@protocol PullToRefreshTableDelegate;
@interface PullToRefreshTableView : UIView 
{
	kPullToRefreshTableState _state;
}

/** public label properties */
@property(nonatomic,strong) UIColor *arrowColor;
@property(nonatomic,strong) NSString *arrowImageName;
@property(nonatomic,strong) UIColor *textColor;
@property(nonatomic,strong) UIColor *shadowColor;
@property(nonatomic) CGSize shadowOffset;
@property(nonatomic) CGFloat animationDuration;

@property (nonatomic,assign) id <PullToRefreshTableDelegate> delegate;

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)aTextColor;
- (void)refreshLastUpdatedDate;
- (void)pullToRefreshTableScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)pullToRefreshTableScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)pullToRefreshTableScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
@end

@protocol PullToRefreshTableDelegate <NSObject>
- (void)pullToRefreshTableHeaderDidTriggerRefresh:(PullToRefreshTableView*)view;
- (BOOL)pullToRefreshTableHeaderDataSourceIsLoading:(PullToRefreshTableView*)view;
@optional
- (NSDate*)pullToRefreshTableHeaderDataSourceLastUpdated:(PullToRefreshTableView*)view;
@end
