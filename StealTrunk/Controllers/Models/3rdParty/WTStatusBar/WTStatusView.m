//
//  WTStatusView.m
//  WTStatusBar
//
//  Created by Alex Skalozub on 3/8/13.
//  Copyright (c) 2013 Alex Skalozub.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "WTStatusView.h"

#define kWTProgressBarHeight 2

@implementation WTStatusView

@synthesize progress = _progress;

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = [UIColor clearColor];
    
    statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 10, 10)];
    [self addSubview:statusImageView];
    
    statusText = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 75, self.height)];
    statusText.textColor = [UIColor colorWithWhite:0.75 alpha:1.0];
    statusText.font = [UIFont systemFontOfSize:12];
    statusText.lineBreakMode = UILineBreakModeTailTruncation;
    [statusText setBackgroundColor:[UIColor clearColor]];
    //[statusText sizeToFit];
    [self addSubview:statusText];
    
    
    
    UIImageView *imageDown = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"statusbar_down"]];
    [imageDown setFrame:CGRectMake(90, 6, 11, 7)];
    [self addSubview:imageDown];
    
    
    progressBar = [[UIView alloc] init];
    progressBar.opaque = YES;
    [self addSubview:progressBar];
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(statusBarTaped:)]];
}

- (void)statusBarTaped:(UITapGestureRecognizer*)tapGestureRecognizer
{
    NSLog(@"status bar cliked");
    
    UIView *keyWindowView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    
    UIView *obj = [keyWindowView viewWithTag:110];
    if(!obj)
    {
        
//        LBUploadManagerController * controller  = [[LBUploadManagerController alloc] init];
//        navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
//        
//        controller.title = @"查看草稿";
//        controller.navigationItem.leftBarButtonItem = nil;
//        controller.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonWithImage:@"statusbar_up" backgroundImage:@"btn_navigationbar_right" target:self action:@selector(back)];
//  
//        [controller.view setTop:(screenSize().height * -1)];
//        navigationController.view.tag = 110;
//        [keyWindowView addSubview:navigationController.view];
//       
//        
//        [UIView animateWithDuration:0.2 animations:^{
//            controller.view.top = 0;
//        }
//                         completion:^(BOOL finished){
//                             controller.view.top = 0;
//                         }];
//    }
    //    else
    //    {
    //        [UIView animateWithDuration:0.8 animations:^{
    //            obj.top = (screenSize().height * -1);
    //        }
    //         completion:^(BOOL finished){
    //             [obj removeFromSuperview];
    //         }];
        }
}

- (void)back
{
    UIView *keyWindowView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    UIView *obj = [keyWindowView viewWithTag:110];
    [UIView animateWithDuration:0.2 animations:^{
        obj.top = (screenSize().height * -1);
    }
                     completion:^(BOOL finished){
                         [obj removeFromSuperview];
                     }];
}

- (void)dealloc
{
    statusText = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //statusText.frame = self.bounds;
    [self setProgress:_progress];
}

- (void)setStatusBarColor:(UIColor *)color
{
    CGFloat windowAlpha = ([[UIApplication sharedApplication] statusBarStyle] == UIStatusBarStyleBlackTranslucent) ? 0.5 : 1.0;
    self.backgroundColor = [color colorWithAlphaComponent:windowAlpha];
}

- (void)setStatusTextColor:(UIColor*)color
{
    statusText.textColor = color;
}

- (void)setProgressBarColor:(UIColor *)color
{
    progressBar.backgroundColor = color;
}

- (void)setStatusText:(NSString *)text
{
    statusText.text = text;
}

- (void)setStatusImage:(UIImage*)statusImage
{
    [statusImageView setImage:statusImage];
}

- (void)setStatusText:(NSString *)text statusImage:(UIImage*)statusImage
{
    statusText.text = text;
    [statusImageView setImage:statusImage];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = MAX(0.0, MIN(1.0, progress));
    progressBar.frame = CGRectMake(0, 0, _progress * CGRectGetWidth(self.bounds), kWTProgressBarHeight);
}

@end
