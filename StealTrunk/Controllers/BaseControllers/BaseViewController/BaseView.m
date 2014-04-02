//
//  LBBaseView.m
//  StealTrunk
//
//  Created by King on 13-3-29.
//  Copyright (c) 2013年 StealTrunk. All rights reserved.
//

#import "BaseView.h"
#import "FileClient.h"

@implementation BaseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (int)checkNetWorkWifiOf3G
{
    return [[FileClient sharedInstance] getNetworkingType];
}

- (void)avatarTapped:(id)userDto
{

}

@end
