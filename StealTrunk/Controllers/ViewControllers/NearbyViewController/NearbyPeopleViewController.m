//
//  NearbyPeopleViewController.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-11.
//
//

#import "NearbyPeopleViewController.h"
#import "NearbyPeopleCell.h"
#import "MTPOI.h"

@interface NearbyPeopleViewController ()
{
    //MKMapView *mapView;
}

@end

@implementation NearbyPeopleViewController
//@synthesize myCoordinate = _myCoordinate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"附近的人", nil);
        [[MapViewLocation shareInstance] startWithDelegate:self];
        //初始化为无效坐标
        self.myCoordinate = CLLocationCoordinate2DMake(300, 300);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
//    [mapView setDelegate:(id)self];
//    mapView.userInteractionEnabled = YES;
//    mapView.mapType = MKMapTypeStandard;
//    
//    [self.tableView setTableHeaderView:mapView];
    self.enableHeader = YES;
}

- (void)didFinishLoad:(id)objc
{
    [super didFinishLoad:objc];
    [self.tableView setSeparatorColor:RGB(239, 239, 239)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SuperView
- (Class)cellClass {
    //NSAssert(NO, @"subclasses to override");
    return [NearbyPeopleCell class];
}

- (API_GET_TYPE)modelApi
{
    API_GET_TYPE type = -1;
    
    //取到地理位置后再发
    if (CLLocationCoordinate2DIsValid(self.myCoordinate)) {
        type = API_LIST_NEARBY_PEOPLE;
    }
    
    return type;
}

- (NSString *)getGender
{
    //0:全部 1:男 2:女
    return @"0";
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
//        MKCoordinateRegion region =
//        MKCoordinateRegionMakeWithDistance(self.myCoordinate, 2000, 2000);
//        [mapView setRegion:region animated:YES];
//        
//        MTPOI *POI = [[MTPOI alloc] initWithCoords:self.myCoordinate];
//        [mapView  addAnnotation:POI];
        [self reloadData];
    }
}


//- (MKAnnotationView *)mapView:(MKMapView *)mkMapView viewForAnnotation:(id <MKAnnotation>)annotation;
//{
//    static NSString *identifier = @"com.steal.trunk";
//    MKAnnotationView *pin = [mkMapView dequeueReusableAnnotationViewWithIdentifier:identifier ];
//    
//    if (!pin)
//    {
//        pin = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier ];
//        pin.image = [ UIImage imageNamed:@"near_annotation"];
//        pin.canShowCallout=YES;
//    }
//    
//    pin.annotation = annotation;
//    return pin;
//}

- (void)didCoordinateFailed:(NSError*)error
{
    //
#warning error 是什么？ 没开定位？没网络？还是什么原因？定位失败 或者用户禁止定位
}

@end
