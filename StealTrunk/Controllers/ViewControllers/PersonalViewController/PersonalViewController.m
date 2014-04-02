//
//  PersonalViewController.m
//  StealTrunk
//
//  Created by wangyong on 13-7-17.
//
//

#import "PersonalViewController.h"
#import "DesireCell.h"
#import "UserStatusCell.h"
#import "NameCardViewController.h"
#import "PublishViewController.h"

@interface PersonalViewController ()
{
    PERSONAL_TYPE personalType;
}

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, strong) CardView *cardView;
@property (nonatomic, strong) Monstea_user_info *userInfo;

@end

@implementation PersonalViewController
@synthesize dataArray = _dataArray;
@synthesize cardView = _cardView;
@synthesize userInfo = _userInfo;

- (id)initWithUserInfo:(Monstea_user_info *)userInfo
{
    self = [super init];
    if (self) {
        
        self.hidesBottomBarWhenPushed = YES;
        
        self.userInfo = userInfo;
        
        if ([self.userInfo.user_id isEqualToString:[[AccountDTO sharedInstance] monstea_user_info].user_id]) {
            self.title = NSLocalizedString(@"我的空间", nil);
        }else {
            self.title = self.userInfo.user_name;
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([self.userInfo.user_id isEqualToString:[[AccountDTO sharedInstance] monstea_user_info].user_id]){
        //发布按钮
        UIButton *postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        postBtn.frame = CGRectMake(0, 0, 50, 29);
        postBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [postBtn setImage:[UIImage imageNamed:@"navi-btn-publish"] forState:UIControlStateNormal];
        [postBtn addTarget:self action:@selector(postBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:postBtn];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    self.dataArray = [[NSMutableArray alloc] initWithObjects:[NSArray array], [NSArray array], nil];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,screenSize().width,screenSize().width)];
    [headerView setBackgroundColor:[UIColor blackColor]];
    
    self.cardView = [[NameCardViewController creatWithUserID:self.userInfo.user_id Popup:NO] cardView];
    [headerView addSubview:self.cardView];
    
    [self.tableView setTableHeaderView:headerView];
    personalType = USER_STATUS;
    self.enableHeader = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.cardView startDeviceMotion];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NCMusicEngine sharedPlayer] stop];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize().width, 44)];
    [view setBackgroundColor:[UIColor blackColor]];
    
    NSArray *nameArray = [NSArray arrayWithObjects:@"动态", @"愿望", nil];
    for(int i = 0 ; i < [nameArray count]; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(i * 320/[nameArray count] + i * 1, 0, 320/[nameArray count], 44)];
        [button setBackgroundColor:[UIColor redColor]];
        [button setTitle:nameArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTag:i];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    
    return view;
}

- (void)buttonClicked:(UIButton*)sender
{
    if(self.model)
    {
        [_dataArray replaceObjectAtIndex:personalType withObject: self.model];
    }
    personalType = sender.tag;
    self.model = nil;
    
    NSArray *array = _dataArray[personalType] ;
    if(array && [array count] > 0)
    {
        self.model = array;
        [self.tableView reloadData];
        return;
    }
    [self.tableView reloadData];
    [self reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.model == nil)
        return 0;
    
    if(personalType == USER_DESIRE)
    {
        return [self.model count] / 3 + (([self.model count] % 3) > 0 ?1:0);
    }
    return [self.model count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(personalType == USER_DESIRE)
    {
        Class cls = [self cellClass];
        static NSString *identifier = @"Cell";
        id cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[cls alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        int nStep = (3 * indexPath.row);
        NSRange range = NSMakeRange(nStep, 3);
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        
        if([self.model count] / (3 + range.location) > 0)
        {
            [cell setObject:[self.model objectsAtIndexes:indexSet]];
        }
        else {
            NSRange range = NSMakeRange(nStep, [self.model count] - nStep);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [cell setObject:[self.model objectsAtIndexes:indexSet]];
        }
        
        return cell;
    }
    else
    {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }

}

#pragma mark - superview
- (Class)cellClass {
    if(personalType == USER_DESIRE)
    {
        return [DesireCell class];
    }
    
    return [UserStatusCell class];
}

- (NSString *)getUserID
{
    return self.userInfo.user_id;
}
 
- (API_GET_TYPE)modelApi
{
    if(personalType == USER_DESIRE)
    {
        //return API_LIST_USER_STATUS; // 缺接口
    }

    return API_LIST_USER_STATUS;
}

- (void)didFinishLoad:(id)objc
{    
    if(objc && [objc isKindOfClass:[NSDictionary class]])
    {
        if(personalType == USER_DESIRE)
        {
            [super didFinishLoad:[objc objectForKey:@"none"]];;
        }
        else
        {
            [super didFinishLoad:[objc objectForKey:@"list"]];
        }
    }
}

- (void)deleteStatus:(UserStatusInfoDto *)statusDTO
{
    NSIndexPath *indexP;
    for (int i=0; i<[self.model count]; i++) {
        NSDictionary *dic = [self.model objectAtIndex:i];
        
        UserStatusInfoDto *dicDTO = [[UserStatusInfoDto alloc] init];
        [dicDTO parse2:dic];
        
        if ([dicDTO.status_id isEqualToString:statusDTO.status_id]) {
            indexP = [NSIndexPath indexPathForRow:i inSection:0];
            
            [self.model removeObject:dic];
            
            [self.tableView reloadData];
            
            break;
        }
    }
}

- (void)postBtnPress:(id)sender
{
    [self presentViewController:[[PublishViewController alloc] init] animated:YES completion:^{ }];
}

@end
