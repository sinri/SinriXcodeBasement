//
//  ViewController.m
//  SinriAdDemo
//
//  Created by 倪 李俊 on 15/2/28.
//  Copyright (c) 2015年 com.sinri. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    CGFloat adViewHeight=[SinriAdView recommendedBannerHeight];
    _adView = [[SinriAdView alloc]initWithFrame:(CGRectMake(0, self.view.frame.size.height-adViewHeight, self.view.frame.size.width, adViewHeight))];
    [self.view addSubview:_adView];

    //MARK: Use YES here to enable AdMob
    [_adView setUseAdMob:NO];
    [_adView setGAD_UNIT_ID:@"XXX"];
    [_adView setRootViewController:self];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
