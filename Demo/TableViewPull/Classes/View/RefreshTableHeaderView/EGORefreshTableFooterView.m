//
//  EGORefreshTableFooterView.m
//  Demo
//
//  Created by Zbigniew Kominek on 3/10/11.
//  Copyright 2011 Zbigniew Kominek. All rights reserved.
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

#import "EGORefreshTableFooterView.h"


@implementation EGORefreshTableFooterView

- (void)setup:(CGRect)frame {
    _lastUpdatedLabelFrame = CGRectMake(0.0f, 10.0f, self.frame.size.width, 20.0f);
    _statusLabelFrame      = CGRectMake(0.0f, 28.0f, self.frame.size.width, 20.0f);
    _arrowImageFrame       = CGRectMake(25.0f, 10.0f, 30.0f, 55.0f);
    _activityViewFrame     = CGRectMake(25.0f, 18.0f, 20.0f, 20.0f);
    
    _arrowPullingTransform = CATransform3DMakeRotation((M_PI / 180.0f) * -360.0f, 0.0f, 0.0f, 1.0f);
    _arrowNormalTransform  = CATransform3DMakeRotation((M_PI / 180.0f) *  180.0f, 0.0f, 0.0f, 1.0f);
    
    _releaseLabelText = NSLocalizedString(@"Release to refresh...", @"Release to refresh status");
    _pullingLabelText = NSLocalizedString(@"Pull up to refresh...", @"Pull down to refresh status");
    _loadingLabelText = NSLocalizedString(@"Loading...", @"Loading Status");
    
    _userDefaultsKey = @"EGORefreshTableFooterView_LastRefresh";
}

@end
