//
//  TribeDetailViewController.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-21.
//
//

#import "TribeDetailViewController.h"
#import "FriendsListCell.h"
#import "MTPOI.h"
#import "FileClient.h"

@interface TribeDetailViewController ()

@end

@implementation TribeDetailViewController
@synthesize DTO = _DTO;
@synthesize mapView = _mapView;

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
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    self.mapView.userInteractionEnabled = NO;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.delegate = (id)self;
    self.mapView.showsUserLocation = NO;
    [[MapViewLocation shareInstance] startWithDelegate:self];
    
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(self.DTO.location, 2000, 2000);
    [self.mapView setRegion:region animated:YES];
    
    MTPOI *POI = [[MTPOI alloc] initWithCoords:self.DTO.location];
    [self.mapView  addAnnotation:POI];
    
    [self.tableView setTableHeaderView:self.mapView];
    
    UIButton *joinTribe = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    joinTribe.frame = CGRectMake(0, 0, 50, 30);
    [joinTribe setTitle:@"加入部落" forState:UIControlStateNormal];
    [joinTribe addTarget:self action:@selector(joinTribe:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:joinTribe];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.enableHeader = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (TribeDetailViewController *)creatWithDTO:(TribeDTO *)DTO
{
    TribeDetailViewController *control = [[TribeDetailViewController alloc] init];
    control.DTO = DTO;
    control.hidesBottomBarWhenPushed = YES;
    control.title = control.DTO.tribe_name;
    
    return control;
}

#pragma mark - SuperView
- (Class)cellClass {
    //NSAssert(NO, @"subclasses to override");
    return [FriendsListCell class];
}

- (API_GET_TYPE)modelApi
{
    return API_LIST_TRIBE_FARMS;
}

- (NSString *)getTribeID
{
    return self.DTO.tribe_id;
}

- (void)didFinishLoad:(id)obj
{
    NSDictionary *rootDic = (NSDictionary *)obj;
    NSArray *eggs = [rootDic objectForKey:@"list"];
    [super didFinishLoad:eggs];
}

#pragma mark - Delegates

#pragma mark - Actions
- (void)joinTribe:(id)sender
{
    FileClient *client = [FileClient sharedInstance];
    [client joinTribeWithUserToken:[[[AccountDTO sharedInstance] session_info] token] tribeID:self.DTO.tribe_id cachePolicy:NSURLRequestUseProtocolCachePolicy delegate:self selector:@selector(joinTribeRequestDidFinishLoad:) selectorError:@selector(joinTribeRequestError:)];
}

- (void)joinTribeRequestDidFinishLoad:(NSData*)data
{
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if(json_string.length > 0)
    {
        id responseObject = [[json_string JSONValue] objectForKey:@"code"];
        if(responseObject && 0 == [responseObject integerValue])
        {
            NSDictionary *dict = [[json_string JSONValue]  objectForKey:@"data"];
            if(dict)
            {
                //提示成功
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"加入成功", nil)];
            }
            else
            {
                [self requestError:nil];
            }
        }
        else
        {
            NSDictionary *dataDic = [NSDictionary dictionaryWithObject:[[json_string JSONValue]  objectForKey:@"data"] forKey:@"reason"];
            
            NSError *error = [NSError errorWithDomain:@"monstea" code:1 userInfo:dataDic];
            [self requestError:error];
        }
    }
    
    else {
        [self requestError:nil];
    }
}

- (void)joinTribeRequestError:(NSError *)error {
    NSString *errorReason = [error.userInfo objectForKey:@"reason"];
    
    //提示成功
    [SVProgressHUD showErrorWithStatus:errorReason];
}

- (MKAnnotationView *)mapView:(MKMapView *)mkMapView viewForAnnotation:(id <MKAnnotation>)annotation;
{
    static NSString *identifier = @"com.steal.trunk";
    MKAnnotationView *pin = [mkMapView dequeueReusableAnnotationViewWithIdentifier:identifier ];
    
    if (!pin)
    {
        pin = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier ];
        pin.image = [ UIImage imageNamed:@"near_annotation"];
        pin.canShowCallout=YES;
    }
    
    pin.annotation = annotation;
    return pin;
}


@end
