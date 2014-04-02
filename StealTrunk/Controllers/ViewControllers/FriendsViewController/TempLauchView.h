//
//  TempLauchView.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-10.
//
//

#import <UIKit/UIKit.h>

@interface TempLauchView : UIView

@property (nonatomic, strong) IBOutlet UIButton *handelSquaredBtn;
@property (nonatomic, strong) IBOutlet UIView *squaredView;

//触发squaredView显示/隐藏 的按钮
- (IBAction)handelSquaredBtnPress:(id)sender;

//隐藏squaredView
- (IBAction)dismissSquaredBtnPress:(id)sender;

///////////////////////////////////////////////////////////////////////////////////////////////

//好友
- (IBAction)friendsBtnPress:(id)sender;

//附近
- (IBAction)nearbyBtnPress:(id)sender;

///////////////////////////////////////////////////////////////////////////////////////////////

//消息
- (IBAction)messageBtnPress:(id)sender;

//奖励
- (IBAction)rewardBtnPress:(id)sender;

//排行榜
- (IBAction)rankBtnPress:(id)sender;

//商店
- (IBAction)storeBtnPress:(id)sender;

//仓库
- (IBAction)storageBtnPress:(id)sender;

//装饰
- (IBAction)dressBtnPress:(id)sender;

//我的空间
- (IBAction)myZoneBtnPress:(id)sender;

//我的部落
- (IBAction)myTribeBtnPress:(id)sender;

//设置
- (IBAction)settingBtnPress:(id)sender;




@end
