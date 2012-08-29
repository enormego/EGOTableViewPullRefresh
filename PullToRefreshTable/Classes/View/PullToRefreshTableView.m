//
//  PullToRefreshTableHeaderView.h
//
//  Based on EGORefreshTableHeaderView.h by Devin Doty on 10/14/09October14
//  Copyright 2009 enormego. All rights reserved.
// 
//  Modified and improved by Paul Chapman on 20/03/21.
//  Modifications copyright (c) 2012 Moneytree. All rights reserved.
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

#import "PullToRefreshTableView.h"

#define PTR_TEXT_COLOR	 [UIColor colorWithRed:87.0f/255.0f green:108.0f/255.0f blue:137.0f/255.0f alpha:1.0f]
#define PTR_SHADOW_COLOR [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.2f]
#define PTR_ARROW_COLOR  [UIColor blueColor]
#define PTR_FLIP_ANIMATION_DURATION 0.18f

@interface PullToRefreshTableView ()
- (void)setState:(kPullToRefreshTableState)aState;
@property (nonatomic,strong) UILabel *lastUpdatedLabel;
@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) CALayer *arrowImage;
@property (nonatomic,strong) UIActivityIndicatorView *activityView;

@end

@implementation PullToRefreshTableView
@synthesize arrowColor=_arrowColor, textColor=_textColor, shadowColor=_shadowColor, shadowOffset=_shadowOffset;
@synthesize animationDuration=_animationDuration, activityView=_activityView, arrowImageName=_arrowImageName, arrowImage=_arrowImage;
@synthesize lastUpdatedLabel=_lastUpdatedLabel, statusLabel=_statusLabel;
@synthesize delegate=_delegate;

#pragma mark - Init/ Dealloc

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)aTextColor
{
  if((self = [super initWithFrame:frame]))
  {
    // use passed in textcolor passed in
    _textColor = aTextColor;
    _arrowImageName = arrow;
    
    // set defaults
    _animationDuration = PTR_FLIP_ANIMATION_DURATION;
    _arrowColor = PTR_ARROW_COLOR;
    _shadowColor = PTR_SHADOW_COLOR;
    _shadowOffset = CGSizeMake(0.0f, 1.0f);
    
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    self.autoresizesSubviews = YES;
		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];

		_lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		_lastUpdatedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_lastUpdatedLabel.font = [UIFont systemFontOfSize:12.0f];
		_lastUpdatedLabel.backgroundColor = [UIColor clearColor];
		_lastUpdatedLabel.textAlignment = UITextAlignmentCenter;
		
		_statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		_statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		_statusLabel.backgroundColor = [UIColor clearColor];
		_statusLabel.textAlignment = UITextAlignmentCenter;

    [self _commonLabelSetup]; // apply the styles
    
    // add to view
		[self addSubview:_lastUpdatedLabel];
		[self addSubview:_statusLabel];
		
		[self _arrowLayerSetup];
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		
		[self setState:PullToRefreshTableStateNormal];
		
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  return [self initWithFrame:frame arrowImageName:@"blueArrow.png" textColor:PTR_TEXT_COLOR];
}

- (void)dealloc
{
	self.delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
}

#pragma mark - Private Methods

-(void)_commonLabelSetup
{
  self.lastUpdatedLabel.textColor = self.textColor;
  self.lastUpdatedLabel.shadowColor = self.shadowColor;
  self.lastUpdatedLabel.shadowOffset = self.shadowOffset;

  self.statusLabel.textColor = self.textColor;
  self.statusLabel.shadowColor = self.shadowColor;
  self.statusLabel.shadowOffset = self.shadowOffset;
}

-(void)_arrowLayerSetup
{
  CALayer *layer = [CALayer layer];
  layer.frame = CGRectMake(25.0f, self.frame.size.height - 65.0f, 30.0f, 55.0f);
  layer.contentsGravity = kCAGravityResizeAspect;
  
  layer.contents = (id)[self _maskArrowWithImageNamed:_arrowImageName].CGImage;
  
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
  if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
    layer.contentsScale = [[UIScreen mainScreen] scale];
  }
