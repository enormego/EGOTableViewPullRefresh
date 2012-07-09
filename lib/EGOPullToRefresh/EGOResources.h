#import <Foundation/Foundation.h>

@class UIImage;
@class UIColor;

@protocol EGOResources <NSObject>

@required
-(NSString*)egoLocalizedStringForKey:( NSString* )localization_key_;
-(UIImage*)egoArrow;
-(UIColor*)textColor;
-(NSString*)lastUpdateTimeFormate;

@end
