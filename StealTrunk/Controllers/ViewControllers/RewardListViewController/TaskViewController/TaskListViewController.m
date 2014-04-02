//
//  TaskListViewController.m
//  StealTrunk
//
//  Created by wangyong on 13-8-20.
//
//

#import "TaskListViewController.h"
#import "TaskCell.h"

@interface TaskListViewController ()

@end

@implementation TaskListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"任务", nil);

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.enableHeader = YES;

	// Do any additional setup after loading the view.
}

- (API_GET_TYPE)modelApi
{
    return API_LIST_TASK;
}

- (Class)cellClass
{
    return [TaskCell class];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
