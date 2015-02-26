//
//  CommonUtil.m
//  NeiruForWorker
//
//  Created by 倪 李俊 on 14/11/25.
//  Copyright (c) 2014年 com.leqee. All rights reserved.
//

#import "CommonUtil.h"
#import <UIKit/UIKit.h>
#import "WaitingAnimationView.h"

@implementation CommonUtil

#pragma mark -
#pragma mark sandbox path related

+(NSString *)UserDirectoryPath:(NSSearchPathDirectory) directory
{
    return [NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES) objectAtIndex:0];
}

//
+(NSString *)DocumentPath
{
    return [CommonUtil UserDirectoryPath:(NSDocumentDirectory)];
}

//
+(NSString *)DocumentPath:(NSString *)file
{
    return [[CommonUtil DocumentPath] stringByAppendingPathComponent:file];
}


+(NSString *)CachePath
{
    //return DocumentPath(@"Cache");
    return [[CommonUtil UserDirectoryPath:(NSCachesDirectory) ] stringByAppendingPathComponent:@"Cache"];
}

//
+(void) ClearCache
{
    [[NSFileManager defaultManager] removeItemAtPath:[CommonUtil CachePath] error:nil];
}

//
+(NSString *)CachePath:(NSString *)file
{
    NSString *dir = [CommonUtil CachePath];
    if(![[NSFileManager defaultManager] fileExistsAtPath:dir])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [dir stringByAppendingPathComponent:file];
}

//
+(NSString *)CacheUrlPath:(NSString *)url
{
    unichar chars[256];
    NSRange range = {0, MIN(url.length, 256)};
    [url getCharacters:chars range:range];
    for (NSUInteger i = 0; i < range.length; i++)
    {
        switch (chars[i])
        {
            case '|':
            case '/':
            case '\\':
            case '?':
            case '*':
            case ':':
            case '<':
            case '>':
            case '"':
                chars[i] = '_';
                break;
        }
    }
    NSString *file = [NSString stringWithCharacters:chars length:range.length];
    return [CommonUtil CachePath:file];
}

//
+(unsigned long long) CacheSize
{
    NSString *dir = [CommonUtil CachePath];
    
    //
    unsigned long long size = 0;
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:dir];
    for (NSString *file in files)
    {
        NSString *path = [dir stringByAppendingPathComponent:file];
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        size += [dict fileSize];
    }
    
    return size;
}

#pragma mark -
#pragma mark device and version

+(UIDevice *)Device
{
    return [UIDevice currentDevice];
}

//
+(float) SystemVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

//
+(UIScreen *)Screen
{
    return [UIScreen mainScreen];
}

+(UIWindow *)Window{
    return [UIApplication sharedApplication].delegate.window;
}

//
+(BOOL) IsOS7_Later
{
    return [CommonUtil SystemVersion] >= 7.0;
}

//
+(BOOL) IsOS8_Later
{
    return [CommonUtil SystemVersion] >= 8.0;
}

//
+(CGFloat) ScreenScale
{
    return [CommonUtil Screen].scale;
}

//
+(CGRect) AppFrame
{
    return [UIScreen mainScreen].applicationFrame;
}

//
+(CGSize) ScreenSize
{
    CGRect frame = [CommonUtil AppFrame];
    return CGSizeMake(frame.size.width, frame.size.height + frame.origin.y);
}

//
+(CGRect) ScreenBounds
{
    return [CommonUtil Screen].bounds;
}

+(SystemLanguageType)getSystemLanguageType{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defaults objectForKey:@"AppleLanguages"];
    NSString* currentLanguage = [languages objectAtIndex:0];
    _Log(@"currentLanguage=%@",currentLanguage);
    if([currentLanguage isEqualToString:@"en"]){
        return SystemLanguage_English;
    }else if([currentLanguage isEqualToString:@"zh-Hans"]){
        return SystemLanguage_ChineseSimplified;
    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
        return SystemLanguage_ChineseTraditional;
    }else if([currentLanguage isEqualToString:@"ja"]){
        return SystemLanguage_Japanese;
    }else{
        return SystemLanguage_UNKNOWN;
    }
}


