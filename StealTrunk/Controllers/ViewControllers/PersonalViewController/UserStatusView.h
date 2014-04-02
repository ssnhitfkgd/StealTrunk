//
//  UserStatusView.h
//  StealTrunk
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2013年 StealTrunk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "RTLabel.h"
#import "UserStatusInfoDto.h"
#import "NCMusicEngine.h"

@protocol StatusStampPopupViewDelegate;

//盖章：展示
@interface StatusStampView : UIView<StatusStampPopupViewDelegate>

@end

//盖章：弹层
@protocol StatusStampPopupViewDelegate <NSObject>

@required
- (void)stampSelected:(NSString *)stamptype;

@end

@interface StatusStampPopupView : UIView

@property (nonatomic, assign) id<StatusStampPopupViewDelegate>delegate;

- (void)showInView:(UIView *)view WithPoint:(CGPoint)point;
- (void)dismiss;

@end

////////////////////////////////////////////////////////////////////////////////

@interface UserStatusCommonView : BaseView<NCMusicEngineDelegate>

@end

////////////////////////////////////////////////////////////////////////////////

@interface UserStatusListView : BaseView<UIActionSheetDelegate, UIAlertViewDelegate, RTLabelDelegate>

+ (CGFloat)rowHeightForObject:(id)item;
- (void)setObject:(id)item;
- (void)createSubview;

@end

////////////////////////////////////////////////////////////////////////////////

@interface UserStatusDetailView : BaseView

- (void)setObject:(id)item;

@end