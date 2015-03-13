//
//  SinriCallButton.m
//  Water
//
//  Created by 倪 李俊 on 15/3/6.
//  Copyright (c) 2015年 com.leqee. All rights reserved.
//
//  このクラスをそのまま使うのは無料で、使用および結果にあらゆる形の責任をいっさい有しない。
//  このクラスを編集または再配布する場合、変更ノートとこの声明とともに含めなければならない。
//

#import "SinriCallButton.h"

static NSString * callingNumber;
static NSInteger callCount;
static NSObject * lockObj;

//static void (^calledHandler)(NSString * number);
static void (^calledHandler)(SinriCallButton * scb);
static __weak SinriCallButton * weakCallButton;

@implementation SinriCallButton

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _callNumber=@"";
        
        _callButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_callButton setFrame:(CGRectMake(0, 0, frame.size.width, frame.size.height))];
        [_callButton setImage:([UIImage imageNamed:@"SinriCallButton"]) forState:(UIControlStateNormal)];
        [_callButton addTarget:self action:@selector(onCallButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_callButton];
        
        _callWebView=[[UIWebView alloc] init];
        [self addSubview:_callWebView];
        
        if(!lockObj){
            lockObj = [[NSObject alloc] init];
            callingNumber=@"";
            callCount=0;
            calledHandler=nil;
        }
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

//-(void)setLocalCalledHandler:(void (^)(NSString *))localCalledHandler{
//    _localCalledHandler=localCalledHandler;
//}

-(void)setLocalCalledHandler:(void (^)(SinriCallButton *))localCalledHandler{
    _localCalledHandler=localCalledHandler;
}

-(void)onCallButton:(id)sender{
    if(!_callNumber || [_callNumber isEqualToString:@""]){
        [self showSinriToastInfoOnWindow:@"No number to call :("];
    }
    @synchronized(lockObj){
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_callNumber]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_callWebView loadRequest:request];
        
        weakCallButton=self;
        callingNumber=_callNumber;
        callCount=0;
        [SinriCallButton setCalledHandler:_localCalledHandler];
    }
}

#pragma mark - call lock

+(void)setCallingNumber:(NSString*)number{
    @synchronized(lockObj){
        callingNumber=number;
    }
}
+(NSString*)callingNumber{
    return callingNumber;
}

//+(void)setCalledHandler:(void (^)(NSString *))calledHandlerIn{
//    @synchronized(lockObj){
//        calledHandler=calledHandlerIn;
//    }
//}

+(void)setCalledHandler:(void (^)(SinriCallButton *))calledHandlerIn{
    @synchronized(lockObj){
        calledHandler=calledHandlerIn;
    }
}

+(void)callCount{
    @synchronized(lockObj){
        if(callingNumber && ![callingNumber isEqualToString:@""]){
            callCount++;
            if(callCount>=4){
                _Log(@"打完电话【%@】回来了",callingNumber);
                
                //DO STH
                if(calledHandler){
                    //calledHandler(callingNumber);
                    calledHandler(weakCallButton);
                }
                
                calledHandler=nil;
                callingNumber=@"";
                callCount=0;
            }
        }
    }
}


@end
