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
 
 ## How to use NEETPullRefreshTableHeaderView
 
 ### 1. Create header view
 
		NEETPullRefreshTableHeaderView *view = [[NEETPullRefreshTableHeaderView alloc] initWithFrame:(CGRect){
            0.0f, 0.0f - self.view.bounds.size.height, self.view.frame.size.width, self.view.bounds.size.height }];
        
        // Set view controller that has this header view.
        view.layoutViewController = self;
        
        // NEETPullRefreshTableHeaderView will send UIControlEventValueChanged event when changed pullRefreshState property.
        [view addTarget:self
                 action:@selector(refreshHeaderViewStateChanged:)
       forControlEvents:UIControlEventValueChanged];

		[self.tableView addSubview:view];
 
		_refreshHeaderView = view;
 
 ### 2. Call scroll view methods
 
 Call following methods in UIViewController and UIScrollViewDelegate methods, or communication handlers.
 
 - -scrollViewDidLayout: 
   Call in -[UIViewController viewDidLayoutSubviews:]
 
 - -scrollViewDidScroll:
   Call in -[UIScrollViewDelegate scrollViewDidScroll:]
 
 - -scrollViewDidEndDragging:
   Call in -[UIScrollViewDelegate scrollViewDidScroll:]
 
 - -scrollViewDidEndDragging:
   Call in -[UIScrollViewDelegate scrollViewDidEndDragging:willDecelerate:]
 
 - -scrollViewDataSourceDidFinishedLoading:
   Call when finished to loading

 
 ### 3. Handle pull to refresh
 
 When triggered refresh, pullRefreshState will become to kNEETPullRefreshLoading.
 
    - (void)refreshHeaderViewStateChanged:(id)sender {
        if (_refreshHeader.pullRefreshState == kNEETPullRefreshLoading) {
            // Start to load
        }
    }
 
 */
@interface NEETPullRefreshTableHeaderView : UIControl

@property (weak, nonatomic) UIViewController *layoutViewController;

@property (readonly, nonatomic) NEETPullRefreshState pullRefreshState;

@property (strong, nonatomic) UIView *contentView;


#pragma mark - Scroll View Methods

- (void)scrollViewDidLayout:(UIScrollView *)scrollView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView;

- (void)scrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;


#pragma mark - Customize in Subclass

- (void)willChangePullRefreshState:(NEETPullRefreshState)pullRefreshState;

@end
