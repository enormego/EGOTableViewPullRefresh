//
//  EGOTableViewPullRefresh.m
//  TableViewPull
//
//  Created by Devin Doty on 10/16/09October16.
//  Copyright 2009 enormego. All rights reserved.
//

//  Requires
//  NSDateHelper
//  QuartzCore.framework
//  

#import "EGOTableViewPullRefresh.h"
#import "EGORefreshTableHeaderView.h"

#define kReleaseToReloadStatus 0
#define kPullToReloadStatus 1
#define kLoadingStatus 2

@implementation EGOTableViewPullRefresh 

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
	if (self = [super initWithFrame:frame style:style]){
		refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, 320.0f, self.bounds.size.height)];
		refreshHeaderView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
		[self addSubview:refreshHeaderView];
		self.showsVerticalScrollIndicator = YES;
		[refreshHeaderView release];
	}
	return self;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	if (refreshHeaderView.isFlipped && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !reloading) {
		[refreshHeaderView flipImageAnimated:YES];
		[refreshHeaderView setStatus:kPullToReloadStatus];
	} else if (!refreshHeaderView.isFlipped && scrollView.contentOffset.y < -65.0f) {
		[refreshHeaderView flipImageAnimated:YES];
		[refreshHeaderView setStatus:kReleaseToReloadStatus];
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

	if (scrollView.contentOffset.y <= - 65.0f) {
		if([self.dataSource respondsToSelector:@selector(reloadTableViewDataSource)]){
			reloading = YES;
			[(id)self.dataSource reloadTableViewDataSource];
			[refreshHeaderView toggleActivityView];
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.2];
			self.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 40.0f, 0.0f);
			[UIView commitAnimations];
		}
	} 
}

- (void)dataSourceDidFinishLoadingNewData{
	reloading = NO;
	[refreshHeaderView flipImageAnimated:NO];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[self setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 40.0f, 0.0f)];
	[refreshHeaderView setStatus:kPullToReloadStatus];
	[refreshHeaderView toggleActivityView];
	[UIView commitAnimations];
	[refreshHeaderView setCurrentDate];
}

- (void)dealloc {
	refreshHeaderView = nil;
    [super dealloc];
}


@end