#pragma mark - 身份证识别
+(BOOL)checkIdentityCardNo:(NSString*)cardNo
{
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}
#pragma mark -
#pragma mark net


//
+(NSString *)URLEscape:(NSString *)string
{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)string,
                                                                                 NULL,
                                                                                 CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                 kCFStringEncodingUTF8);
}

//
+(NSString *)URLUnEscape:(NSString *)string
{
    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)string,CFSTR(""),kCFStringEncodingUTF8);
}



#pragma mark -
#pragma mark ui

+(UIBarButtonItem*)getNavBackButtonItemIn:(id)target action:(SEL)sel{
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:(UIBarButtonItemStylePlain) target:target action:sel];
    [backItem setTintColor:[UIColor whiteColor]];
    return backItem;
}

+(UIBarButtonItem*)getNavBackButtonItemIn:(id)target{
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:(UIBarButtonItemStylePlain) target:target action:@selector(onBackItem:)];
    [backItem setTintColor:[UIColor whiteColor]];
    return backItem;
}

+(UILabel*)getNavBarTitleAs:(NSString*)title inViewController:(UIViewController*)target{
    UILabel * _TitleLabel = [[UILabel alloc]initWithFrame:(CGRectMake(100, 40, 100, 30))];
    [_TitleLabel setCenter:(CGPointMake(target.view.frame.size.width/2, 40))];
    [_TitleLabel setTextColor:[UIColor whiteColor]];
    _TitleLabel.text = title;//self.tabBarItem.title;
    [_TitleLabel setFont:[CommonUtil getTitleBarFont]];
    [_TitleLabel setTextAlignment:(NSTextAlignmentCenter)];
    
    [target.navigationItem setTitleView:_TitleLabel];
    
    return _TitleLabel;
}

+(UIImage*)getPureColorImage:(UIColor*)color size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(UIColor *)getTitleBarBackgroundColor{
    return [UIColor colorWithRed:255/255.0 green:105/255.0 blue:180/255.0 alpha:1.0];
}

+(UIFont *)getTitleBarFont{
    return [UIFont systemFontOfSize:20];
}

+(UIColor *)getTableBackgroundColor{
    return [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
}
+(UIColor *)getTableCellBackgroundColor{
    return [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
}

+(UIColor *)getViewBackgroundColor{
    return [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
}

+(UIBarButtonItem*)getNavSearchButtonItemIn:(id)target action:(SEL)sel{
    UIBarButtonItem * searchItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"barSearchIcon"] style:(UIBarButtonItemStylePlain) target:target action:sel];
    [searchItem setTintColor:[UIColor whiteColor]];
    return searchItem;
}

+(UIColor *)getSegmentBackgroundColor{
    return [UIColor colorWithRed:205/255.0 green:92/255.0 blue:92/255.0 alpha:1.0];
}
+(UIColor *)getSegmentFrontColor{
    return [UIColor whiteColor];
}


+(UIAlertView*)showOneButtonAlertWithTitle:(NSString*)title withContent:(NSString*)message withDelegate:(id)delegate{
    UIAlertView * av=[[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:NSLocalizedString(@"_OneButtonAlert_Button", @"OK") otherButtonTitles: nil];
    [av show];
    return av;
}

+(UIAlertView*)showConfirmAlertWithTitle:(NSString*)title withContent:(NSString*)message withTag:(NSInteger)tag withDelegate:(id)delegate{
    UIAlertView * av=[[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:NSLocalizedString(@"_ConfirmAlert_CancelButton", @"取消") otherButtonTitles:NSLocalizedString(@"_ConfirmAlert_ConfirmButton", @"确认"), nil];
    [av setTag:tag];
    [av show];
    return av;
    
    
}


+(UIToolbar*)getInputAccessoryToolBarForEndInputing:(id)target action:(SEL)action{
    //定义一个toolBar
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    //[topView setBarTintColor:([UIColor blueColor])];
    
    //设置style
    [topView setBarStyle:UIBarStyleDefault];
    
    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
    UIBarButtonItem * button1 =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * button2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    //定义完成按钮
    UIBarButtonItem * doneButton =
    //[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"_InputAccessoryToolBar_EndInputing", @"完成") style:UIBarButtonItemStyleDone  target:target action:action];
    [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemDone) target:target action:action];
    [doneButton setTintColor:([UIColor blackColor])];
    
    //在toolBar上加上这些按钮
    NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
    [topView setItems:buttonsArray];
    //    [textView setInputView:topView];
    //[textView setInputAccessoryView:topView];
    
    return topView;
}


#pragma mark -
#pragma mark string

+(NSString*)timeIntervalDescription:(NSTimeInterval)timeInterval{
    NSInteger t=(NSInteger)timeInterval;
    NSInteger days=t/(3600*24);
    NSInteger hours=(t % (3600*24))/3600;
    NSInteger minutes=(t%3600)/60;
    NSInteger seconds=t%60;
    
    NSMutableString * s=[[NSMutableString alloc]init];
    
    if(days>0){
        [s appendFormat:@"%ld%@",days,NSLocalizedString(@"day", @"天")];
    }
    if(hours>0){
        [s appendFormat:@"%ld%@",hours,NSLocalizedString(@"hour", @"小时")];
    }
    if(minutes>0){
        [s appendFormat:@"%ld%@",minutes,NSLocalizedString(@"minute", @"分钟")];
    }
    if(seconds>0){
        [s appendFormat:@"%ld%@",seconds,NSLocalizedString(@"second", @"秒")];
    }
    
    return s;
}

/**
 format: @"yyyy'-'MM'-'dd HH':'mm':'ss";
 **/
+(NSString*)stringOfDate:(NSDate*)date inFormat:(NSString*)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    return [dateFormatter stringFromDate:date];
}

+(NSDate*)dateOfString:(NSString*)string inFormat:(NSString*)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    return [dateFormatter dateFromString:string];
}

