//
//  SinriAlertView.h
//  Neiru
//
//  Created by 江戸川　シンリ on 15/2/9.
//  Copyright (c) 2015年 com.leqee.erp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SinriAlertView : UIAlertView
<UIAlertViewDelegate>
{
    void (^_clickHandler)(UIAlertView * sinriAlertView, NSInteger buttonIndex);
    void (^_didDismissHandler)(UIAlertView * sinriAlertView, NSInteger buttonIndex);
    void (^_willDismissclickHandler)(UIAlertView * sinriAlertView, NSInteger buttonIndex);
    void (^_cancelHandler)(UIAlertView * sinriAlertView);
    BOOL (^_shouldEnableFirstOtherButtonFunction)(UIAlertView * sinriAlertView);
}

-(void)setClickHandler:(void (^)(UIAlertView * sinriAlertView, NSInteger buttonIndex))clickHandler;
-(void)setDidDismissHander:(void (^)(UIAlertView * sinriAlertView, NSInteger buttonIndex))didDismissHandler;
-(void)setWillDismissHander:(void (^)(UIAlertView * sinriAlertView, NSInteger buttonIndex))willDismissclickHandler;
-(void)setCancelHandler:(void(^)(UIAlertView * sinriAlertView))cancelHandler;
-(void)setShouldEnableFirstOtherButtonFunction:(BOOL(^)(UIAlertView * sinriAlertView))shouldEnableFirstOtherButton;

-(instancetype)initWithTitle:(NSString *)title
                     message:(NSString *)message
           cancelButtonTitle:(NSString *)cancelButtonTitle
           otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

-(instancetype)initWithTitle:(NSString *)title
                     message:(NSString *)message
           completionHandler:(void (^)(UIAlertView * sinriAlertView, NSInteger buttonIndex)) handler
           cancelButtonTitle:(NSString *)cancelButtonTitle
           otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
