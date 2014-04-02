//
//  UserStatusView.m
//  StealTrunk
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2013年 StealTrunk. All rights reserved.
//


#import "UserStatusView.h"
#import "TimeAndLocation.h"
#import "NCMusicEngine.h"
#import "UserStatusViewController.h"
#import "FileClient.h"
#import "StampDTO.h"
#import "StampsListViewController.h"

#define HEADER_HEIGHT 52.
#define BOTTOM_HEIGHT 31.
#define CENTER_HEIGHT 185.
#define VIEW_TAG 10.

#define VIEW_WIDTH 300.
#define VIEW_HEIGHT    HEADER_HEIGHT + CENTER_HEIGHT + BOTTOM_HEIGHT + VIEW_TAG

#define STAMP_HEIGHT 60.

#pragma mark -
#pragma mark - StatusStampView
#pragma mark -

@interface StatusStampView()

@property (nonatomic, strong) UserStatusInfoDto *userStatusInfoDto;

@property (nonatomic, strong) UIButton *stampBtn;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) KKAvatarView *stamp1;
@property (nonatomic, strong) KKAvatarView *stamp2;
@property (nonatomic, strong) KKAvatarView *stamp3;
@property (nonatomic, strong) KKAvatarView *stamp4;

@property (nonatomic, strong) UIActivityIndicatorView *act;

- (void)stampBtnPress:(id)sender;
- (void)moreBtnPress:(id)sender;

@end


@implementation StatusStampView

@synthesize userStatusInfoDto = _userStatusInfoDto;

@synthesize stampBtn = _stampBtn;
@synthesize moreBtn = _moreBtn;
@synthesize stamp1 = _stamp1;
@synthesize stamp2 = _stamp2;
@synthesize stamp3 = _stamp3;
@synthesize stamp4 = _stamp4;

