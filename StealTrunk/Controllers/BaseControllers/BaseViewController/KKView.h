//
//  KKView.h
//  StealTrunk
//
//  Created by 点兄 on 13-8-8.
//
//

#import <UIKit/UIKit.h>

@class StampDTO;
@protocol NameCardViewControllerDelegate;

@interface KKAvatarView : UIView<NameCardViewControllerDelegate>

@property (nonatomic, strong) StampDTO *stampDTO;

+ (KKAvatarView *)creatWithSize:(NSInteger)size;

- (void)setUserInfo:(Monstea_user_info *)userInfo EnableTap:(BOOL)enable;
- (void)setStampInfo:(StampDTO *)stampDTO;

@end
