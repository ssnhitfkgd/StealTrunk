//
//  FriendsNewsViewController.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-8.
//
//

#import "FriendsNewsViewController.h"
#import "UserStatusCell.h"
#import "GRAlertView.h"
#import "PublishViewController.h"

@interface FriendsNewsViewController ()

@end

@implementation FriendsNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = NSLocalizedString(@"好友动态", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.enableHeader = YES;
    
    //self.tableView.height = [UIScreen mainScreen].bounds.size.height-44-49;
    
    //发布按钮
    UIButton *postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    postBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [postBtn setImage:[UIImage imageNamed:@"navi-btn-publish"] forState:UIControlStateNormal];
    postBtn.contentMode = UIViewContentModeRight;
    postBtn.frame = CGRectMake(0, 0, 50, 29);
    [postBtn addTarget:self action:@selector(postBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:postBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.enableHeader = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NCMusicEngine sharedPlayer] stop];
}

#pragma mark -
- (Class)cellClass {
    //NSAssert(NO, @"subclasses to override");
    return [UserStatusCell class];
}

- (API_GET_TYPE)modelApi
{
    return API_LIST_FRIENDS_STATUS;
}

- (void)didFinishLoad:(id)obj
{
    NSDictionary *rootDic = (NSDictionary *)obj;
    NSArray *eggs = [rootDic objectForKey:@"list"];
    [super didFinishLoad:eggs];
}

- (void)postBtnPress:(id)sender
{
    [self presentViewController:[[PublishViewController alloc] init] animated:YES completion:^{ }];
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

@end
