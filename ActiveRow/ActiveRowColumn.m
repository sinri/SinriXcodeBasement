//
//  ActiveRowColumn.m
//  YokoTableLab
//
//  Created by 倪 李俊 on 15/2/26.
//  Copyright (c) 2015年 com.sinri. All rights reserved.
//

#import "ActiveRowColumn.h"

@implementation ActiveRowColumn

-(instancetype)init{
    self= [self initWithFrame:(CGRectMake(0, 0, 100, 100))];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _presetBGColor=[UIColor whiteColor];
        self.backgroundColor=[UIColor whiteColor];
        
        _textLabel=[[UILabel alloc]initWithFrame:(CGRectMake(10, 0, frame.size.width-20, frame.size.height))];
        [self addSubview:_textLabel];
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

@end
