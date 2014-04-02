//
//  InviteListViewController.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-22.
//
//

#import "InviteListViewController.h"
#import "FriendsListCell.h"

@interface InviteListViewController ()

@end

@implementation InviteListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"邀请新浪微博好友", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.enableHeader = YES;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (Class)cellClass {
    //NSAssert(NO, @"subclasses to override");
    return [FriendsListCell class];
}

- (API_GET_TYPE)modelApi
{
    return API_LIST_INVITE;
}

- (void)didFinishLoad:(id)obj
{
    NSDictionary *rootDic = (NSDictionary *)obj;
    NSArray *eggs = [rootDic objectForKey:@"list"];
    [super didFinishLoad:eggs];
}

- (NSString *)getInviteType
{
    return @"weibo";
}

@end
