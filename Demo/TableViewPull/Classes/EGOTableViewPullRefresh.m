//
//  EGOTableViewPullRefresh.m
//  TableViewPull
//
//  Created by Devin Doty on 10/16/09October16.
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
	
	if (scrollView.isDragging) {
		if (refreshHeaderView.isFlipped && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !reloading) {
			[refreshHeaderView flipImageAnimated:YES];
			[refreshHeaderView setStatus:kPullToReloadStatus];
		} else if (!refreshHeaderView.isFlipped && scrollView.contentOffset.y < -65.0f && !reloading) {
			[refreshHeaderView flipImageAnimated:YES];
			[refreshHeaderView setStatus:kReleaseToReloadStatus];
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	if (scrollView.contentOffset.y <= - 65.0f && !reloading) {
		if([self.dataSource respondsToSelector:@selector(reloadTableViewDataSource)]){
			reloading = YES;
			[(id)self.dataSource reloadTableViewDataSource];
			[refreshHeaderView toggleActivityView];
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.2];
			self.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
			[UIView commitAnimations];
		}
	}
}

- (void)dataSourceDidFinishLoadingNewData{
	
	reloading = NO;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[self setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[refreshHeaderView flipImageAnimated:NO]; //  reset view
	[refreshHeaderView toggleActivityView];	//  reset view
	[refreshHeaderView setCurrentDate];  //  should check if data reload was successful 
}

- (void)dealloc {
	refreshHeaderView = nil;
    [super dealloc];
}


@end
