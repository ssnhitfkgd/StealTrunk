//
//  RecommendView.m
//  StealTrunk
//
//  Created by yong wang on 13-4-24.
//  Copyright (c) 2013年 StealTrunk. All rights reserved.
//

#import "RecommendView.h"

@implementation RecommendView
@synthesize avatarImageView = _avatarImageView;
@synthesize textLabel = _textLabel;
@synthesize detailLabel = _detailLabel;
@synthesize followButton = _followButton;
@synthesize recommentDTO = _recommentDTO;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createUI];
    }
    return self;
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return 55.;
}

- (void)setObject:(id)item 
{
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        self.recommentDTO = [[RecommentDTO alloc] init];
        if([_recommentDTO parse2:item])
        {
            [self.avatarImageView setUserInfo:self.recommentDTO.userInfo EnableTap:YES];
            [_textLabel setText: _recommentDTO.userInfo.user_name];
            [_detailLabel setText: _recommentDTO.userInfo.user_sign];
            
            [_followButton setBackgroundImage:[UIImage imageNamed:_recommentDTO.attended? @"btn_followed_background":@"btn_follow_background"] forState:UIControlStateNormal];
            [_followButton setImage:[UIImage imageNamed:_recommentDTO.attended?@"cell_did_add":@"cell_add"] forState:UIControlStateNormal];

        }
    }
}

- (void)createUI
{
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 53, 320, 1)];
    UIImage *image = [UIImage imageNamed:@"sperateLine"];
    [lineImageView setImage:[image stretchableImageWithLeftCapWidth:1 topCapHeight:0]];
    [self addSubview:lineImageView];

    self.avatarImageView = [KKAvatarView creatWithSize:35];
    self.avatarImageView.left = 7;
    self.avatarImageView.top = 9;
    [self addSubview:_avatarImageView];
       
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.right + 10, 0, 150, 20)];
    _textLabel.top = _avatarImageView.top;
    [_textLabel setTextAlignment:UITextAlignmentLeft];
    [_textLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [_textLabel setBackgroundColor:[UIColor clearColor]];
    [_textLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
    [_textLabel setTextColor:[UIColor colorWithRed:30./255. green:30./255. blue:30./255. alpha:1.0]];
    _textLabel.font=[UIFont systemFontOfSize:14];
    [_textLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapped:)]];
    [self addSubview:_textLabel];
    
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.right + 10, _avatarImageView.bottom - 10, 150, 10)];
    [_detailLabel setTextAlignment:NSTextAlignmentLeft];
    [_detailLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
    [_detailLabel setBackgroundColor:[UIColor clearColor]];
    [_detailLabel setText:@""];
    [_detailLabel setTextColor:[UIColor colorWithRed:131./255. green:131./255. blue:131./255. alpha:1.0]];
    _detailLabel.font = [UIFont systemFontOfSize:10];
    [_detailLabel setAdjustsFontSizeToFitWidth:YES];
    [self addSubview:_detailLabel];
    
    self.followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_followButton setFrame:CGRectMake(260, 12, 50, 31)];
    [_followButton setUserInteractionEnabled:YES];
    [_followButton addTarget:self action:@selector(followTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_followButton setImage:[UIImage imageNamed:@"cell_add"] forState:UIControlStateNormal];
    [_followButton setBackgroundImage:[UIImage imageNamed:@"btn_follow_background"] forState:UIControlStateNormal];
    [_followButton setBackgroundImage:[UIImage imageNamed:@"btn_followed_background"] forState:UIControlStateHighlighted];
    [self addSubview:_followButton];
}

- (void)followTapped:(id)sender
{
    
    [_recommentDTO.dtoResult setObject:[NSString stringWithFormat:@"%d",_recommentDTO.attended] forKey:@"attended"];
}

- (void)followDidFinished:(id)item
{
    
}

- (void)unfollowDidFinished:(id)item
{
    
}

- (void)followDidFailed:(id)item
{
    
}

- (void)unfollowDidFailed:(id)item
{
    
}

- (void)avatarTapped:(UITapGestureRecognizer *)tapGesture
{
}


@end
