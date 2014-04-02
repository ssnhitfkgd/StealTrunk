//
//  BlockListViewController.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-22.
//
//

#import "BlockListViewController.h"
#import "UserCommonCell.h"

@interface BlockListViewController ()

@end

@implementation BlockListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"黑名单", nil);
        self.view.backgroundColor = [UIColor whiteColor];
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
        [self.tableView setBackgroundColor:[UIColor colorWithRed:227./255. green:228./255. blue:230./255. alpha:1]];
    self.enableHeader = YES;
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
    return API_LIST_BLOCK;
}

- (void)didFinishLoad:(id)obj
{
    NSDictionary *rootDic = (NSDictionary *)obj;
    NSArray *eggs = [rootDic objectForKey:@"list"];
    [super didFinishLoad:eggs];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (cell) {
        [(UserCommonCell *)cell cellView].viewType = USER_COMMON_CELL_TYPE_BLOCKED;
    }
    
    return cell;
}

@end