+(CGFloat)getTextWidth:(NSString*)text withFontSize:(CGFloat)fontSize{
    CGRect rect=[text  boundingRectWithSize:CGSizeMake(120, 1000) options:(NSStringDrawingUsesLineFragmentOrigin)
                                 attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil]  context:nil];
    float w=rect.size.width;
    
    _Log(@"widthFor[%@]= %f",text,w);
    
    return w+10;

}

+(CGFloat)getTextHeight:(NSString*)text useWidth:(CGFloat)textWidth{
//    CGFloat textWidth=self.view.frame.size.width-20;
    CGRect rect=[text  boundingRectWithSize:CGSizeMake(textWidth, 1000) options:(NSStringDrawingUsesLineFragmentOrigin)
                                 attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:20],NSFontAttributeName, nil]  context:nil];
    float h=rect.size.height;
    
    _Log(@"heightFor[%@]= %f",text,h);
    
    return h;
}
+(CGFloat)getTextHeight:(NSString*)text useWidth:(CGFloat)textWidth withFontSize:(CGFloat)fontSize{
    //    CGFloat textWidth=self.view.frame.size.width-20;
    if(text){
        CGRect rect=[text  boundingRectWithSize:CGSizeMake(textWidth, 1000) options:(NSStringDrawingUsesLineFragmentOrigin)
                                     attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil]  context:nil];
        float h=rect.size.height;
        
        _Log(@"heightFor[%@]= %f",text,h);
        
        return h;
    }else{
        return 0;
    }
}

@end


@implementation UIViewController (neiruVCUI)

-(void)setStandardNavigationBarColor{
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[CommonUtil getPureColorImage:[CommonUtil getTitleBarBackgroundColor]size:(CGSizeMake(self.view.frame.size.width, 80))]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    
    [navigationBar setShadowImage:[UIImage new]];
}


-(void)startWait{
    [self.view startWaitWithBlock:YES forFullView:NO];
}
-(void)startFullWait{
    [self.view startWaitWithBlock:YES forFullView:YES];
}

-(void)startWaitWithBlock:(BOOL)block forFullView:(BOOL)fullView{
    [self.view startWaitWithBlock:block forFullView:fullView];
}

-(void)stopWait{
    [self.view stopWait];
}

@end

@implementation UIView (waiting)

-(void)showSinriToastInfoOnWindow:(NSString*)info{
    [[UIApplication sharedApplication].delegate.window showSinriToastInfo:info];
}

