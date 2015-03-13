//
//  CommonUtil.h
//  NeiruForWorker
//
//  Created by 倪 李俊 on 14/11/25.
//  Copyright (c) 2014年 com.leqee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SystemLanguage_UNKNOWN=0,
    SystemLanguage_ChineseSimplified=1,
    SystemLanguage_ChineseTraditional=2,
    SystemLanguage_Japanese=4,
    SystemLanguage_English=3
} SystemLanguageType;

@interface CommonUtil : NSObject

#pragma mark -
#pragma mark sandbox path related

+(NSString *)DocumentPath;
+(NSString *)DocumentPath:(NSString *)file;

+(NSString *)CachePath;
+(NSString *)CachePath:(NSString *)file;
+(NSString *)CacheUrlPath:(NSString*)url;
+(void) ClearCache;
+(unsigned long long) CacheSize;

#pragma mark -
#pragma mark net

+(NSString *)URLEscape:(NSString *)string;
+(NSString *)URLUnEscape:(NSString *)string;

#pragma mark -
#pragma mark device and version

+(UIDevice *)Device;
+(float) SystemVersion;
+(UIScreen *)Screen;
+(CGFloat) ScreenScale;
+(CGRect) AppFrame;
+(CGSize) ScreenSize;
+(CGRect) ScreenBounds;
+(BOOL) IsOS7_Later;
+(BOOL) IsOS8_Later;

+(UIWindow *)Window;

+(SystemLanguageType)getSystemLanguageType;

+(BOOL)checkIdentityCardNo:(NSString*)cardNo;

#pragma mark -
#pragma mark ui

+(UIBarButtonItem*)getNavBackButtonItemIn:(id)target action:(SEL)sel;
+(UIBarButtonItem*)getNavBackButtonItemIn:(id)target;
+(UILabel*)getNavBarTitleAs:(NSString*)title inViewController:(UIViewController*)target;
+(UIBarButtonItem*)getNavSearchButtonItemIn:(id)target action:(SEL)sel;

+(UIImage*)getPureColorImage:(UIColor*)color size:(CGSize)size;


+(UIColor *)getTitleBarBackgroundColor;
+(UIFont *)getTitleBarFont;
+(UIColor *)getTableBackgroundColor;
+(UIColor *)getTableCellBackgroundColor;
+(UIColor *)getViewBackgroundColor;

+(UIColor *)getSegmentBackgroundColor;
+(UIColor *)getSegmentFrontColor;

+(UIAlertView*)showOneButtonAlertWithTitle:(NSString*)title withContent:(NSString*)message withDelegate:(id)delegate;
+(UIAlertView*)showConfirmAlertWithTitle:(NSString*)title withContent:(NSString*)message withTag:(NSInteger)tag withDelegate:(id)delegate;

+(UIToolbar*)getInputAccessoryToolBarForEndInputing:(id)target action:(SEL)action;

#pragma mark -
#pragma mark string

/**
 day-hour-minute-second
 **/
+(NSString*)timeIntervalDescription:(NSTimeInterval)timeInterval;
/**
 format: @"yyyy'-'MM'-'dd HH':'mm':'ss";
 **/
+(NSString*)stringOfDate:(NSDate*)date inFormat:(NSString*)format;
/**
 format: @"yyyy'-'MM'-'dd HH':'mm':'ss";
 **/
+(NSDate*)dateOfString:(NSString*)string inFormat:(NSString*)format;

+(CGFloat)getTextWidth:(NSString*)text withFontSize:(CGFloat)fontSize;

+(CGFloat)getTextHeight:(NSString*)text useWidth:(CGFloat)textWidth;
+(CGFloat)getTextHeight:(NSString*)text useWidth:(CGFloat)textWidth withFontSize:(CGFloat)fontSize;

@end

@class UIView;

@interface UIView (makeCall)

+(NSInteger)SINRI_UIVIEW_MAKECALL_WEBVIEW_TAG;//声明打电话用控件，用户无需在意

/**
 在应用内打电话很方便但是打完回不来比较恶心，直接的API居然还是私有API，卖不了。
 这个UIView的扩展方法使所有UIView和其子类的实例都可以乱打电话出去然后回来了。
 */
-(void)makeCall:(NSString*)tel;

@end

@interface UIView (waiting)

/**
 显示一个自动消失的面包板，提示用户。
 */
-(void)showSinriToastInfo:(NSString*)info;
-(void)showSinriToastInfoOnWindow:(NSString*)info;

+(BOOL)SINRI_UIVIEW_WAITING_USE_CUSTOMIZED_ANIMATION;//是否使用自定义的等待动画
+(NSInteger)SINRI_UIVIEW_WAITING_WaitingAnimationView_TAG; //声明等待控件，用户无需在意
+(NSInteger)SINRI_UIVIEW_WAITING_UIActivityIndicatorView_TAG; //声明等待控件，用户无需在意
+(NSInteger)SINRI_UIVIEW_WAITING_UIView_TAG; //声明等待控件，用户无需在意


/**
 启动一个等待指示画面。
 block参数指定是否锁住用户操作，fullView参数指定是否盖满整个View。
 一般不必直接调用此方法，而用startWait/startFullWait/stopWait代替。
 */
-(void)startWaitWithBlock:(BOOL)block forFullView:(BOOL)fullView;

/**
 启动一个等待指示画面，锁定用户在view内的操作。黑底白圈，100见方，居中。
 用于等待一个操作的数据交互。
 */
-(void)startWait;

/**
 启动一个等待指示画面，锁定用户在view内的操作。浅灰底灰圈，盖满view。
 用于等待一个页面加载的数据交互。
 */
-(void)startFullWait;

/**
 结束等待，抹杀等待指示画面。
 */
-(void)stopWait;

@end

@class UIViewController;

@interface UIViewController (neiruVCUI)

-(void)setStandardNavigationBarColor;

/**
 为自身view启动一个等待指示画面。
 block参数指定是否锁住用户操作，fullView参数指定是否盖满整个View。
 一般不必直接调用此方法，而用startWait/startFullWait/stopWait代替。
 */
-(void)startWaitWithBlock:(BOOL)block forFullView:(BOOL)fullView;

/**
 为自身view启动一个等待指示画面，锁定用户在view内的操作。黑底白圈，100见方，居中。
 用于等待一个操作的数据交互。
 */
-(void)startWait;

/**
 为自身view启动一个等待指示画面，锁定用户在view内的操作。浅灰底灰圈，盖满view。
 用于等待一个页面加载的数据交互。
 */
-(void)startFullWait;

/**
 结束等待，抹杀等待指示画面。
 */
-(void)stopWait;

@end

@interface UIImage (CommonImplement)
- (UIImage *) makeThumbnailOfSize:(CGSize)size;
-(UIImage*)scaledCopyWithNewSize:(CGSize)newSize;
@end

@interface UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

@end

