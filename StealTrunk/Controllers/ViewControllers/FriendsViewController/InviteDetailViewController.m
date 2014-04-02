//
//  InviteDetailViewController.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-23.
//
//

#import "InviteDetailViewController.h"
#import "FriendsListCell.h"

@interface InviteDetailViewController ()

@property (nonatomic, strong) NSMutableArray *acceptedArray;
@property (nonatomic, strong) NSMutableArray *successArray;

@end

@implementation InviteDetailViewController
@synthesize acceptedArray = _acceptedArray;
@synthesize successArray = _successArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"邀请详情", nil);
        
        self.acceptedArray = [NSMutableArray array];
        self.successArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.enableHeader = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (void)didFinishLoad:(id)objc
{
    [self.acceptedArray addObjectsFromArray:[objc objectForKey:@"accepted"]];
    [self.successArray addObjectsFromArray:[objc objectForKey:@"success"]];
}

- (Class)cellClass
{
    return [FriendsListCell class];
}

- (API_GET_TYPE)modelApi
{
    return API_LIST_INVITE_DETAIL;
}

@end