@synthesize act = _act;

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 320, STAMP_HEIGHT);
        self.backgroundColor = [UIColor yellowColor];
        
        self.stampBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.stampBtn.frame = CGRectMake(11, 10, 40, 40);
        self.stampBtn.backgroundColor = [UIColor redColor];
        [self.stampBtn addTarget:self action:@selector(stampBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        
        self.act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.act.frame = self.stampBtn.frame;
        self.act.hidesWhenStopped = YES;
        
        self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.moreBtn.frame = CGRectMake(0, 10, 40, 40);
        self.moreBtn.backgroundColor = [UIColor greenColor];
        [self.moreBtn addTarget:self action:@selector(moreBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        self.moreBtn.right = self.width - 11;
        self.moreBtn.enabled = NO;
        
        self.stamp1 = [KKAvatarView creatWithSize:40];
        self.stamp1.top = 10;
        self.stamp1.backgroundColor = [UIColor grayColor];
        
        self.stamp2 = [KKAvatarView creatWithSize:40];
                self.stamp2.top = 10;
        self.stamp2.backgroundColor = [UIColor grayColor];
        
        self.stamp3 = [KKAvatarView creatWithSize:40];
                self.stamp3.top = 10;
        self.stamp3.backgroundColor = [UIColor grayColor];
        
        self.stamp4 = [KKAvatarView creatWithSize:40];
                self.stamp4.top = 10;
        self.stamp4.backgroundColor = [UIColor grayColor];
        
        self.stamp1.left = self.stampBtn.right+11.5;
        self.stamp2.left = self.stamp1.right+11.5;
        self.stamp3.left = self.stamp2.right+11.5;
        self.stamp4.left = self.stamp3.right+11.5;
        
        [self addSubview:self.stampBtn];
        [self addSubview:self.act];
        [self addSubview:self.moreBtn];
        [self addSubview:self.stamp1];
        [self addSubview:self.stamp2];
        [self addSubview:self.stamp3];
        [self addSubview:self.stamp4];
    }
    return self;
}

- (void)stampBtnPress:(id)sender
{
    StatusStampPopupView *stampPopup = [[StatusStampPopupView alloc] init];
    stampPopup.delegate = self;
    
    CGPoint rawPoint = CGPointMake(self.stampBtn.centerX, self.stampBtn.bottom+5);
    CGPoint convertPoint = [self convertPoint:rawPoint toView:self.viewController.view];
    
    [stampPopup showInView:self.viewController.view WithPoint:convertPoint];
    
}

- (void)moreBtnPress:(id)sender
{
    StampsListViewController *stampListVC = [[StampsListViewController alloc] init];
    stampListVC.DTO = self.userStatusInfoDto;
    [self.viewController.navigationController pushViewController:stampListVC animated:YES];
}

- (void)setObject:(UserStatusInfoDto *)DTO{
    self.userStatusInfoDto = DTO;
    
    [self.act startAnimating];
    
    [[FileClient sharedInstance] listUserStatusLikeWithUserToken:[[AccountDTO sharedInstance] session_info].token statusID:self.userStatusInfoDto.status_id pageSize:pageCount offsetID:@"0" cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData delegate:self selector:@selector(statusLikeListRequestEnd:) selectorError:@selector(requestError2:)];
}

#pragma mark - Delegate
- (void)stampSelected:(NSString *)stamptype
{
    //request
    [[FileClient sharedInstance] markUserStatusLikeWithStatusID:self.userStatusInfoDto.status_id
                                                       likeType:stamptype
                                                       delegate:self
                                                       selector:@selector(stampRequestEnd:)
                                                  selectorError:@selector(requestError2:)];
}

#pragma mark - Request

- (void)stampRequestEnd:(NSData *)data
{
    id realdata = [self requestDidFinishLoad2:data];
    if (realdata) {
        //success! & reload data
        [self setObject:self.userStatusInfoDto];
    }
}

- (void)statusLikeListRequestEnd:(NSData *)data
{
    [self.act stopAnimating];
    
    id realdata = [self requestDidFinishLoad2:data];
    
    if (realdata) {
        //set objects
        NSArray *stamps = [NSArray arrayWithArray:[realdata objectForKey:@"list"]];
        
        if (stamps && stamps.count>0) {
            StampDTO *stampDTO0 = [[StampDTO alloc] init];
            [stampDTO0 parse2:[stamps objectAtIndex:0]];
            [self.stamp1 setStampInfo:stampDTO0];
            
            if (stamps.count>1) {
                StampDTO *stampDTO1 = [[StampDTO alloc] init];
                [stampDTO1 parse2:[stamps objectAtIndex:1]];
                [self.stamp2 setStampInfo:stampDTO1];
                
                if (stamps.count>2) {
                    StampDTO *stampDTO2 = [[StampDTO alloc] init];
                    [stampDTO2 parse2:[stamps objectAtIndex:2]];
                    [self.stamp3 setStampInfo:stampDTO2];
                    
                    if (stamps.count>3) {
                        StampDTO *stampDTO3 = [[StampDTO alloc] init];
                        [stampDTO3 parse2:[stamps objectAtIndex:3]];
                        [self.stamp4 setStampInfo:stampDTO3];
                    }
                }
            }
        
            [self.moreBtn setTitle:[NSString stringWithFormat:@"%d",stamps.count] forState:UIControlStateNormal];
            self.moreBtn.enabled = YES;
        }else {
            [self.moreBtn setTitle:@"0" forState:UIControlStateNormal];
            self.moreBtn.enabled = NO;
        }   
    }
}

- (id)requestDidFinishLoad2:(NSData*)data
{
    [self.act stopAnimating];
    
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if(json_string.length > 0){
        id responseObject = [[json_string JSONValue] objectForKey:@"code"];
        if(responseObject && 0 == [responseObject integerValue]){
            //success!
            id realData = [[json_string JSONValue]  objectForKey:@"data"];
            return realData;
            
        }else{
            [self requestError2:[[json_string JSONValue]  objectForKey:@"data"]];
        }
    }else{
        [self requestError2:@"json is null"];
    }
    
    return nil;
}

- (void)requestError2:(NSString *)error {
    if (error) {
        [SVProgressHUD showErrorWithStatus:error];
    }
}


@end

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark - StatusStampPopupView
#pragma mark -

@interface StatusStampPopupView()

@property (nonatomic, strong) UIView *popupView;

@end


@implementation StatusStampPopupView
@synthesize popupView = _popupView;
@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        self.popupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 60)];
        self.popupView.userInteractionEnabled = YES;
        self.popupView.backgroundColor = [UIColor purpleColor];
        [self addSubview:self.popupView];
        
        for (int i=0 ; i<6; i++) {
            
            UIButton *stampType = [UIButton buttonWithType:UIButtonTypeCustom];
            stampType.frame = CGRectMake(0, 10, 40, 40);
            stampType.left = (i+1)*9 + i*stampType.width;
            stampType.tag = i;
            [stampType setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_write_sticker_big%d",i]] forState:UIControlStateNormal];
            [stampType addTarget:self action:@selector(stamp:) forControlEvents:UIControlEventTouchUpInside];
            [self.popupView addSubview:stampType];
        }
        
        UITapGestureRecognizer *dismissGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:dismissGes];
        
        UITapGestureRecognizer *preventGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
        [self.popupView addGestureRecognizer:preventGes];
    }
    return self;
}

