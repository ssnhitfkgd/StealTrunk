//
//  settingViewController.h
//  StealTrunk
//
//  Created by wangyong on 13-7-19.
//
//

#import "JMStaticContentTableViewController.h"

@interface SettingViewController : JMStaticContentTableViewController
{
    NSMutableDictionary *settingDict;
}

@property (nonatomic, assign) BOOL music;
@property (nonatomic, assign) BOOL effect;
@property (nonatomic, assign) BOOL like_auto_sns;
@property (nonatomic, assign) BOOL comment_auto_sns;
@property (nonatomic, assign) BOOL night_alone;
@property (nonatomic, assign) BOOL new_msg;
@property (nonatomic, assign) BOOL friend_invite;
@property (nonatomic, assign) BOOL chat;
+ (id)sharedInstance;
@end
