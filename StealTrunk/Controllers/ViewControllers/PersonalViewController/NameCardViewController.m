//
//  NameCardViewController.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-21.
//
//

#import "NameCardViewController.h"
#import "NTParallaxStackController.h"
#import "AccountDTO.h"
#import "FileClient.h"
#import "GRAlertView.h"
#import "PersonalViewController.h"
#import "PersonalSettingViewController.h"

#define Multiple 1.2
@implementation CardView

@synthesize photoWallView = _photoWallView;
@synthesize parallaxSC = _parallaxSC;
@synthesize userAvatar = _userAvatar;
@synthesize userName = _userName;
@synthesize backMask = _backMask;
@synthesize userInfo = _userInfo;
@synthesize settingBtn = _settingBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor redColor];
        self.clipsToBounds = YES;
        
        self.parallaxSC = [[NTParallaxStackController alloc] init];
        [self addSubview:self.parallaxSC.view];
        
        self.photoWallView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width*Multiple, self.height*Multiple)];
        self.photoWallView.backgroundColor = [UIColor blackColor];
        self.photoWallView.centerX = self.width/2;
        self.photoWallView.centerY = self.height/2;
        
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.photoWallView.width/3, self.photoWallView.height/3)];
                photo.contentMode = UIViewContentModeScaleAspectFill;
                photo.clipsToBounds = YES;
                
                //序列
                int photo_index = 3*i+j;
                photo.tag = 1000+photo_index;
                
                //坐标
                CGFloat centerX = self.photoWallView.bounds.size.width/2;
                CGFloat centerY = self.photoWallView.bounds.size.height/2;
                
                photo.centerX = centerX + (j-1)*photo.width;
                photo.centerY = centerY + (i-1)*photo.width;
                
                [self.photoWallView addSubview:photo];
            }
        }
        
        self.backMask = [[UIView alloc] initWithFrame:self.bounds];
        self.backMask.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        
        self.userAvatar = [KKAvatarView creatWithSize:70];
        self.userAvatar.centerX = self.photoWallView.centerX;
        self.userAvatar.centerY = self.photoWallView.centerY-45;
        self.userAvatar.layer.cornerRadius = self.userAvatar.width/2;
        self.userAvatar.clipsToBounds = YES;
        
        self.userName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 25)];
        self.userName.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.6];
        self.userName.top = self.userAvatar.bottom + 20;
        self.userName.textAlignment = UITextAlignmentCenter;
        self.userName.textColor = [UIColor whiteColor];
        
        self.settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.settingBtn.backgroundColor = [UIColor purpleColor];
        [self.settingBtn setTitle:@"设置" forState:UIControlStateNormal];
        self.settingBtn.frame = CGRectMake(10, 10, 60, 44);
        [self.settingBtn addTarget:self action:@selector(settingBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        self.settingBtn.hidden = YES;
        
        [self.backMask addSubview:self.userAvatar];
        [self.backMask addSubview:self.userName];
        [self.backMask addSubview:self.settingBtn];
        
        [self.parallaxSC addLayerToPStack:_photoWallView motionRange:150 origin:self.photoWallView.frame.origin];
        [self.parallaxSC addLayerToPStack:_backMask motionRange:0 origin:self.backMask.frame.origin];
    }
    return self;
}

- (void)setItem:(Monstea_user_info *)userInfo
{
    if (userInfo) {
        self.userInfo = userInfo;
        
        self.userName.text = userInfo.user_name;
        
        [self.userAvatar setUserInfo:self.userInfo EnableTap:NO];
        
        if (userInfo.photos && userInfo.photos.count > 0) {
            for (int i=0; i<userInfo.photos.count; i++) {
                NSDictionary *photoDic = [userInfo.photos objectAtIndex:i];
                int photoIndex = [[photoDic objectForKey:@"id"] intValue];
                UIImageView *photo = (UIImageView *)[self viewWithTag:1000+(photoIndex-1)];
                
                [photo setImageWithURL:[NSURL URLWithString:[photoDic objectForKey:@"url"]]];
            }
        }
        
        if ([self.userInfo.user_id isEqualToString:[[AccountDTO sharedInstance] monstea_user_info].user_id]) {
            self.settingBtn.hidden = NO;
        }
    }
}

- (void)settingBtnPress:(id)sender
{
    PersonalSettingViewController *psVC = [[PersonalSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    [self.viewController.navigationController pushViewController:psVC animated:NO];
}

#pragma mark - Delegates

- (void)startDeviceMotion
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NT_resetFrame" object:nil];
}

- (void)stopDeviceMotion
{
    
}

@end

////////////////////////////////////////////////////////////////////////
@interface NameCardViewController ()

@property (nonatomic, strong) UIButton *addFriendBtn;
@property (nonatomic, strong) UIButton *chatBtn;
@property (nonatomic, strong) UIButton *addBlockBtn;
@property (nonatomic, strong) UIButton *giftBtn;
@property (nonatomic, strong) UIButton *farmBtn;
@property (nonatomic, strong) UIButton *zoneBtn;

@property (nonatomic, strong) Monstea_user_info *userInfo;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, assign) BOOL isPopup;