- (void)showInView:(UIView *)view WithPoint:(CGPoint)point
{
    [view addSubview:self];
    self.popupView.top = point.y;
    self.popupView.left = 10;
}

- (void)dismiss
{
    [self removeFromSuperview];
}

- (void)stamp:(id)sender{
    [self.delegate stampSelected:[NSString stringWithFormat:@"%d",[(UIButton *)sender tag]]];
    
    [self dismiss];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark - UserStatusCommonView
#pragma mark -
@interface UserStatusCommonView()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) KKAvatarView *avatarImageView;

@property (nonatomic, strong) UIImageView *sceneImageView;
@property (nonatomic, strong) UIView *audioLed;//标示播放状态
@property (nonatomic, strong) UIButton *audioBtn;

@property (nonatomic, strong) NCMusicEngine *musicEngine;
@property (nonatomic, strong) UserStatusInfoDto *userStatusInfoDto;

- (void)setObject:(id)obj;

@end

@implementation UserStatusCommonView
@synthesize nameLabel = _nameLabel;
@synthesize timeLabel = _timeLabel;
@synthesize avatarImageView = _avatarImageView;
@synthesize sceneImageView = _sceneImageView;
@synthesize audioLed = _audioLed;
@synthesize audioBtn = _audioBtn;
@synthesize musicEngine = _musicEngine;
@synthesize userStatusInfoDto = _userStatusInfoDto;

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, VIEW_WIDTH, HEADER_HEIGHT+CENTER_HEIGHT);
        self.backgroundColor = [UIColor clearColor];
        self.autoresizesSubviews = YES;
        
        _musicEngine = [NCMusicEngine sharedPlayer];
        _musicEngine.delegate = (id)self;
        
        ////////////////////////////////////////////////////
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        
        UIView *tempHeadView = [[UIView alloc] init];
        [tempHeadView setFrame:CGRectMake(0, 0, VIEW_WIDTH, HEADER_HEIGHT)];
        [tempHeadView setBackgroundColor:[UIColor clearColor]];
        [tempHeadView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        
        self.avatarImageView = [KKAvatarView creatWithSize:40];
        self.avatarImageView.left = 10;
        self.avatarImageView.top = 6;
        [tempHeadView addSubview:_avatarImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.right + 10, 0, 150, 20)];
        _nameLabel.centerY = tempHeadView.height/2.0f;
        [_nameLabel setLineBreakMode:UILineBreakModeTailTruncation];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextColor:RGB89];
        _nameLabel.font=[UIFont systemFontOfSize:16.0f];
        [_nameLabel addGestureRecognizer:tapGestureRecognizer];
        [tempHeadView addSubview:_nameLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.right + 10, _nameLabel.top, tempHeadView.width-_nameLabel.right-20, 20)];
        [_timeLabel setTextAlignment:UITextAlignmentRight];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setTextColor:RGB165];
        _timeLabel.font = [UIFont systemFontOfSize:10.0f];
        [_timeLabel setAdjustsFontSizeToFitWidth:YES];
        [tempHeadView addSubview:_timeLabel];
        [self addSubview:tempHeadView];
        ////////////////////////////////////////////////////
        
        UIView *tempCenterView = [[UIView alloc] init];
        [tempCenterView setFrame:CGRectMake(tempHeadView.left, tempHeadView.bottom, VIEW_WIDTH, CENTER_HEIGHT)];
        tempCenterView.backgroundColor = [UIColor clearColor];
        [tempCenterView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        
        self.sceneImageView = [[UIImageView alloc] init];
        [self.sceneImageView setFrame:tempCenterView.bounds];
        self.sceneImageView.backgroundColor = [UIColor clearColor];
        [self.sceneImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [tempCenterView addSubview:self.sceneImageView];
        
        self.audioLed = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 6, 6)];
        [tempCenterView addSubview:self.audioLed];
        
        self.audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.audioBtn setFrame:CGRectMake(0, 0, 60, 60)];
        self.audioBtn.centerX = tempCenterView.width/2;
        self.audioBtn.centerY = tempCenterView.height/2;
        [self.audioBtn setBackgroundImage:[UIImage imageNamed:@"playbutton.png"] forState:UIControlStateSelected];
        [self.audioBtn setBackgroundImage:[UIImage imageNamed:@"pausebutton.png"] forState:UIControlStateNormal];
        self.audioBtn.selected = false;
        [self.audioBtn addTarget:self action:@selector(audioPlayerClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.audioBtn setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin];
        [tempCenterView addSubview:self.audioBtn];
        
        [self addSubview:tempCenterView];
    }
    return self;
}

