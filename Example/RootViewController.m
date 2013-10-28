//
//  RootViewController.m
//  TableViewPull
//
//  Created by Devin Doty on 10/16/09October16.
//  Copyright enormego 2009. All rights reserved.
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

#import "RootViewController.h"

@implementation RootViewController {
	
	NEETPullRefreshTableHeaderView *_refreshHeaderView;
	
    UILabel *_refreshStateLabel;
    
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes
	BOOL _reloading;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.toolbarHidden = NO;

    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.view addSubview:_tableView];
    }
    
	if (_refreshHeaderView == nil) {
		NEETPullRefreshTableHeaderView *view = [[NEETPullRefreshTableHeaderView alloc] initWithFrame:(CGRect){
            0.0f, 0.0f - self.view.bounds.size.height, self.view.frame.size.width, self.view.bounds.size.height }];
        
        view.contentView.backgroundColor = [UIColor redColor];
        
        view.layoutViewController = self;
        
        [view addTarget:self
                 action:@selector(refreshHeaderViewStateChanged:)
       forControlEvents:UIControlEventValueChanged];

		[self.tableView addSubview:view];
		_refreshHeaderView = view;
    }
    
    {
        // If you will customize its appearance more, you should create a subclass.
        
        _refreshStateLabel = [[UILabel alloc] initWithFrame:(CGRect){
            0, _refreshHeaderView.frame.size.height - 60, self.view.frame.size.width, 60 }];
        _refreshStateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _refreshStateLabel.backgroundColor = [UIColor clearColor];
        _refreshStateLabel.textAlignment = NSTextAlignmentCenter;
        _refreshStateLabel.textColor = [UIColor whiteColor];
        
        [_refreshHeaderView.contentView addSubview:_refreshStateLabel];

	}

    [self refreshHeaderViewStateChanged:_refreshHeaderView];
}

- (void)viewDidLayoutSubviews {
    
    [_refreshHeaderView scrollViewDidLayout:_tableView];
    
    [super viewDidLayoutSubviews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	// Configure the cell.
    
    cell.textLabel.text = [NSString stringWithFormat:@"Row %i in %i", indexPath.row, indexPath.section];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	
	return [NSString stringWithFormat:@"Section %i", section];
	
}

#pragma mark - Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource {
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData {
	
	//  model should call this when its done loading
	_reloading = NO;
    [_refreshHeaderView scrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark -  UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
	[_refreshHeaderView scrollViewDidScroll:scrollView];
		
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView scrollViewDidEndDragging:scrollView];
	
}

#pragma mark - Pull Refresh Table Header View Methods

- (void)refreshHeaderViewStateChanged:(id)sender {
    
    switch (_refreshHeaderView.pullRefreshState) {
        case kNEETPullRefreshNormal:
            _refreshStateLabel.text = NSLocalizedString(@"Pull to Refresh...", nil);
            break;
            
        case kNEETPullRefreshPulling:
            _refreshStateLabel.text = NSLocalizedString(@"Release to Refresh...", nil);
            break;
            
        case kNEETPullRefreshLoading:
            if (_reloading == NO) {
                _refreshStateLabel.text = NSLocalizedString(@"Loading...", nil);
                
                [self reloadTableViewDataSource];
                
                [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2];
                
            }
            break;
    }
}

@end

