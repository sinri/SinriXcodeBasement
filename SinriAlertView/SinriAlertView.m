//
//  SinriAlertView.m
//  Neiru
//
//  Created by 江戸川　シンリ on 15/2/9.
//  Copyright (c) 2015年 com.leqee.erp. All rights reserved.
//

#import "SinriAlertView.h"

@implementation SinriAlertView
/*
+ (va_list)getVAList:(NSObject*)string, ... {// parms must be end with nil
    va_list args;
    va_start(args, string);
    if (string) {
        _Log(@"Do something with First: %@", string);
        NSObject *other;
        while ((other = va_arg(args, NSObject *))) {
            _Log(@"Do something with other: %@", other);
        }
    }
    va_end(args);
    return args;
}
*/

-(instancetype)initWithTitle:(NSString *)title
                     message:(NSString *)message
           cancelButtonTitle:(NSString *)cancelButtonTitle
           otherButtonTitles:(NSString *)otherButtonTitles, ...{
    self=[super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    if(self){
        va_list args;
        va_start(args, otherButtonTitles);
        if (otherButtonTitles) {
            //先处理第一个
            [self addButtonWithTitle:(NSString*)otherButtonTitles];
            //再处理那坨省略号
            NSObject *other;
            while ((other = va_arg(args, NSObject *))) {
                [self addButtonWithTitle:(NSString*)other];
            }
        }
        va_end(args);
    }
    return self;
}
-(instancetype)initWithTitle:(NSString *)title
                     message:(NSString *)message
           completionHandler:(void (^)(UIAlertView * sinriAlertView, NSInteger buttonIndex)) handler
           cancelButtonTitle:(NSString *)cancelButtonTitle
           otherButtonTitles:(NSString *)otherButtonTitles, ...{
    self=[super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles: nil];
    if(self){
        va_list args;
        va_start(args, otherButtonTitles);
        if (otherButtonTitles) {
            //先处理第一个
            [self addButtonWithTitle:(NSString*)otherButtonTitles];
            //再处理那坨省略号
            NSObject *other;
            while ((other = va_arg(args, NSObject *))) {
                [self addButtonWithTitle:(NSString*)other];
            }
        }
        va_end(args);
        
        [self setClickHandler:handler];
    }
    return self;
}

#pragma mark - handler setter

-(void)setClickHandler:(void (^)(UIAlertView *, NSInteger))clickHandler{
    _clickHandler=clickHandler;
}

-(void)setDidDismissHander:(void (^)(UIAlertView *, NSInteger))didDismissHandler{
    _didDismissHandler=didDismissHandler;
}

-(void)setWillDismissHander:(void (^)(UIAlertView *, NSInteger))willDismissclickHandler{
    _willDismissclickHandler=willDismissclickHandler;
}

-(void)setCancelHandler:(void (^)(UIAlertView *))cancelHandler{
    _cancelHandler=cancelHandler;
}

-(void)setShouldEnableFirstOtherButtonFunction:(BOOL (^)(UIAlertView *))shouldEnableFirstOtherButton{
    _shouldEnableFirstOtherButtonFunction=shouldEnableFirstOtherButton;
}

#pragma mark - delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(_clickHandler){
        __weak UIAlertView * weakAV=alertView;
        _clickHandler(weakAV, buttonIndex);
    }
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(_didDismissHandler){
        __weak UIAlertView * weakAV=alertView;
        _didDismissHandler(weakAV,buttonIndex);
    }
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(_willDismissclickHandler){
        __weak UIAlertView * weakAV=alertView;
        _willDismissclickHandler(weakAV,buttonIndex);
    }
}

-(void)alertViewCancel:(UIAlertView *)alertView{
    if(_cancelHandler){
        __weak UIAlertView * weakAV=alertView;
        _cancelHandler(weakAV);
    }
}
-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView{
    BOOL result=YES;
    if (_shouldEnableFirstOtherButtonFunction) {
        __weak UIAlertView * weakAV=alertView;
        result=_shouldEnableFirstOtherButtonFunction(weakAV);
    }
    return result;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