- (void)setObject:(id)obj
{
    UserStatusInfoDto *userStatusInfoDto = obj;
    if (userStatusInfoDto) {
        [self.avatarImageView setUserInfo:userStatusInfoDto.userInfo EnableTap:YES];
        [self.nameLabel setText:userStatusInfoDto.userInfo.user_name];
//        [self.sceneImageView setImageWithURL:[NSURL URLWithString: userStatusInfoDto.user_figure]];
        
        self.timeLabel.text = [NSDate stringFromDate:userStatusInfoDto.status_create_time];
        
        [_musicEngine performSelector:@selector(playUrl:) withObject:[NSURL URLWithString:userStatusInfoDto.status_audio] afterDelay:0.1f];
    }
}

#pragma mark - Delegates
- (void)engine:(NCMusicEngine *)engine didChangePlayState:(NCMusicEnginePlayState)playState
{
    
    switch (playState) {
        case NCMusicEnginePlayStatePlaying:
        {
            self.audioLed.backgroundColor = [UIColor greenColor];
        }
            break;
        case NCMusicEnginePlayStateError:
        {
            self.audioLed.backgroundColor = [UIColor blackColor];
        }
            break;
        default:
        {
            self.audioLed.backgroundColor = [UIColor redColor];
        }
            break;
    }
}

- (void)audioPlayerClicked:(UIButton*)sender
{
    sender.selected = !sender.selected;
    
    if([_musicEngine isPlaying])
    {
        [_musicEngine pause];
    }
    else
    {
        [_musicEngine resume];
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)tapGesture
{
    //self.userStatusInfoDto.user_id
    
    if([tapGesture.view isKindOfClass:[UILabel class]])
    {
        NSLog(@"name label taped");
    }
    else if([tapGesture.view isKindOfClass:[UIImageView class]])
    {
        NSLog(@"avatar imageview taped");
    }
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark - UserStatusListView
#pragma mark -

@interface UserStatusListView()

@property (nonatomic, strong) UIImageView *imageViewBackground;
@property (nonatomic, strong) UserStatusInfoDto *userStatusInfoDto;
@property (nonatomic, strong) UserStatusCommonView *commonView;
@property (nonatomic, strong) UILabel *stampCount;
@property (nonatomic, strong) UILabel *commentCount;


@end


@implementation UserStatusListView
@synthesize imageViewBackground = _imageViewBackground;
@synthesize userStatusInfoDto = _userStatusInfoDto;
@synthesize commonView = _commonView;

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT);
        
        [self createSubview];
    }
    return self;
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return VIEW_HEIGHT;
}

- (void)setObject:(id)item
{
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        self.userStatusInfoDto = [[UserStatusInfoDto alloc] init];
        if([_userStatusInfoDto parse2:item])
        {
            [self.commonView setObject:_userStatusInfoDto];
            
            self.stampCount.text = [NSString stringWithFormat:@"%d",self.userStatusInfoDto.status_like_count];
            self.commentCount.text = [NSString stringWithFormat:@"%d",self.userStatusInfoDto.status_comment_count];
        }

    }
    
    [self setNeedsLayout];
}

