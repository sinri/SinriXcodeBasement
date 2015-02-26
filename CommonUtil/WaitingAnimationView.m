//
//  WaitingAnimationView.m
//  Neiru
//
//  Created by 倪 李俊 on 15/2/9.
//  Copyright (c) 2015年 com.leqee.erp. All rights reserved.
//

#import "WaitingAnimationView.h"

static CGFloat waitingAnimationSize=50;

@implementation WaitingAnimationView

-(instancetype)init{
    self=[super initWithFrame:(CGRectMake(0, 0, waitingAnimationSize, waitingAnimationSize))];
    if(self){
        _animationPictureArray=@[
                                 [UIImage imageNamed:@"refresh1"],
                                 [UIImage imageNamed:@"refresh2"],
                                 [UIImage imageNamed:@"refresh3"],
                                 [UIImage imageNamed:@"refresh4"],
                                 [UIImage imageNamed:@"refresh5"],
                                 [UIImage imageNamed:@"refresh6"],
                                 [UIImage imageNamed:@"refresh7"],
                                 [UIImage imageNamed:@"refresh8"],

                                 ];
        
        _animation=[[UIImageView alloc]initWithFrame:(CGRectMake(5, 0, 40, 50))];
        
        [_animation setAnimationImages:_animationPictureArray];
        [_animation setAnimationDuration:0.5];
        
        [self addSubview:_animation];
        
        [self startAnimating];
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

-(void)startAnimating{
    [_animation startAnimating];
}
-(void)stopAnimating{
    [_animation stopAnimating];
}

@end
