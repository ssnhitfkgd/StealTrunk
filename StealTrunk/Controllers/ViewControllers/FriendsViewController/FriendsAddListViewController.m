//
//  FriendsAddViewController.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-10.
//
//

#import "FriendsAddListViewController.h"
#import "UserCommonCell.h"
#import "GRAlertView.h"
#import "SearchViewController.h"
#import "InviteViewController.h"
#import "FileClient.h"

@interface FriendsAddListViewController ()

@property (nonatomic, strong) NSMutableArray *requestModels;

@end

@implementation FriendsAddListViewController
@synthesize requestModels = _requestModels;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = NSLocalizedString(@"添加好友", nil);
        
        self.requestModels = [NSMutableArray array];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.enableHeader = YES;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize().width, 44)];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setFrame:CGRectMake(0, 0, view.width/2, view.height)];
    [searchBtn setBackgroundColor:RGB246];
    [searchBtn setImage:[UIImage imageNamed:@"icon-search-gray"] forState:UIControlStateNormal];
    [searchBtn setTitle:NSLocalizedString(@" 搜索好友", nil) forState:UIControlStateNormal];
    [searchBtn setTitleColor:RGB140 forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [searchBtn addTarget:self action:@selector(searchBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [inviteBtn setFrame:CGRectMake(0, 0, view.width/2, view.height)];
    inviteBtn.left = searchBtn.right;
    [inviteBtn setBackgroundColor:RGB246];
    [inviteBtn setImage:[UIImage imageNamed:@"icon-diamond-gray"] forState:UIControlStateNormal];
    [inviteBtn setTitle:NSLocalizedString(@" 邀请好友", nil) forState:UIControlStateNormal];
    [inviteBtn setTitleColor:RGB140 forState:UIControlStateNormal];
    inviteBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [inviteBtn addTarget:self action:@selector(inviteBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, view.height)];
    separator.backgroundColor = RGB218;
    separator.centerX = view.width/2.0;
    
    [view addSubview:searchBtn];
    [view addSubview:inviteBtn];
    [view addSubview:separator];
    
    [self.tableView setTableHeaderView:view];
    
    self.enableHeader = YES;
    //发请求－好友推荐列表
    [[FileClient sharedInstance] listFriendsRequestWithUserToken:[[[AccountDTO sharedInstance] session_info] token]
                                                        pageSize:@"20"
                                                        offsetID:@""
                                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        delegate:self
                                                        selector:@selector(friendsRequest:)
                                                   selectorError:@selector(requestError2:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (Class)cellClass {
    //NSAssert(NO, @"subclasses to override");
    return [UserCommonCell class];
}

- (API_GET_TYPE)modelApi
{
    return API_LIST_RECOMMEND;
}

- (void)didFinishLoad:(id)obj
{
    NSDictionary *rootDic = (NSDictionary *)obj;
    NSArray *eggs = [rootDic objectForKey:@"list"];
    [super didFinishLoad:eggs];
}

#pragma mark - Request
- (void)friendsRequest:(NSData *)data
{
    id realdata = [self requestDidFinishLoad2:data];
    
    if (realdata) {
        [self.requestModels addObjectsFromArray:[(NSDictionary *)realdata objectForKey:@"list"]];
        [self.tableView reloadData];
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
        [self requestError2:@"json is null"];
    }
    
    return nil;
}

- (void)requestError2:(NSString *)error {
    if (error) {
        [SVProgressHUD showErrorWithStatus:error];
    }
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 0;
    
    switch (section) {
        case 0:
        {
            if (self.requestModels && self.requestModels.count>0) {
                height = 25;
            }
        }
            break;
        case 1:
        {
            if (self.model && [(NSArray *)self.model count]>0) {
                height = 25;
            }
        }
            break;
        default:
            break;
    }
    
    return height;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    UIImageView *backIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header-gray"]];
    backIV.frame = view.bounds;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, view.height)];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont systemFontOfSize:11.0f];
    title.textColor = RGB165;
    title.left = 10;
    
    [view addSubview:backIV];
    [view addSubview:title];
    
    switch (section) {
        case 0:
        {
            title.text = NSLocalizedString(@"好友申请", nil);
        }
            break;
        case 1:
        {
            title.text = NSLocalizedString(@"好友推荐", nil);
        }
            break;
        default:
            break;
    }
    
    return view;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.model removeObjectAtIndex:indexPath.row];

        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationLeft];
        
#warning 发送请求
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title;
    switch (indexPath.section) {
        case 0:
        {
            title = NSLocalizedString(@"忽略", nil);
        }
            break;
        case 1:
        {
            title = NSLocalizedString(@"忽略", nil);
        }
            break;
        default:
            break;
    }
    
    return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 0;
    
    switch (section) {
        case 0:
        {
            rows = [self.requestModels count];
        }
            break;
        case 1:
        {
            rows = [self.model count];
        }
        default:
            break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class cls = [self cellClass];
    static NSString *identifier = @"Cell";
    id cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[cls alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if ([cell respondsToSelector:@selector(setObject:)]) {
        
        id item = nil;
        NSArray *rows;
        
        switch (indexPath.section) {
            case 0:
            {
                //好友申请列表
                rows = self.requestModels;
                item = [rows objectAtIndex:indexPath.row];
                [cell setObject:item];
                
                [(UserCommonCell *)cell cellView].viewType = USER_COMMON_CELL_TYPE_REQUEST;
            }
                break;
            case 1:
            {
                //好友推荐列表
                rows = self.model;
                item = [rows objectAtIndex:indexPath.row];
                [cell setObject:item];
                
                [(UserCommonCell *)cell cellView].viewType = USER_COMMON_CELL_TYPE_RECOMMEND;
            }
                break;
            default:
                break;
        }
        
        [(UserCommonCell *)cell cellView].delegate = self;
    }
    
    return cell;
}

#pragma mark - Actions

- (void)searchBtnPress:(id)sender
{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)inviteBtnPress:(id)sender
{
    InviteViewController *inviteVC = [[InviteViewController alloc] initWithStyle:UITableViewStyleGrouped];
    inviteVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:inviteVC animated:YES];
}

#pragma mark - Delegates
- (void)agreeSuccess
{
    //提示成功
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"添加成功", nil)];
}

@end
