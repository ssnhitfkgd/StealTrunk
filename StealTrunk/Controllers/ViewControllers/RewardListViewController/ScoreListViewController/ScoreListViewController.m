//
//  ScoreListViewController.m
//  StealTrunk
//
//  Created by wangyong on 13-8-20.
//
//

#import "ScoreListViewController.h"
#import "ScoreCell.h"

@interface ScoreListViewController ()

@end

@implementation ScoreListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"成就", nil);

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
}

- (API_GET_TYPE)modelApi
{
    return API_LIST_SCORE;
}

- (Class)cellClass
{
    return [ScoreCell class];
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

@end
