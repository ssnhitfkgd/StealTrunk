//
//  FriendsListViewController.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-8.
//
//

#import "FriendsListViewController.h"
#import "FriendsListCell.h"
#import "FileClient.h"

@interface FriendsListViewController ()


@end

@implementation FriendsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"好友列表", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.enableHeader = YES;


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
    return API_LIST_FRIENDS;
}

- (void)didFinishLoad:(id)obj
{
    NSDictionary *rootDic = (NSDictionary *)obj;
    NSArray *eggs = [rootDic objectForKey:@"list"];
    [super didFinishLoad:eggs];
}

@end
