//
//  EGORefreshTableHeaderView.h
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EGORefreshTableHeaderView : UIView {
	
	UILabel *lastUpdatedLabel;
	UILabel *statusLabel;
	UIImageView *arrowImage;
	UIActivityIndicatorView *activityView;

	BOOL isFlipped;
}
@property BOOL isFlipped;

- (void)flipImageAnimated:(BOOL)animated;
- (void)setCurrentDate;
- (void)toggleActivityView;
- (void)setStatus:(int)status;

@end
