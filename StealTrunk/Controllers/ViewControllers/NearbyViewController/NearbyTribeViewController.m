//
//  NearbyTribeViewController.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-11.
//
//

#import "NearbyTribeViewController.h"
#import "TribeCell.h"
#import "TribeDetailViewController.h"
#import "GetNearbyPlacesViewController.h"

@interface NearbyTribeViewController ()

@end

@implementation NearbyTribeViewController
@synthesize myCoordinate = _myCoordinate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = NSLocalizedString(@"附近部落", nil);
        
        //初始化为无效坐标
        self.myCoordinate = CLLocationCoordinate2DMake(300, 300);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[MapViewLocation shareInstance] startWithDelegate:self];
    
    //发布按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightBtn.frame = CGRectMake(0, 0, 50, 29);
    [rightBtn setTitle:NSLocalizedString(@"激活部落", nil) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.enableHeader = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBtnPress:(id)sender
{
    [self.navigationController pushViewController:[[GetNearbyPlacesViewController alloc] init] animated:YES];
}

#pragma mark - SuperView
- (Class)cellClass {
    //NSAssert(NO, @"subclasses to override");
    return [TribeCell class];
}

- (API_GET_TYPE)modelApi
{
    API_GET_TYPE type = -1;
    
    //取到地理位置后再发
    if (CLLocationCoordinate2DIsValid(self.myCoordinate)) {
        type = API_LIST_NEARBY_TRIBE;
    }
    
    return type;
}

- (CLLocationCoordinate2D)getLocationCoordinate
{
    return self.myCoordinate;
}

#pragma mark - delegatess
- (void)didCoordinateSuccess:(CLLocationCoordinate2D)coordinate
{
    if (!CLLocationCoordinate2DIsValid(self.myCoordinate) && CLLocationCoordinate2DIsValid(coordinate) &&(coordinate.latitude != 0.0 && coordinate.longitude != 0.0)) {
        [[MapViewLocation shareInstance] stopLocate];
        
        self.myCoordinate = coordinate;
        [self reloadData];
    }
}

- (void)didCoordinateFailed:(NSError*)error
{
#warning error 是什么？ 没开定位？没网络？还是什么原因？定位失败 或者用户禁止定位
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TribeDTO *DTO = [[TribeDTO alloc] init];    
    
    if ([DTO parse2:[self.model objectAtIndex:indexPath.row]]) {
        [self.navigationController pushViewController:[TribeDetailViewController creatWithDTO:DTO] animated:YES];
    }else{
        [SVProgressHUD showErrorWithStatus:@"未取到部落信息"];
    }
    
}

@end
