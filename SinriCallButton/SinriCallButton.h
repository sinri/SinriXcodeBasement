//
//  SinriCallButton.h
//  Water
//
//  Created by 倪 李俊 on 15/3/6.
//  Copyright (c) 2015年 com.sinri. All rights reserved.
//
//  使い方について、注意すべきところは、`[AppDelegate applicationDidBecomeActive:]`と`[AppDelegate applicationWillResignActive:]`で、`[SinriCallButton callCount];`を書き込むこと。また、ブタンの画像は5:3の縦横比の`SinriCallButton`という名で用意することも必要であること。
//  初期化するにはframeを設定すればいいが、指定する番号に電話を掛けたがったらその後callNumberを設定しなければならない。
//  必要なら、`setLocalCalledHandler:`によって電話することを処理するハンドルも設定しよう。
//
//  このクラスをそのまま使うのは無料で、使用および結果にあらゆる形の責任をいっさい有しない。
//  このクラスを編集または再配布する場合、変更ノートとこの声明とともに含めなければならない。
//

#import <UIKit/UIKit.h>


@interface SinriCallButton : UIControl
{
    UIButton * _callButton;
    UIWebView * _callWebView;
    
    //void (^_localCalledHandler)(NSString * number);
    void (^_localCalledHandler)(SinriCallButton * scb);
}

@property NSString * callNumber;

//-(void)setLocalCalledHandler:(void(^)(NSString * number))localCalledHandler;
-(void)setLocalCalledHandler:(void(^)(SinriCallButton * scb))localCalledHandler;

//+(void)setCalledHandler:(void(^)(NSString * number))calledHandlerIn;
+(void)setCalledHandler:(void(^)(SinriCallButton * scb))calledHandlerIn;

+(void)callCount;

@end
