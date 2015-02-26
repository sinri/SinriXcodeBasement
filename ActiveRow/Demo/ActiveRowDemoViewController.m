//
//  ActiveRowDemoViewController.m
//  YokoTableLab
//
//  Created by 倪 李俊 on 15/2/26.
//  Copyright (c) 2015年 com.sinri. All rights reserved.
//

#import "ActiveRowDemoViewController.h"

@interface ActiveRowDemoViewController ()

@end

@implementation ActiveRowDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _columnModels=[@[] mutableCopy];
    for (int i=0; i<15; i++) {
        [_columnModels addObject:@(i)];
    }
    
    _theActiveRow=[[ActiveRow alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 100)];
    [_theActiveRow setDelegate:self];
    [_theActiveRow setDataSource:self];
    [self.view addSubview:_theActiveRow];
    
    UIButton * insertBtn=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [insertBtn setFrame:(CGRectMake(10, 200, 100, 50))];
    [insertBtn setTitle:@"Insert" forState:(UIControlStateNormal)];
    [insertBtn setBackgroundColor:([UIColor greenColor])];
    [insertBtn addTarget:self action:@selector(onInsertButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:insertBtn];
    
    UIButton * deleteBtn=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [deleteBtn setFrame:(CGRectMake(210, 200, 100, 50))];
    [deleteBtn setTitle:@"Delete" forState:(UIControlStateNormal)];
    [deleteBtn setBackgroundColor:([UIColor greenColor])];
    [deleteBtn addTarget:self action:@selector(onDeleteButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:deleteBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)onInsertButton:(id)sender{
    if(_theActiveRow.selectedColumnIndex>=0){
        [_columnModels insertObject:@(arc4random()%100+100) atIndex:_theActiveRow.selectedColumnIndex];
        [_theActiveRow reloadData];
        
        [_theActiveRow setSelectedColumnIndex:_theActiveRow.selectedColumnIndex+1];
        
        if(![_theActiveRow entirelyVisibilityOfColumnAtIndex:_theActiveRow.selectedColumnIndex]){
            [_theActiveRow scrollToShowColumnAtIndex:_theActiveRow.selectedColumnIndex animated:YES];
        }
    }
}
-(void)onDeleteButton:(id)sender{
    if(_theActiveRow.selectedColumnIndex>=0){
        [_columnModels removeObjectAtIndex:_theActiveRow.selectedColumnIndex];
        [_theActiveRow reloadData];
        
        [_theActiveRow setSelectedColumnIndex:_theActiveRow.selectedColumnIndex-1];
        
        if(![_theActiveRow entirelyVisibilityOfColumnAtIndex:_theActiveRow.selectedColumnIndex]){
            [_theActiveRow scrollToShowColumnAtIndex:_theActiveRow.selectedColumnIndex animated:YES];
        }
    }
}

#pragma active row protocol implement

-(NSUInteger)numberOfColumn{
    return [_columnModels count];
}

-(ActiveRowColumn *)columnForIndex:(NSUInteger)index inActiveRow:(ActiveRow *)activeRow{
    ActiveRowColumn * column=[activeRow currentColumnForIndex:index];
    if(!column){
        column=[[ActiveRowColumn alloc]initWithFrame:(CGRectMake(0, 0, 50*([_columnModels[index] integerValue] % 3+1), 100))];
    }
    
    [[column textLabel]setText:[_columnModels[index] stringValue]];
    
    return column;
}

-(void)ActiveRow:(ActiveRow *)activeRow didTapColumn:(ActiveRowColumn *)column atIndex:(NSUInteger)index{
    NSLog(@"did tap column: index=%lu",(unsigned long)index);
}

@end
