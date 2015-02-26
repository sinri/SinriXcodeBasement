//
//  WaitingAnimationView.h
//  Neiru
//
//  Created by 倪 李俊 on 15/2/9.
//  Copyright (c) 2015年 com.leqee.erp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitingAnimationView : UIView
{
    UIImageView * _animation;
}

@property NSArray * animationPictureArray;

-(void)startAnimating;
-(void)stopAnimating;

@end
