//
//  ActiveRowDemoViewController.h
//  YokoTableLab
//
//  Created by 倪 李俊 on 15/2/26.
//  Copyright (c) 2015年 com.sinri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActiveRow.h"

@interface ActiveRowDemoViewController : UIViewController
<ActiveRowDataSource,ActiveRowDelegate>

@property ActiveRow * theActiveRow;

@property NSMutableArray * columnModels;

@end
