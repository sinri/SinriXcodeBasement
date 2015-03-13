//
//  CacheImageUnit.m
//  Neiru
//
//  Created by 倪 李俊 on 14/11/11.
//  Copyright (c) 2014年 Sinri. All rights reserved.
//

#import "CacheImageUnit.h"

#import "UIBaseUtils.h"

@implementation CacheImageUnit

-(void)setUseGrayImage:(BOOL)useGrayImage{
    _useGrayImage=useGrayImage;
    
    [self setCacheImageUrl:image_url];
}

-(void)setImage:(UIImage*)image{
    if(imageView){
        [imageView removeFromSuperview];
        imageView = nil;
    }
    
    UIImage * finalImg=image;
    
    if(_useGrayImage)finalImg=[UIBaseUtils convertImageToGrayScale:image];
    
    imageView = [[UIImageView alloc]initWithFrame:(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))];
    [imageView setImage:finalImg];
    [self addSubview:imageView];
}

-(void)setAutoresizingMask:(UIViewAutoresizing)autoresizingMask{
    [imageView setAutoresizingMask:autoresizingMask];
}
-(void)setContentMode:(UIViewContentMode)contentMode{
    [imageView setContentMode:contentMode];
}

-(UIImage*)getImage{
    return imageView.image;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(UIImage*)CacheDefaultImage{
    return
    //    [UIBaseUtils getPureColorImage:([UIColor whiteColor]) size:(CGSizeMake(10, 10))];
    [UIImage imageNamed:@"Icon"];
    //[UIImage imageNamed:@"DefaultUserLogo"];
    //UIUtil::Image(@"settings.png");
}

- (void)setCacheImageUrl:(NSString *)cacheImageUrl
{
    image_url=cacheImageUrl;
    if(image_url){
        NSString *path = NSUtil::CacheUrlPath(cacheImageUrl);
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        if (image == nil)
        {
            [self setImage:[self CacheDefaultImage] ];
            [self performSelectorInBackground:@selector(cacheImageDownloading:) withObject:cacheImageUrl];
        }else{
            [self setImage:image];
        }
    }
}

//
- (void)cacheImageDownloading:(NSString *)cacheImageUrl
{
    @autoreleasepool
    {
        //_Log(@"cacheImageDownloading %@", cacheImageUrl);
        NSString *path = NSUtil::CacheUrlPath(cacheImageUrl);
        NSData *data = HttpUtil::DownloadData(cacheImageUrl, path, DownloadFromOnline);
        UIImage *image = data ? [UIImage imageWithData:data] : nil;
        if(image){
            //_LogLine();
            [self performSelectorOnMainThread:@selector(cacheImageDownloaded:) withObject:image waitUntilDone:YES];
        }
    }
}

//
- (void)cacheImageDownloaded:(UIImage *)image
{
    if (image)
    {
        //_LogLine();
        
        [self setImage:image];
        
        CGFloat alpha = self.alpha;
        self.alpha = 0;
        [UIView animateWithDuration:0.5 animations:^()
         {
             self.alpha = alpha;
         }];
        
    }
}


@end
