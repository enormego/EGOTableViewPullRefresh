//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09
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


#define FLIP_ANIMATION_DURATION 0.18f


@interface EGORefreshTableHeaderView(Private)

- (void)setState:(EGOPullRefreshState)aState;

@end


@implementation EGORefreshTableHeaderView

@synthesize activityView=_activityView;
@synthesize arrowImage=_arrowImage;
@synthesize defaultInsets=_defaultInsets;
@synthesize delegate=_delegate;
@synthesize lastUpdatedLabel=_lastUpdatedLabel;
@synthesize objectKey=_objectKey;
@synthesize statusLabel=_statusLabel;
@synthesize style=_style;

- (id)initWithFrame:(CGRect)frame 
     arrowImageName:(NSString *)arrow 
          textColor:(UIColor *)textColor
    backgroundColor:(UIColor *)backgroundColor
      activityStyle:(UIActivityIndicatorViewStyle)activityStyle
{
    if ((self = [super initWithFrame:frame]))
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = backgroundColor;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f,
                                                                   self.frame.size.width, 20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = textColor;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [self addSubview:label];
        self.lastUpdatedLabel = label;
        [label release];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f,
                                                          self.frame.size.width, 20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont boldSystemFontOfSize:13.0f];
        label.textColor = textColor;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [self addSubview:label];
        self.statusLabel = label;
        [label release];
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
        layer.contentsGravity = kCAGravityResizeAspect;
        layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        {
            layer.contentsScale = [[UIScreen mainScreen] scale];
        }
#endif
        
        [[self layer] addSublayer:layer];
        self.arrowImage = layer;
        
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:activityStyle];
        view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
        [self addSubview:view];
        self.activityView = view;
        [view release];
        
        [self setState:EGOOPullRefreshNormal];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame style:EGOStyleBlue];
}

- (id)initWithView:(UIView *)view tableView:(UITableView *)tableView
{
    CGRect defaultFrame = CGRectMake(0.0f, 0.0f - tableView.bounds.size.height,
                                     view.frame.size.width, tableView.bounds.size.height);
    return [self initWithFrame:defaultFrame];
}

- (id)initWithView:(UIView *)view tableView:(UITableView *)tableView style:(EGOStyle)style
{
    CGRect defaultFrame = CGRectMake(0.0f, 0.0f - tableView.bounds.size.height,
                                     view.frame.size.width, tableView.bounds.size.height);
    return [self initWithFrame:defaultFrame style:style];
}

- (id)initWithFrame:(CGRect)frame style:(EGOStyle)style
{
    UIColor *textColor;
    UIColor *backgroundColor;
    NSString *arrowImageName;
    UIActivityIndicatorViewStyle activityStyle;
    
    switch (style)
    {
        case EGOStyleBlack:
            backgroundColor = [UIColor blackColor];
            textColor = [UIColor whiteColor];
            arrowImageName = @"whiteArrow.png";
            activityStyle = UIActivityIndicatorViewStyleWhite;
            break;
            
        case EGOStyleWhite:
            backgroundColor = [UIColor whiteColor];
            textColor = [UIColor blackColor];
            arrowImageName = @"blackArrow.png";
            activityStyle = UIActivityIndicatorViewStyleGray;
            break;
            
        case EGOStyleGrey:
            backgroundColor = [UIColor whiteColor];
            textColor = [UIColor grayColor];
            arrowImageName = @"grayArrow.png";
            activityStyle = UIActivityIndicatorViewStyleGray;
            break;
            
        default:
            backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
            textColor = [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0];
            arrowImageName = @"blueArrow.png";
            activityStyle = UIActivityIndicatorViewStyleGray;
    }
    
    return [self initWithFrame:frame 
                arrowImageName:arrowImageName 
                     textColor:textColor 
               backgroundColor:backgroundColor 
                 activityStyle:activityStyle];
}


#pragma mark - Setters

- (void)refreshLastUpdatedDate
{
    if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)])
    {
        NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
        
        [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        NSString *lastUpdatedLabel = NSLocalizedString(@"Last Updated: ", @"Last Updated Label");
        _lastUpdatedLabel.text = [NSString stringWithFormat:@"%@%@", lastUpdatedLabel, 
                                  [dateFormatter stringFromDate:date]];
        
        NSString *forKey;
        if (self.objectKey)
        {
            forKey = [NSString stringWithFormat:@"EGORefreshTableView_LastRefresh_%@", self.objectKey];
        }
        else
        {
            forKey = @"EGORefreshTableView_LastRefresh";
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:forKey];
    }
    else
    {
        _lastUpdatedLabel.text = nil;
    }
}

- (void)setState:(EGOPullRefreshState)aState
{
    switch (aState)
    {
        case EGOOPullRefreshPulling:
            _statusLabel.text = NSLocalizedString(@"Release to refresh...", @"Release to refresh status");
            [CATransaction begin];
            [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            [CATransaction commit];
            break;
            
        case EGOOPullRefreshNormal:
            if (_state == EGOOPullRefreshPulling)
            {
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                _arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
            }
            _statusLabel.text = NSLocalizedString(@"Pull down to refresh...", @"Pull down to refresh status");
            [_activityView stopAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = NO;
            _arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];
            [self refreshLastUpdatedDate];
            break;
            
        case EGOOPullRefreshLoading:
            _statusLabel.text = NSLocalizedString(@"Loading...", @"Loading Status");
            [_activityView startAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = YES;
            [CATransaction commit];
            break;
    }
    
    _state = aState;
}


#pragma mark - ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_state == EGOOPullRefreshLoading)
    {
        CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
        offset = MIN(offset, 60);
        scrollView.contentInset = UIEdgeInsetsMake(offset,
                                                   self.defaultInsets.left,
                                                   self.defaultInsets.bottom,
                                                   self.defaultInsets.right);
    }
    else if (scrollView.isDragging)
    {
        BOOL _loading = NO;
        if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)])
        {
            _loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
        }
        
        if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f &&
            scrollView.contentOffset.y < 0.0f && !_loading)
        {
            [self setState:EGOOPullRefreshNormal];
        }
        else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading)
        {
            [self setState:EGOOPullRefreshPulling];
        }
        
        if (scrollView.contentInset.top != 0)
        {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    BOOL _loading = NO;
    if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)])
    {
        _loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
    }
    
    if (scrollView.contentOffset.y <= - 65.0f && !_loading)
    {
        if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)])
        {
            [_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
        }
        
        [self setState:EGOOPullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        scrollView.contentInset = UIEdgeInsetsMake(60.0f + self.defaultInsets.top, 
                                                   self.defaultInsets.left, 
                                                   self.defaultInsets.bottom, 
                                                   self.defaultInsets.right);
        [UIView commitAnimations];
    }
    
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [scrollView setContentInset:self.defaultInsets];
    [UIView commitAnimations];
    [self setState:EGOOPullRefreshNormal];
}


#pragma mark - Dealloc

- (void)dealloc
{
    self.delegate = nil;
    self.arrowImage = nil;
    
    [_activityView release];
    [_arrowImage release];
    [_lastUpdatedLabel release];
    [_objectKey release];
    [_statusLabel release];
    
    [super dealloc];
}

@end