- (void)addFriendBtnPress:(id)sender;
- (void)chatBtnPress:(id)sender;
- (void)addBlockBtnPress:(id)sender;
- (void)giftBtnPress:(id)sender;
- (void)farmBtnPress:(id)sender;
- (void)zoneBtnPress:(id)sender;

@end

@implementation NameCardViewController
@synthesize cardView = _cardView;

@synthesize addFriendBtn = _addFriendBtn;
@synthesize chatBtn = _chatBtn;
@synthesize addBlockBtn = _addBlockBtn;
@synthesize giftBtn = _giftBtn;
@synthesize farmBtn = _farmBtn;
@synthesize zoneBtn = _zoneBtn;

@synthesize userInfo = _userInfo;
@synthesize userID = _userID;
@synthesize isPopup = _isPopup;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.cardView startDeviceMotion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithUserID:(NSString *)user_id Popup:(BOOL)is_popup
{
    self = [super init];
    
    if (self) {
        self.userID = user_id;
        self.isPopup = is_popup;
        
        self.view.frame = self.isPopup?CGRectMake(0, 0, 260, 260+88):CGRectMake(0, 0, 320, 320);
        self.view.backgroundColor = [UIColor purpleColor];
        
        self.cardView = [[CardView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width)];
        
        UIView *btnsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 88)];
        btnsView.clipsToBounds = YES;
        btnsView.backgroundColor = [UIColor lightGrayColor];
        btnsView.top = self.cardView.bottom;
        
        if (![self.userID isEqualToString:[[AccountDTO sharedInstance] monstea_user_info].user_id]) {
            self.addFriendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.addFriendBtn.backgroundColor = [UIColor purpleColor];
            [self.addFriendBtn setTitle:@"+" forState:UIControlStateNormal];
            [self.addFriendBtn setTitle:@"chat" forState:UIControlStateSelected];
            [self.addFriendBtn addTarget:self action:@selector(addFriendBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            self.addFriendBtn.frame = CGRectMake(30, 5, 35, 35);
            
            self.giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.giftBtn.backgroundColor = [UIColor purpleColor];
            [self.giftBtn setTitle:@"Gift" forState:UIControlStateNormal];
            [self.giftBtn addTarget:self action:@selector(giftBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            self.giftBtn.frame = self.addFriendBtn.frame;
            self.giftBtn.centerX = self.view.width/2;
            
            self.addBlockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.addBlockBtn.backgroundColor = [UIColor purpleColor];
            [self.addBlockBtn setTitle:@"-" forState:UIControlStateNormal];
            [self.addBlockBtn setTitle:@"unblock" forState:UIControlStateSelected];
            [self.addBlockBtn addTarget:self action:@selector(addBlockBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            self.addBlockBtn.frame = self.addFriendBtn.frame;
            self.addBlockBtn.right = self.view.width-30;
            
            self.farmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.farmBtn.backgroundColor = [UIColor yellowColor];
            [self.farmBtn setTitle:@"农场" forState:UIControlStateNormal];
            [self.farmBtn addTarget:self action:@selector(farmBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            self.farmBtn.frame = CGRectMake(0, 0, self.view.width/2, 44);
            self.farmBtn.top = self.addFriendBtn.bottom + 4;
            
            self.zoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.zoneBtn.backgroundColor = [UIColor redColor];
            [self.zoneBtn setTitle:@"空间" forState:UIControlStateNormal];
            [self.zoneBtn addTarget:self action:@selector(zoneBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            self.zoneBtn.frame = self.farmBtn.frame;
            self.zoneBtn.left = self.farmBtn.right;
            
            [btnsView addSubview:self.addFriendBtn];
            [btnsView addSubview:self.giftBtn];
            [btnsView addSubview:self.addBlockBtn];
            [btnsView addSubview:self.farmBtn];
            [btnsView addSubview:self.zoneBtn];
        }else {
            //用户自己的cardView
            btnsView.height = 44;
            self.view.height = 260+btnsView.height;
        }
        
        
        [self.view addSubview:self.cardView];
        [self.view addSubview:btnsView];
        
        
        if ([user_id isEqualToString:[[AccountDTO sharedInstance] monstea_user_info].user_id]) {
            Monstea_user_info *userInfo = [[AccountDTO sharedInstance] monstea_user_info];
            
            [self setItem:userInfo];
        }else{
            //发请求
            [[FileClient sharedInstance] getUserProfileWithUserToken:[[[AccountDTO sharedInstance] session_info] token] userID:self.userID cachePolicy:NSURLRequestUseProtocolCachePolicy delegate:self selector:@selector(getUserProfileRequest:) selectorError:@selector(requestError:)];
        }
    }
    
    return self;
}

+ (NameCardViewController *)creatWithUserID:(NSString *)user_id Popup:(BOOL)is_popup
{
    NameCardViewController *control = [[NameCardViewController alloc] initWithUserID:user_id Popup:is_popup];
    
    return control;
}

- (void)setItem:(Monstea_user_info *)userInfo
{
    self.userInfo = userInfo;
    
    [self.cardView setItem:userInfo];
    
    //设置各按钮状态
    if (self.isPopup) {
        self.cardView.settingBtn.hidden = YES;
    }
    
    if (userInfo.is_friend) {
        self.addFriendBtn.selected = YES;
    }else {
        self.addFriendBtn.selected = NO;
    }
    
    if (userInfo.is_blocked) {
        self.addBlockBtn.selected = YES;
    }else {
        self.addBlockBtn.selected = NO;
    }
}

#pragma mark - Actions
- (void)addFriendBtnPress:(id)sender
{
    if (self.addFriendBtn.selected) {
        //push to chat
        
    }else{
        //发送加好友请求
        [[FileClient sharedInstance] createFriendsRequestWithUserID:self.userID delegate:self selector:@selector(addFriendRequest:) selectorError:@selector(requestError:)];
    }
}

- (void)addBlockBtnPress:(id)sender
{
    if (self.addBlockBtn.selected) {
        GRAlertView *alert = [[GRAlertView alloc] initWithTitle:NSLocalizedString(@"解除拉黑", nil)
                                                        message:NSLocalizedString(@"确定将该用户移出黑名单？", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                              otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
        alert.tag = 1001;
        [alert show];
    }else{
        GRAlertView *alert = [[GRAlertView alloc] initWithTitle:NSLocalizedString(@"拉黑该玩家", nil)
                                                        message:NSLocalizedString(@"以后可前往 设置>黑名单 解除拉黑状态", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                              otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
        alert.tag = 1000;
        [alert show];
    }
}

- (void)giftBtnPress:(id)sender
{
    //API
}

- (void)farmBtnPress:(id)sender
{
    //push to farm
    if ([self.delegate respondsToSelector:@selector(pushToZoneWithUserInfo:)]) {
        [self.delegate pushToZoneWithUserInfo:self.userInfo];
    }
}

- (void)zoneBtnPress:(id)sender
{
    //push to zone
    if ([self.delegate respondsToSelector:@selector(pushToZoneWithUserInfo:)]) {
        [self.delegate pushToZoneWithUserInfo:self.userInfo];
    }
}

#pragma mark - Request result
- (void)getUserProfileRequest:(NSData *)data
{
    id realData = [self requestDidFinishLoad2:data];
    if (realData) {
        Monstea_user_info *userInfo = [[Monstea_user_info alloc] init];
        [userInfo parseWithDic:realData];
        [self setItem:userInfo];
    }
}

- (void)addFriendRequest:(NSData *)data
{
    id realData = [self requestDidFinishLoad2:data];
    if (realData) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"请求已发送", nil)];
        //do something
        
    }
}

- (void)blockRequest:(NSData *)data
{
    id realData = [self requestDidFinishLoad2:data];
    if (realData) {
        if (self.addBlockBtn.selected) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"已解除", nil)];
        }else{
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"已拉黑", nil)];
        }
        
        self.addBlockBtn.selected = !self.addBlockBtn.selected;
    }
}

- (id)requestDidFinishLoad2:(NSData*)data
{
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if(json_string.length > 0){
        id responseObject = [[json_string JSONValue] objectForKey:@"code"];
        if(responseObject && 0 == [responseObject integerValue]){
            //success!
            id realData = [[json_string JSONValue]  objectForKey:@"data"];
            return realData;
            
        }else{
            [self requestError:[[json_string JSONValue]  objectForKey:@"data"]];
        }
    }else{
        [self requestError:@"json is null"];
    }
    
    return nil;
}

- (void)requestError:(NSString *)error {
    if (error) {
        [SVProgressHUD showErrorWithStatus:error];
    }
}

#pragma mark - Delegates
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 1000:
        {
            //拉黑
            if (buttonIndex == 1) {
                [[FileClient sharedInstance] blockFriendsRequestWithUserID:self.userID
                                                                  Delegate:self
                                                                  Selector:@selector(blockRequest:)
                                                             SelectorError:@selector(requestError:)];
                [SVProgressHUD showWithStatus:NSLocalizedString(@"正在处理...", nil)
                                     maskType:SVProgressHUDMaskTypeGradient];
            }
        }
            break;
        case 1001:
        {
            //解除黑名单
            if (buttonIndex == 1) {
                [[FileClient sharedInstance] unBlockFriendsRequestWithUserID:self.userID
                                                                    Delegate:self
                                                                    Selector:@selector(blockRequest:)
                                                               SelectorError:@selector(requestError:)];
                [SVProgressHUD showWithStatus:NSLocalizedString(@"正在处理...", nil)
                                     maskType:SVProgressHUDMaskTypeGradient];
            }
        }
            break;
        default:
            break;
    }
}

@end
