//
//  NEETPullRefreshTableHeaderView.h
//  NEETTableViewPullRefreshDemo
//
//  Created by daichi on 2013/10/27.
//  Copyright (c) 2013年 The Neet House. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	kNEETPullRefreshPulling = 0,
	kNEETPullRefreshNormal,
	kNEETPullRefreshLoading,
} NEETPullRefreshState;

/**
 
 It will send UIControlEventValueChanged event when changed pullRefreshState property.
 
 */
@interface NEETPullRefreshTableHeaderView : UIControl

@property (readonly, nonatomic) NEETPullRefreshState pullRefreshState;

@property (strong, nonatomic) UIView *contentView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView;

- (void)scrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

- (void)scrollView:(UIScrollView *)scrollView didLayoutWithTopInset:(CGFloat)topInset;


#pragma mark - Customize in Subclass

- (void)willChangePullRefreshState:(NEETPullRefreshState)pullRefreshState;

@end
