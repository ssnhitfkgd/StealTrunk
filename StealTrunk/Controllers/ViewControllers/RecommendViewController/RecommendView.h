//
//  RecommendView.h
//  StealTrunk
//
//  Created by yong wang on 13-4-24.
//  Copyright (c) 2013年 StealTrunk. All rights reserved.
//

#import "BaseView.h"
#import "RecommentDTO.h"

@interface RecommendView : BaseView


@property(nonatomic, strong) KKAvatarView *avatarImageView;
@property(nonatomic, strong) UILabel *textLabel;
@property(nonatomic, strong) UILabel *detailLabel;
@property(nonatomic, strong) UIButton *followButton;
@property(nonatomic, strong) RecommentDTO *recommentDTO;

+ (CGFloat)rowHeightForObject:(id)item;
- (void)setObject:(id)item;

- (void)createUI;
@end