- (void)createSubview
{    
    UIImage *image = [[UIImage imageNamed:@"back-status"] stretchableImageWithLeftCapWidth:50 topCapHeight:60];
    self.imageViewBackground =[[UIImageView alloc] initWithImage:image];
    self.imageViewBackground.contentMode = UIViewContentModeScaleToFill;
    self.imageViewBackground.backgroundColor = [UIColor clearColor];
    [_imageViewBackground setFrame:CGRectMake(VIEW_TAG, VIEW_TAG, VIEW_WIDTH, VIEW_HEIGHT-VIEW_TAG)];
    [self addSubview:_imageViewBackground];
    
    self.commonView = [[UserStatusCommonView alloc] init];
    self.commonView.left = VIEW_TAG;
    self.commonView.top = VIEW_TAG;
    [self addSubview:self.commonView];
    
    UIView *tempBottomView = [[UIView alloc] init];
    [tempBottomView setFrame:CGRectMake(self.commonView.left , self.commonView.bottom, VIEW_WIDTH, BOTTOM_HEIGHT)];
    [tempBottomView setUserInteractionEnabled:YES];
    [tempBottomView setTag:10];
    [tempBottomView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *stampIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-emoji-gray"]];
    stampIcon.frame = CGRectMake(0, 0, 15, 15);
    stampIcon.left = 10;
    stampIcon.centerY = tempBottomView.height/2.0;
    
    self.stampCount = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 15)];
    self.stampCount.top = stampIcon.top;
    self.stampCount.left = stampIcon.right+2;
    self.stampCount.backgroundColor = [UIColor clearColor];
    self.stampCount.font = [UIFont systemFontOfSize:12.0f];
    self.stampCount.textColor = RGB165;
    
    UIImageView *commentIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-comment-gray"]];
    commentIcon.frame = CGRectMake(0, 0, 15, 15);
    commentIcon.left = self.stampCount.right+5;
    commentIcon.top = stampIcon.top;
    
    self.commentCount = [[UILabel alloc] initWithFrame:self.stampCount.bounds];
    self.commentCount.top = stampIcon.top;
    self.commentCount.left = commentIcon.right+2;
    self.commentCount.backgroundColor = [UIColor clearColor];
    self.commentCount.font = self.stampCount.font;
    self.commentCount.textColor = self.stampCount.textColor;
    
    UIImageView *arrowIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-rArrow-gray"]];
    arrowIcon.frame = CGRectMake(0, 0, 15, 15);
    arrowIcon.top = stampIcon.top;
    arrowIcon.right = tempBottomView.width-10;
    
    [tempBottomView addSubview:stampIcon];
    [tempBottomView addSubview:self.stampCount];
    [tempBottomView addSubview:commentIcon];
    [tempBottomView addSubview:self.commentCount];
    [tempBottomView addSubview:arrowIcon];
    
    [self addSubview:tempBottomView];
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tapGestureRecognizer];//push to 动态详情
    
}

- (void)tapGesture:(UITapGestureRecognizer *)tapGesture
{
    if([tapGesture.view isKindOfClass:[BaseView class]])
    {
        NSLog(@"detailView taped");
        if(self.userStatusInfoDto.status_id)
        {
            UserStatusViewController *userStatusViewController = [[UserStatusViewController alloc] initWithUserStatusDto:self.userStatusInfoDto];
            userStatusViewController.hidesBottomBarWhenPushed = YES;
            userStatusViewController.delegate = self.viewController;
            [self.viewController.navigationController pushViewController:userStatusViewController animated:YES];
        }
    }
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark - UserStatusDetailView
#pragma mark -

@interface UserStatusDetailView()

@property (nonatomic, strong) StatusStampView *stampView;//盖章
@property (nonatomic, strong) UserStatusCommonView *commonView;
@property (nonatomic, strong) UserStatusInfoDto *userStatusInfoDto;

@end


@implementation UserStatusDetailView
@synthesize stampView = _stampView;
@synthesize commonView = _commonView;
@synthesize userStatusInfoDto = _userStatusInfoDto;

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 320, 197+HEADER_HEIGHT+60);
        
        self.commonView = [[UserStatusCommonView alloc] init];
        self.commonView.frame = CGRectMake(0, 0, 320, 197+HEADER_HEIGHT);
        [self addSubview:self.commonView];
        
        self.stampView = [[StatusStampView alloc] init];
        self.stampView.top = self.commonView.bottom;
        [self addSubview:self.stampView];
    }
    return self;
}

- (void)setObject:(id)item
{
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        self.userStatusInfoDto = [[UserStatusInfoDto alloc] init];
        if([_userStatusInfoDto parse2:item])
        {
            [self.commonView setObject:_userStatusInfoDto];
            
            [self.stampView setObject:_userStatusInfoDto];
        }
    }
    
    [self setNeedsLayout];
}

@end

