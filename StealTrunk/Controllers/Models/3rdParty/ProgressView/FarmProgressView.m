//
//  FarmProgressView.m
//  StealTrunk
//
//  Created by wangyong on 13-8-28.
//
//

#import "FarmProgressView.h"

@implementation FarmProgressView

static FarmProgressView *farmProgressView = nil;

+ (FarmProgressView*)shareInstance
{
    if(!farmProgressView)
    {
        farmProgressView = [[FarmProgressView alloc] initWithFrame:CGRectMake(0, 10., screenSize().width, 16)];
    }
    
    return farmProgressView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        experienceProgressView = [[DDProgressView alloc] initWithFrame:CGRectMake(20, 0, 78, 0) withStyle:PROGRESS_STYLE_CIRCLE leftImage:@"experience" rightImage:nil];
        [experienceProgressView setInnerColor: [UIColor colorWithRed:140./255. green:223./255. blue:221./255. alpha:1.0]];
        [experienceProgressView setOuterColor: [UIColor colorWithRed:23./255. green:121./255. blue:191./255. alpha:1.0]] ;
        [self addSubview:experienceProgressView];
        
        powerProgressView = [[DDProgressView alloc] initWithFrame:CGRectMake(experienceProgressView.right + 16, 0, 50, 0) withStyle:PROGRESS_STYLE_RECT leftImage:@"power" rightImage:@"add"];
        [powerProgressView setOuterColor: [UIColor colorWithRed:252./255. green:166./255. blue:41./255. alpha:1.0]] ;
        [powerProgressView setInnerColor: [UIColor colorWithRed:125./255. green:79./255. blue:63./255. alpha:1.0]] ;
        [self addSubview:powerProgressView];

        coinProgressView = [[DDProgressView alloc] initWithFrame:CGRectMake(powerProgressView.right + 20, 0, 50, 0) withStyle:PROGRESS_STYLE_RECT leftImage:@"coin" rightImage:@"add"];
        [coinProgressView setOuterColor: [UIColor colorWithRed:93./255. green:154./255. blue:155./255. alpha:1.0]] ;
        [coinProgressView setInnerColor: [UIColor colorWithRed:93./255. green:154./255. blue:155./255. alpha:1.0]] ;
        [self addSubview:coinProgressView];

        diamondProgressView = [[DDProgressView alloc] initWithFrame:CGRectMake(coinProgressView.right + 20, 0, 50, 0) withStyle:PROGRESS_STYLE_RECT leftImage:@"diamond" rightImage:@"add"];
        [diamondProgressView setOuterColor: [UIColor colorWithRed:93./255. green:154./255. blue:155./255. alpha:1.0]] ;
        [diamondProgressView setInnerColor: [UIColor colorWithRed:93./255. green:154./255. blue:155./255. alpha:1.0]] ;
        [self addSubview:diamondProgressView];
        
        [self setExperienceProgress:0.78];
        [self setPowerProgress:0.66];
    }
    return self;
}

- (void)setExperienceProgress:(CGFloat)progress
{
    [experienceProgressView setProgress:progress];
}

- (void)setPowerProgress:(CGFloat)progress
{
    [powerProgressView setProgress:progress];
}

- (void)setCoinProgress:(CGFloat)progress
{
    [coinProgressView setProgress:progress];
}

- (void)setDiamondProgressView:(CGFloat)progress
{
    [diamondProgressView setProgress:progress];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
