//
//  CacheImageUnit.h
//  Neiru
//
//  Created by 倪 李俊 on 14/11/11.
//  Copyright (c) 2014年 Sinri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CacheImageUnit : UIView
{
    NSString * image_url;
    UIImageView * imageView;
}

-(UIImage*)CacheDefaultImage;

- (void)setImage:(UIImage*)image;
- (void)setCacheImageUrl:(NSString *)cacheImageUrl;
- (void)cacheImageDownloading:(NSString *)cacheImageUrl;
- (void)cacheImageDownloaded:(UIImage *)image;

@property (readonly) BOOL useGrayImage;
-(void)setUseGrayImage:(BOOL)useGrayImage;

-(UIImage*)getImage;

-(void)setAutoresizingMask:(UIViewAutoresizing)autoresizingMask;
-(void)setContentMode:(UIViewContentMode)contentMode;

@property NSString * fileMemo;

@end
