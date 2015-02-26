//
//  ActiveRow.h
//  YokoTableLab
//
//  Created by 倪 李俊 on 15/2/26.
//  Copyright (c) 2015年 com.sinri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActiveRowColumn.h"

typedef enum : NSUInteger {
    ActiveRowSelectionStyleNone,
    ActiveRowSelectionStyleSingle,
//    ActiveRowSelectionStyleMultiple,
} ActiveRowSelectionStyle;

typedef enum : NSUInteger {
    ActiveRowColumnSelectionStyleNone,
    ActiveRowColumnSelectionStyleGray,
} ActiveRowColumnSelectionStyle;

@class ActiveRow;

@protocol ActiveRowDelegate <NSObject,UIScrollViewDelegate>

@optional
-(void)ActiveRow:(ActiveRow*)activeRow didTapColumn:(ActiveRowColumn*)column atIndex:(NSUInteger)index;

@end

@protocol ActiveRowDataSource <NSObject>

-(NSUInteger)numberOfColumn;
-(ActiveRowColumn*)columnForIndex:(NSUInteger)index inActiveRow:(ActiveRow*)activeRow;

@end

@interface ActiveRow : UIScrollView
{
//    NSMutableArray * _selection;
    NSMutableArray * _columnArray;
}

#pragma mark - General

@property (nonatomic,assign) id<ActiveRowDataSource> dataSource;
@property (nonatomic,assign) id<ActiveRowDelegate> delegate;

#pragma mark - UI

-(void)reloadData;

-(ActiveRowColumn*)currentColumnForIndex:(NSUInteger)index;

-(void)scrollToShowColumnAtIndex:(NSUInteger)index animated:(BOOL)animated;
-(BOOL)entirelyVisibilityOfColumnAtIndex:(NSUInteger)index;

#pragma mark - Selection

@property ActiveRowSelectionStyle selectionStyle;
@property ActiveRowColumnSelectionStyle columnSelectionStyle;

@property (readonly) NSInteger selectedColumnIndex;//minus and too large for unselected
-(void)setSelectedColumnIndex:(NSInteger)selectedColumnIndex;

@end