-(void)showSinriToastInfo:(NSString*)info{
    static NSInteger toastBoardTag=22222;
    static NSInteger toastLabelTag=33333;
    
    static NSTimeInterval toastShowingSeconds = 8;
    
    UIWindow * window=[[UIApplication sharedApplication]delegate].window;
    
    CGFloat boardWidth=self.frame.size.width*2/3;
    CGFloat boardHeight=[CommonUtil getTextHeight:info useWidth:boardWidth-20 withFontSize:15]+20;
    
    UIView * toastBoard=[window viewWithTag:toastBoardTag];
    UILabel * toastLabel=(UILabel*)[window viewWithTag:toastLabelTag];
    
    if(toastLabel){
        [toastLabel removeFromSuperview];
    }
    if(toastBoard){
        [toastBoard removeFromSuperview];
    }
    
    toastBoard=[[UIView alloc]initWithFrame:(CGRectMake(self.frame.size.width/2-boardWidth/2, self.frame.size.height/2-boardHeight/2, boardWidth, boardHeight))];
    toastLabel=[[UILabel alloc]initWithFrame:(CGRectMake(10, 10, boardWidth-20, boardHeight-20))];
    
    [toastBoard setBackgroundColor:([UIColor colorWithWhite:0 alpha:0.8])];
    toastBoard.layer.cornerRadius=10;
    toastBoard.layer.masksToBounds=YES;
    [toastBoard setTag:toastBoardTag];
    
    [toastLabel setText:info];
    [toastLabel setTextAlignment:(NSTextAlignmentCenter)];
    [toastLabel setTextColor:([UIColor whiteColor])];
    [toastLabel setFont:([UIFont systemFontOfSize:15])];
    [toastLabel setNumberOfLines:0];
    [toastLabel setLineBreakMode:(NSLineBreakByWordWrapping)];
    [toastLabel setTag:toastLabelTag];
    
    [toastBoard addSubview:toastLabel];
    [self addSubview:toastBoard];
    
    [toastBoard setAlpha:0];
    
    [UIView animateWithDuration:0.5 animations:^{
        _LogLine();
        [toastBoard setAlpha:1.0];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:toastShowingSeconds animations:^{
            _LogLine();
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1 animations:^{
                _LogLine();
                [toastBoard setAlpha:0];
            } completion:^(BOOL finished) {
                _LogLine();
                [toastBoard removeFromSuperview];
            }];
        }];
    }];
}

+(BOOL)SINRI_UIVIEW_WAITING_USE_CUSTOMIZED_ANIMATION{
    //return YES;//WHEN USE ANIMATION IMAGE SERIALS
    return NO;
}

+(NSInteger)SINRI_UIVIEW_WAITING_WaitingAnimationView_TAG{
    return 444401;
}

+(NSInteger)SINRI_UIVIEW_WAITING_UIActivityIndicatorView_TAG{
    return 444401;
}

+(NSInteger)SINRI_UIVIEW_WAITING_UIView_TAG{
    return 444402;
}


-(void)startWait{
    [self startWaitWithBlock:YES forFullView:NO];
}
-(void)startFullWait{
    [self startWaitWithBlock:YES forFullView:YES];
}

