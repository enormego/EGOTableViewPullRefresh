//
//  EGOTableViewPullRefresh.h
//  TableViewPull
//
//  Created by Devin Doty on 10/16/09October16.
//  Copyright 2009 enormego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class EGORefreshTableHeaderView;

@interface EGOTableViewPullRefresh : UITableView <UITableViewDelegate>{
	
	EGORefreshTableHeaderView *refreshHeaderView;
	BOOL reloading;
}
- (void)dataSourceDidFinishLoadingNewData;
@end

@protocol UITableViewReloadDataSource
- (void)reloadTableViewDataSource;
@end


