//
//  ActiveRow.m
//  YokoTableLab
//
//  Created by 倪 李俊 on 15/2/26.
//  Copyright (c) 2015年 com.sinri. All rights reserved.
//

#import "ActiveRow.h"

@implementation ActiveRow

-(instancetype)init{
    self=[super initWithFrame:(CGRectZero)];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        _selectedColumnIndex=-1;
        _selectionStyle=ActiveRowSelectionStyleSingle;
        _columnSelectionStyle=ActiveRowColumnSelectionStyleGray;
    }
    return self;
}

-(void)reloadData{
    _columnArray=[@[] mutableCopy];
    
    for (id oldColumn in [self subviews]) {
        if([oldColumn isKindOfClass:[ActiveRowColumn class]]){
            [oldColumn removeFromSuperview];
        }
    }
    
    if(_dataSource){
        NSInteger columnCount=[_dataSource numberOfColumn];
        
        for (NSInteger i=0; i<columnCount; i++) {
            ActiveRowColumn * column=[_dataSource columnForIndex:i inActiveRow:self];
            column=column?:[[ActiveRowColumn alloc]init];
            [_columnArray addObject:column];
        }
        
        CGFloat x=0;
        for (NSInteger index=0;index<_columnArray.count;index++) {
            ActiveRowColumn * column=[_columnArray objectAtIndex:index];
            [column setFrame:(CGRectMake(x, 0, column.frame.size.width, self.frame.size.height))];
            [self addSubview:column];
            
            UITapGestureRecognizer * columnTapper=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onColumnTapper:)];
            [column addGestureRecognizer:columnTapper];
            
            x+=column.frame.size.width;
        }
        
        [self setContentSize:(CGSizeMake(x, self.frame.size.height))];
        
        [self setSelectedColumnIndex:_selectedColumnIndex];
    }
}

-(ActiveRowColumn*)currentColumnForIndex:(NSUInteger)index{
    if(!_columnArray){
        return nil;
    }
    if(index<_columnArray.count){
        return [_columnArray objectAtIndex:index];
    }
    return nil;
}

-(void)setSelectedColumnIndex:(NSInteger)selectedColumnIndex{
    if(_selectionStyle==ActiveRowSelectionStyleNone){
        _selectedColumnIndex=-1;
        return;
    }
    else if(_selectionStyle==ActiveRowSelectionStyleSingle){
    if(_columnArray){
        if(selectedColumnIndex>0 && selectedColumnIndex<_columnArray.count){
            //keep it
            _selectedColumnIndex=selectedColumnIndex;
        }else{
            _selectedColumnIndex=-1;
        }
    }else{
        _selectedColumnIndex=-1;
    }
    if(_columnSelectionStyle==ActiveRowColumnSelectionStyleGray){
        for (NSInteger i=0; i<_columnArray.count; i++) {
            ActiveRowColumn*column=[self currentColumnForIndex:i];
            if(i==_selectedColumnIndex){
                [column setBackgroundColor:([UIColor colorWithWhite:0.9 alpha:0.6])];
            }else{
                [column setBackgroundColor:column.presetBGColor];
            }
        }
    }
    }
}

-(void)scrollToShowColumnAtIndex:(NSUInteger)index animated:(BOOL)animated{
    ActiveRowColumn * column=[self currentColumnForIndex:index];
    if(column){
        //[self scrollRectToVisible:column.frame animated:animated];
     
        if(column.frame.origin.x+column.frame.size.width>self.frame.size.width){
            [self setContentOffset:(CGPointMake(column.frame.origin.x+column.frame.size.width-self.frame.size.width, 0)) animated:YES];
        }else{
            [self setContentOffset:(CGPointMake(0, 0)) animated:YES];
        }
    }
}

-(BOOL)entirelyVisibilityOfColumnAtIndex:(NSUInteger)index{
    ActiveRowColumn * column=[self currentColumnForIndex:index];
    if(column){
        CGFloat left=column.frame.origin.x;
        CGFloat right=left+column.frame.size.width;
        
        CGFloat visibleLeft=self.contentOffset.x;
        CGFloat visibleRight=visibleLeft+self.frame.size.width;
        
        return (left>=visibleLeft && right<=visibleRight);
    }else{
        return NO;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self reloadData];
}

-(void)onColumnTapper:(UITapGestureRecognizer *)tapper{
    ActiveRowColumn * column=(ActiveRowColumn*)tapper.view;
    NSUInteger index=[_columnArray indexOfObject:column];
    
//    if(index==_selectedColumnIndex){
//        [self setSelectedColumnIndex:-1];
//    }else{
        [self setSelectedColumnIndex:index];
//    }
    
    if(self.delegate){
        if([self.delegate respondsToSelector:@selector(ActiveRow:didTapColumn:atIndex:)]){
            [self.delegate ActiveRow:self didTapColumn:column atIndex:index];
        }
    }
}


@end
