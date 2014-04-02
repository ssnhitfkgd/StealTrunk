//
//  MessageListViewController.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-14.
//
//

#import "MessageListViewController.h"
#import "MessageListCell.h"
#import "MessageListView.h"

@interface MessageListViewController ()

@end

@implementation MessageListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"消息", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //发布按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"超级访客" forState:UIControlStateNormal];
    [rightBtn.titleLabel setBackgroundColor:[UIColor clearColor]];
    [rightBtn setTitleColor:[UIColor colorWithRed:62./255. green:204./255. blue:204./255. alpha:1.] forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:12.]];
    [rightBtn setBackgroundColor:[UIColor whiteColor]];
    //rightBtn.contentMode = UIViewContentModeRight;
    rightBtn.frame = CGRectMake(0, 0, 60, 30);
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
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
    return [MessageListCell class];
}

- (API_GET_TYPE)modelApi
{
    return API_LIST_NOTIFICATION;
}

- (void)didFinishLoad:(id)obj
{
    NSDictionary *rootDic = (NSDictionary *)obj;
    NSArray *eggs = [rootDic objectForKey:@"list"];
    [super didFinishLoad:eggs];
}

@end
