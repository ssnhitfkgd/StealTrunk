//
//  FriendsAddView.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-8.
//
//

#import "UserCommonCellView.h"
#import "GRAlertView.h"
#import "FileClient.h"
#import "GetFriendsRequestDTO.h"

@implementation UserCommonCellView

@synthesize user_avatar = _user_avatar;
@synthesize user_name = _user_name;
@synthesize detail_text = _detail_text;
@synthesize add_btn = _add_btn;
@synthesize viewType = _viewType;
@synthesize grade = _grade;
@synthesize DTO = _DTO;

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.clipsToBounds = YES;
        self.height = 71;
        self.backgroundColor = [UIColor whiteColor];
        
        [self createSubview];
    }
    return self;
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return 71;
}

- (void)setObject:(id)item
{
    if(item && [item isKindOfClass:[NSDictionary class]]){
        self.DTO = item;
    }
}

- (void)setViewType:(USER_COMMON_CELL_TYPE)viewType
{
    _viewType = viewType;
    
    Monstea_user_info *userInfo = [[Monstea_user_info alloc] init];
    
    switch (self.viewType) {
        case USER_COMMON_CELL_TYPE_REQUEST:
        {
            GetFriendsRequestDTO *tempDTO = [[GetFriendsRequestDTO alloc] init];
            if([tempDTO parse2:(NSDictionary *)self.DTO]){
                userInfo = tempDTO.userInfo;
            }
            self.DTO = tempDTO;
            
            [self.add_btn setImage:[UIImage imageNamed:@"btn-check"] forState:UIControlStateNormal];
            
//            [self.add_btn setTitle:NSLocalizedString(@"同意", nil) forState:UIControlStateNormal];
//            [self.add_btn setTitle:NSLocalizedString(@"已添加", nil) forState:UIControlStateDisabled];
            
            if (tempDTO.reason && tempDTO.reason.length>0) {
                self.detail_text.text = tempDTO.reason;
            }else {
                self.detail_text.text = NSLocalizedString(@"加我吧!", nil);
            }
#warning 等级木有数据
            self.grade.text = @"12";//4test
            
        }
            break;
        case USER_COMMON_CELL_TYPE_RECOMMEND:
        {
            [userInfo parseWithDic:(NSDictionary *)self.DTO];
            self.DTO = userInfo;
            
            [self.add_btn setImage:[UIImage imageNamed:@"btn-add"] forState:UIControlStateNormal];
            
//            [self.add_btn setTitle:NSLocalizedString(@"加好友", nil) forState:UIControlStateNormal];
//            [self.add_btn setTitle:NSLocalizedString(@"已申请", nil) forState:UIControlStateDisabled];
            
            self.detail_text.text = @"好友来源？";
        }
            break;
        case USER_COMMON_CELL_TYPE_BLOCKED:
        {
            [userInfo parseWithDic:(NSDictionary *)self.DTO];
            self.DTO = userInfo;
            
            [self.add_btn setTitle:NSLocalizedString(@"解除", nil) forState:UIControlStateNormal];
            [self.add_btn setTitle:NSLocalizedString(@"已刷白", nil) forState:UIControlStateDisabled];
            
            self.detail_text.text = userInfo.user_sign;
        }
            break;
        default:
            break;
    }
    
    NSURL *avatar_url = [NSURL URLWithString:userInfo.avatar];
    [self.user_avatar setUserInfo:userInfo EnableTap:YES];
    self.user_name.text = userInfo.user_name;

    [self setNeedsLayout];
}

