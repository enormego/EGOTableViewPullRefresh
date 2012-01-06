#import "EGOResources.h"
#import <Foundation/Foundation.h>

@class UIImage;
@class UIColor;

@interface EGOBundleController : NSObject< EGOResources >

@property ( nonatomic, retain ) NSBundle* pullToRefreshBundle;
@property ( nonatomic, retain ) NSString* arrowName;
@property ( nonatomic, retain ) UIColor*  textColor;

-(id)initWithBundle:( NSBundle* )bundle_;
+(NSBundle*)defaultPullToRefreshBundle;

@end