-(void)startWaitWithBlock:(BOOL)block forFullView:(BOOL)fullView{
    if([UIView SINRI_UIVIEW_WAITING_USE_CUSTOMIZED_ANIMATION]){
        WaitingAnimationView * _waitingAI=(WaitingAnimationView*)[self viewWithTag:[UIView SINRI_UIVIEW_WAITING_WaitingAnimationView_TAG]];
        UIView * _waitingAIBoard=(UIView*)[self viewWithTag:[UIView SINRI_UIVIEW_WAITING_UIView_TAG]];
        
        if(_waitingAI){
            [_waitingAI removeFromSuperview];
        }
        if(_waitingAIBoard){
            [_waitingAIBoard removeFromSuperview];
        }
        
        _waitingAIBoard=[[UIView alloc]initWithFrame:(CGRectMake(0, 0, 100, 100))];
        [_waitingAIBoard setCenter:(CGPointMake(self.frame.size.width/2, self.frame.size.height/2))];
        [_waitingAIBoard setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:.8]];
        _waitingAIBoard.layer.cornerRadius=10;
        _waitingAIBoard.layer.masksToBounds=YES;
        [_waitingAIBoard setTag:[UIView SINRI_UIVIEW_WAITING_UIView_TAG]];
        [self addSubview:_waitingAIBoard];
        
        _waitingAI = [[WaitingAnimationView alloc]init];
        [_waitingAI setTag:[UIView SINRI_UIVIEW_WAITING_WaitingAnimationView_TAG]];
        [_waitingAIBoard addSubview:_waitingAI];
        
        
        if(fullView){
            [_waitingAIBoard setFrame:(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))];
            [_waitingAIBoard setBackgroundColor:[CommonUtil getViewBackgroundColor]];
            
            //[_waitingAI setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyleGray)];
        }
        
        [_waitingAI setCenter:CGPointMake(_waitingAIBoard.frame.size.width/2, _waitingAIBoard.frame.size.height/2)];
        
        [_waitingAI startAnimating];
        [self setUserInteractionEnabled:!block];
    }else{
        
        UIActivityIndicatorView * _waitingAI=(UIActivityIndicatorView*)[self viewWithTag:[UIView SINRI_UIVIEW_WAITING_UIActivityIndicatorView_TAG]];
        UIView * _waitingAIBoard=(UIView*)[self viewWithTag:[UIView SINRI_UIVIEW_WAITING_UIView_TAG]];
        
        if(_waitingAI){
            [_waitingAI removeFromSuperview];
        }
        if(_waitingAIBoard){
            [_waitingAIBoard removeFromSuperview];
        }
        
        _waitingAIBoard=[[UIView alloc]initWithFrame:(CGRectMake(0, 0, 100, 100))];
        [_waitingAIBoard setCenter:(CGPointMake(self.frame.size.width/2, self.frame.size.height/2))];
        [_waitingAIBoard setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:.8]];
        _waitingAIBoard.layer.cornerRadius=10;
        _waitingAIBoard.layer.masksToBounds=YES;
        [_waitingAIBoard setTag:[UIView SINRI_UIVIEW_WAITING_UIView_TAG]];
        [self addSubview:_waitingAIBoard];
        
        _waitingAI = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
        [_waitingAI setTag:[UIView SINRI_UIVIEW_WAITING_UIActivityIndicatorView_TAG]];
        [_waitingAIBoard addSubview:_waitingAI];
        
        
        if(fullView){
            [_waitingAIBoard setFrame:(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))];
            [_waitingAIBoard setBackgroundColor:[CommonUtil getViewBackgroundColor]];
            
            [_waitingAI setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyleGray)];
        }
        
        [_waitingAI setCenter:CGPointMake(_waitingAIBoard.frame.size.width/2, _waitingAIBoard.frame.size.height/2)];
        
        [_waitingAI startAnimating];
        [self setUserInteractionEnabled:!block];
    }
}

-(void)stopWait{
    UIActivityIndicatorView * _waitingAI=(UIActivityIndicatorView*)[self viewWithTag:[UIView SINRI_UIVIEW_WAITING_UIActivityIndicatorView_TAG]];
    UIView * _waitingAIBoard=(UIView*)[self viewWithTag:[UIView SINRI_UIVIEW_WAITING_UIView_TAG]];
    
    if(_waitingAI){
        [_waitingAI removeFromSuperview];
        [_waitingAI stopAnimating];
    }
    if(_waitingAIBoard){
        [_waitingAIBoard removeFromSuperview];
    }
    [self setUserInteractionEnabled:YES];
}

@end


@implementation UIView (makeCall)

+(NSInteger)SINRI_UIVIEW_MAKECALL_WEBVIEW_TAG{
    return 10086000;
}

-(void)makeCall:(NSString*)tel{
    UIWebView * callWebView=(UIWebView*)[self viewWithTag:[UIView SINRI_UIVIEW_MAKECALL_WEBVIEW_TAG]];
    
    if (callWebView == nil) {
        [callWebView removeFromSuperview];
        callWebView=nil;
    }
    callWebView=[[UIWebView alloc] init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tel]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [callWebView loadRequest:request];
    [self addSubview:callWebView];
}



@end
