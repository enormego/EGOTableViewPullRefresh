//
//  RootViewController.h
//  TableViewPull
//
//  Created by Devin Doty on 10/16/09October16.
//  Copyright enormego 2009. All rights reserved.
//
@class EGOTableViewPullRefresh;
@interface RootViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource>{
	EGOTableViewPullRefresh *egoTableView;
}

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