#endif
  if(_arrowImage)
  {
    // remove if already set before
    [_arrowImage removeFromSuperlayer];
  }
  _arrowImage = layer;
  [[self layer] addSublayer:_arrowImage];
}

-(UIImage*)_maskArrowWithImageNamed:(NSString*)imageName
{
  UIImage * image = [UIImage imageNamed:imageName];
  CGFloat width = image.size.width;
  CGFloat height = image.size.height;
  
  // Code gracefully borrowed from:
  // https://gist.github.com/1102091
  // ==============================
  
  CGRect rect = CGRectMake(0.0f, 0.0f, width, height);
  UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
  CGContextRef c = UIGraphicsGetCurrentContext();
  if (c)
  {
    [image drawInRect:rect];
    CGContextSetFillColorWithColor(c, self.arrowColor.CGColor);
    CGContextSetBlendMode(c, kCGBlendModeSourceAtop);
    CGContextFillRect(c, rect);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
  }
  return image;
}

#pragma mark - Custom Setters

-(void)setArrowColor:(UIColor *)arrowColor
{
  _arrowColor = arrowColor;
  [self _arrowLayerSetup];
}

-(void)setTextColor:(UIColor *)textColor
{
  _textColor = textColor;
  [self _commonLabelSetup];
}

-(void)setShadowColor:(UIColor *)shadowColor
{
  _shadowColor = shadowColor;
  [self _commonLabelSetup];
}

-(void)setShadowOffset:(CGSize)shadowOffset
{
  _shadowOffset = shadowOffset;
  [self _commonLabelSetup];
}

#pragma mark - Setters

- (void)refreshLastUpdatedDate 
{	
	if ([self.delegate respondsToSelector:@selector(pullToRefreshTableHeaderDataSourceLastUpdated:)]) 
  {	
		NSDate *date = [self.delegate pullToRefreshTableHeaderDataSourceLastUpdated:self];
		
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];

    NSString *lastUpdatedCaption = NSLocalizedString(@"Last updated: %@", @"Last updated caption");
		self.lastUpdatedLabel.text = [NSString stringWithFormat:lastUpdatedCaption, [date stringWithDateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"PullToRefreshTable_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	}
  else
  {
		_lastUpdatedLabel.text = nil;
	}
}

- (void)setState:(kPullToRefreshTableState)aState
{
	switch (aState) 
  {
		case PullToRefreshTableStatePulling:
			
			_statusLabel.text = NSLocalizedString(@"Release to refresh...", @"Release to refresh status");
			[CATransaction begin];
			[CATransaction setAnimationDuration:self.animationDuration];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case PullToRefreshTableStateNormal:
			
			if (_state == PullToRefreshTableStatePulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:self.animationDuration];
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
		case PullToRefreshTableStateLoading:
			
			_statusLabel.text = NSLocalizedString(@"Loading...", @"Loading status");
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


#pragma mark - ScrollView Methods

- (void)pullToRefreshTableScrollViewDidScroll:(UIScrollView *)scrollView 
{	
	if (_state == PullToRefreshTableStateLoading)
  {
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	}
  else if (scrollView.isDragging)
  {
		BOOL _loading = NO;
		if ([self.delegate respondsToSelector:@selector(pullToRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [self.delegate pullToRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == PullToRefreshTableStatePulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:PullToRefreshTableStateNormal];
		} else if (_state == PullToRefreshTableStateNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
			[self setState:PullToRefreshTableStatePulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
}

- (void)pullToRefreshTableScrollViewDidEndDragging:(UIScrollView *)scrollView 
{
	BOOL _loading = NO;
	if ([self.delegate respondsToSelector:@selector(pullToRefreshTableHeaderDataSourceIsLoading:)]) 
  {
		_loading = [self.delegate pullToRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - 65.0f && !_loading) 
  {
		if ([self.delegate respondsToSelector:@selector(pullToRefreshTableHeaderDidTriggerRefresh:)])
    {
			[self.delegate pullToRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:PullToRefreshTableStateLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	}
}

- (void)pullToRefreshTableScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:PullToRefreshTableStateNormal];
}

@end
