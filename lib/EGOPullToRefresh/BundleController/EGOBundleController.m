#import "EGOBundleController.h"

@implementation EGOBundleController

@synthesize pullToRefreshBundle = _pullToRefreshBundle;
@synthesize arrowName           = _arrowName          ;
@synthesize textColor           = _textColor          ; 

-(void)dealloc
{
   [ _pullToRefreshBundle release ];
   [ _arrowName           release ];
   
   [ super dealloc ];
}

-(id)initWithBundle:( NSBundle* )bundle_
{
   self = [ super init ];
   self.pullToRefreshBundle = bundle_;
   
   return self;
}

-(id)init
{
   NSBundle* default_bundle_ = [ [ self class ] defaultPullToRefreshBundle ];
   return [ self initWithBundle: default_bundle_ ];
}

#pragma mark - 
#pragma mark Construction
+(NSBundle*)defaultPullToRefreshBundle
{
   NSString* bundle_path_ = [ [ NSBundle mainBundle ] pathForResource: @"EGOPullToRefreshResources" 
                                                               ofType: @"bundle" ];
   
   NSBundle* result_ = [ NSBundle bundleWithPath: bundle_path_ ];
   
   if ( nil == result_ )
   {
      NSLog( @"[!!!ERROR!!!] EGOBundleController->defaultPullToRefreshBundle : bundle not found" );
   }
   
   return result_;
}

#pragma mark - 
#pragma mark EGOResources
-(NSString*)egoLocalizedStringForKey:( NSString* )localization_key_
{
   return [ self.pullToRefreshBundle localizedStringForKey: localization_key_
                                                     value: nil
                                                     table: @"Localizable" ];
}

-(UIImage*)egoArrow
{
   NSString* image_path_ =  [ self.pullToRefreshBundle pathForResource: self.arrowName
                                                                ofType: @"png" ];
   
   return [ UIImage imageWithContentsOfFile: image_path_ ];
}

-(UIColor*)textColor
{
   UIColor* default_text_color_ = [UIColor colorWithRed: 87.f/255.f
                                                  green: 108.f/255.f
                                                   blue: 137.f/255.f
                                                  alpha: 1.f];

   return _textColor ? _textColor : default_text_color_;
}

-(NSString*)lastUpdateTimeFormate
{
   return [ self egoLocalizedStringForKey: @"EGO_LAST_UPDATED_FORMAT" ];
}

#pragma mark -
#pragma mark helpers
-(NSString*)arrowName
{
   return _arrowName ? _arrowName : [ self egoLocalizedStringForKey: @"EGO_ARROW_NAME" ];
}

@end

