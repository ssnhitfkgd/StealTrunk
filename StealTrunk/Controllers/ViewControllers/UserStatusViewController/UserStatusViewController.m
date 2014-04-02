//
//  UserStatusViewController.m
//  StealTrunk
//
//  Created by wangyong on 13-7-28.
//
//

#import "UserStatusViewController.h"
#import "UserStatusCell.h"
#import "UserStatusView.h"
@interface UserStatusViewController ()

@end

@implementation UserStatusViewController

- (id)initWithUserStatusDto:(UserStatusInfoDto*)userStatusDto
{
    self = [super init];
    if(self)
    {
        statusDto = userStatusDto;
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
    
    UserStatusView *statusView = [[UserStatusView alloc] init];
    [statusView setHeight:[UserStatusView rowHeightForObject:statusDto.dtoResult]];
    [statusView setObject:statusDto.dtoResult];
    [self.tableView setTableHeaderView:statusView];
    
    self.enableHeader = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didFinishLoad:(id)objc
{
    id obj = [objc objectForKey:@"list"];
    [super didFinishLoad:obj];
    
}

- (NSString *)getStatusID
{
    //override
    return statusDto.status_id;
}

- (Class)cellClass {
    return [UserStatusCell class];
}

- (API_GET_TYPE)modelApi
{
    return API_LIST_USER_STATUS_COMMENT;
}

@end
