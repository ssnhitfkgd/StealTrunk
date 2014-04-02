//
//  StampsListViewController.m
//  StealTrunk
//
//  Created by 点兄 on 13-8-9.
//
//

#import "StampsListViewController.h"
#import "UserStatusInfoDto.h"
#import "StampCell.h"

@interface StampsListViewController ()

@end

@implementation StampsListViewController
@synthesize DTO = _DTO;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SuperView
- (void)didFinishLoad:(id)objc
{
    id obj = [objc objectForKey:@"list"];
    [super didFinishLoad:obj];
    
}

- (NSString *)getStatusID
{
    //override
    return self.DTO.status_id;
}

- (Class)cellClass {
    return [StampCell class];
}

- (API_GET_TYPE)modelApi
{
    return API_LIST_USER_STATUS_LIKE;
}

@end
