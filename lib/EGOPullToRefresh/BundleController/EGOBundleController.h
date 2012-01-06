#import <Foundation/Foundation.h>

@interface EGOBundleController : NSObject

+(NSBundle*)pullToRefreshBundle;
+(NSString*)localizedStringForKey:( NSString* )localization_key_;

@end
