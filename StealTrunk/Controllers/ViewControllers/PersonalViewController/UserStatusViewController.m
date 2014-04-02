//
//  UserStatusViewController.m
//  StealTrunk
//
//  Created by wangyong on 13-7-28.
//
//

#import "UserStatusViewController.h"
#import "UserStatusView.h"
#import "CommentCell.h"
#import "RichInputView.h"
#import "FileClient.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////

@interface UserStatusViewController () <RichInputViewDelegate>

@property (nonatomic, strong) RichInputView *commentInputView;

@end

@implementation UserStatusViewController
@synthesize commentInputView = _commentInputView;
@synthesize statusDto = _statusDto;
@synthesize delegate = _delegate;

- (id)initWithUserStatusDto:(UserStatusInfoDto*)userStatusDto
{
    self = [super init];
    if(self)
    {
        self.statusDto = userStatusDto;
        self.title = NSLocalizedString(@"动态详情", nil);
    }
    return self;
}

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
    
    self.commentInputView = [[RichInputView alloc] init];
    self.commentInputView.backgroundColor = [UIColor greenColor];
    self.commentInputView.delegate = self;
    self.commentInputView.top = self.tableView.height-44-self.commentInputView.contentView.height;//44:navibar height
    self.commentInputView.text_voiceBtn.hidden = YES;
    self.commentInputView.growingTextView.hidden = YES;
    self.commentInputView.text_emojiBtn.hidden = YES;
    self.commentInputView.pushToTalkBtn.hidden = NO;
    [self.view addSubview:self.commentInputView];
    
    self.tableView.height -= self.commentInputView.contentView.height;//输入框高度
    
    UserStatusDetailView *statusView = [[UserStatusDetailView alloc] init];
    [statusView setObject:self.statusDto.dtoResult];
    [self.tableView setTableHeaderView:statusView];
     
    //更多按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightBtn.frame = CGRectMake(0, 0, 50, 29);
    [rightBtn setTitle:NSLocalizedString(@"更多", nil) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didFinishLoad:(id)objc
{
    NSDictionary *rootDic = (NSDictionary *)objc;
    NSArray *eggs = [rootDic objectForKey:@"list"];
    [super didFinishLoad:eggs];
}

- (NSString *)getStatusID
{
    //override
    return self.statusDto.status_id;
}

- (Class)cellClass {
    return [CommentCell class];
}

- (API_GET_TYPE)modelApi
{
    return API_LIST_USER_STATUS_COMMENT;
}

#pragma mark - Actions
- (void)rightBtnPress:(id)sender
{
    BOOL isMine = [self.statusDto.userInfo.user_id isEqualToString:[[AccountDTO sharedInstance] monstea_user_info].user_id];
    
    UIActionSheet *actionSheet;
    
    if (isMine) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                    destructiveButtonTitle:NSLocalizedString(@"删除", nil)
                                         otherButtonTitles:NSLocalizedString(@"分享", nil), nil];
        actionSheet.tag = 1000;
    }else {
        actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"分享", nil)
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:NSLocalizedString(@"微博", nil),NSLocalizedString(@"微信", nil), nil];
        actionSheet.tag = 1001;
    }
    
    [actionSheet showInView:self.view];
}

#pragma mark - Network
- (void)deleteStatusEnd:(NSData *)data
{
    id realdata = [self requestDidFinishLoad2:data];
    
    if (realdata) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"已删除", nil)];
        
        //从list中删除
        if ([self.delegate respondsToSelector:@selector(deleteStatus:)]) {
            [self.delegate deleteStatus:self.statusDto];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - Delegate
- (void)sendVoice:(NSString *)voice
{
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case 1000:
        {
            switch (buttonIndex) {
                case 0:
                {
                    //删除
                    [[FileClient sharedInstance] deleteUserStatusWithStatusID:self.statusDto.status_id
                                                                     delegate:self
                                                                     selector:@selector(deleteStatusEnd:)
                                                                selectorError:@selector(requestError2:)];
                    [SVProgressHUD showWithStatus:NSLocalizedString(@"删除中...", nil)
                                         maskType:SVProgressHUDMaskTypeGradient];
                }
                    break;
                case 1:
                {
                    //分享
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1001:
        {
            switch (buttonIndex) {
                case 0:
                {
                    //微博
                }
                    break;
                case 1:
                {
                    //微信
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}


@end