- (void)createSubview
{    
    self.user_avatar = [KKAvatarView creatWithSize:50];
    self.user_avatar.left = 10;
    self.user_avatar.top = 10;
    
    UIImageView *gradeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-grade"]];
    gradeIcon.frame = CGRectMake(0, 0, 22, 22);
    gradeIcon.left = self.user_avatar.left-5;
    gradeIcon.bottom = self.user_avatar.bottom-2;
    self.grade = [[UILabel alloc] initWithFrame:gradeIcon.bounds];
    self.grade.backgroundColor = [UIColor clearColor];
    self.grade.font = [UIFont systemFontOfSize:10.0];
    self.grade.textColor = [UIColor whiteColor];
    self.grade.textAlignment = UITextAlignmentCenter;
    [gradeIcon addSubview:self.grade];
    
    self.user_name = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
    self.user_name.left = self.user_avatar.right + 10;
    self.user_name.top = self.user_avatar.top+3;
    self.user_name.font = [UIFont systemFontOfSize:16.0f];
    self.user_name.textColor = RGB89;
    self.user_name.backgroundColor = [UIColor clearColor];
    
    self.detail_text = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    self.detail_text.width = self.user_name.width;
    self.detail_text.left = self.user_name.left;
    self.detail_text.top = self.user_name.bottom + 5;
    self.detail_text.font = [UIFont systemFontOfSize:14.0f];
    self.detail_text.textColor = RGB165;
    self.detail_text.backgroundColor = [UIColor clearColor];
    
    self.add_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.add_btn.frame = CGRectMake(0, 0, 44, 44);
    self.add_btn.right = self.width-10;
    self.add_btn.centerY = self.user_avatar.centerY;
    [self.add_btn addTarget:self action:@selector(addBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    self.add_btn.backgroundColor = [UIColor clearColor];
    self.add_btn.userInteractionEnabled = YES;
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    separator.backgroundColor = RGB240;
    separator.bottom = self.height;
    
    [self addSubview:self.user_avatar];
    [self addSubview:gradeIcon];
    [self addSubview:self.user_name];
    [self addSubview:self.detail_text];
    [self addSubview:self.add_btn];
    [self addSubview:separator];
}

#pragma mark - Actions
- (void)addBtnPress:(id)sender
{
    switch (self.viewType) {
        case USER_COMMON_CELL_TYPE_REQUEST:
        {
            //同意添加
            [[FileClient sharedInstance] confirmFriendsRequestWithrequestID:[(GetFriendsRequestDTO *)self.DTO msg_id]
                                                                   delegate:self
                                                                   selector:@selector(confirmRequest:)
                                                              selectorError:@selector(requestError:)];
        }
            break;
        case USER_COMMON_CELL_TYPE_RECOMMEND:
        {
            //加好友
            [[FileClient sharedInstance] createFriendsRequestWithUserID:[(Monstea_user_info *)self.DTO user_id]
                                                               delegate:self
                                                               selector:@selector(friendsRequest:)
                                                          selectorError:@selector(requestError:)];
        }
            break;
        case USER_COMMON_CELL_TYPE_BLOCKED:
        {
            //解除黑名单
            [[FileClient sharedInstance] unBlockFriendsRequestWithUserID:[(Monstea_user_info *)self.DTO user_id]
                                                                Delegate:self
                                                                Selector:@selector(unBlockRequest:)
                                                           SelectorError:@selector(requestError:)];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Request
- (void)friendsRequest:(NSData *)data
{
    id realData = [self requestDidFinishLoad:data];
    if (realData) {
        [self.add_btn setEnabled:NO];
        
        //提示成功
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"添加成功", nil)];
    }
}

- (void)confirmRequest:(NSData *)data
{
    id realData = [self requestDidFinishLoad:data];
    if (realData) {
        //将button修改为“已添加”
        [self.add_btn setEnabled:NO];
        
        //提示成功
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"添加成功", nil)];
    }
}

- (void)unBlockRequest:(NSData *)data
{
    id realData = [self requestDidFinishLoad:data];
    if (realData) {
        //将button修改为“已添加”
        [self.add_btn setEnabled:NO];
        
        //提示成功
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"解除成功", nil)];
    }
}

- (id)requestDidFinishLoad:(NSData*)data
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

@end
