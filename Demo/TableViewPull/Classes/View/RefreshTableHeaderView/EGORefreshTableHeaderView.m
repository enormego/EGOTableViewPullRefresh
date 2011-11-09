//
//  EGORefreshTableHeaderView.m
//  Demo
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

#import "EGORefreshTableHeaderView.h"


#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define BORDER_COLOR [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

@implementation EGORefreshTableHeaderView

@synthesize state=_state;
@synthesize releaseLabelText=_releaseLabelText;
@synthesize pullingLabelText=_pullingLabelText;
@synthesize loadingLabelText=_loadingLabelText;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		
        [self setup:frame];
        
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
		UILabel *label = [[UILabel alloc] initWithFrame:_lastUpdatedLabelFrame];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		[label release];

		if ([[NSUserDefaults standardUserDefaults] objectForKey:_userDefaultsKey]) {
			_lastUpdatedLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:_userDefaultsKey];
		} else {
			[self setCurrentDate];
		}
		
		label = [[UILabel alloc] initWithFrame:_statusLabelFrame];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
		
		CALayer *layer = [[CALayer alloc] init];
		layer.frame = _arrowImageFrame;
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"blueArrow.png"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		[layer release];
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = _activityViewFrame;
		[self addSubview:view];
		_activityView = view;
		[view release];
		
		[self setState:EGOOPullRefreshNormal];
		
    }
    return self;
}

- (void)setCurrentDate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setAMSymbol:@"AM"];
	[formatter setPMSymbol:@"PM"];
	[formatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
	_lastUpdatedLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [formatter stringFromDate:[NSDate date]]];
	[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:_userDefaultsKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[formatter release];
}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
			
			_statusLabel.text = _releaseLabelText;
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = _arrowPullingTransform;
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshNormal:
			
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = _pullingLabelText;
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = _arrowNormalTransform;
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshLoading:
			
			_statusLabel.text = _loadingLabelText;
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}

- (void)setup:(CGRect)frame {
    _lastUpdatedLabelFrame = CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f);
    _statusLabelFrame      = CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f);
    _arrowImageFrame       = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
    _activityViewFrame     = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
    
    _arrowPullingTransform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
    _arrowNormalTransform  = CATransform3DIdentity;
    
    _releaseLabelText = NSLocalizedString(@"Release to refresh...", @"Release to refresh status");
    _pullingLabelText = NSLocalizedString(@"Pull down to refresh...", @"Pull down to refresh status");
    _loadingLabelText = NSLocalizedString(@"Loading...", @"Loading Status");
    
    _userDefaultsKey = @"EGORefreshTableHeaderView_LastRefresh";
}

- (void)dealloc {
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    [super dealloc];
}


@end
