//
//  MapViewLocation.m
//  StealTrunk
//
//  Created by wangyong on 13-7-1.
//
//

#import "MapViewLocation.h"


@implementation MapViewLocation
@synthesize sdelegate;
@synthesize coordinateGPS;
@synthesize keywords;

static MapViewLocation *instance = nil;

+ (MapViewLocation *)shareInstance
{
    if (instance == nil) {
        instance = [[MapViewLocation alloc] init];
    }
    return instance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        locationSqlite = [[CSqlite alloc] init];
        [locationSqlite openSqlite];

        self.showsUserLocation = YES;//显示ios自带的我的位置显示
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = 0.5;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        self.keywords = [NSArray arrayWithObjects:@"小区", @"办公楼", @"学校", nil];
    }
    return self;
}

- (NSString *)getLocationRadius
{
    return @"5000";
}

- (NSString *)getLocationKeywords:(PLACES_TYPE)placeType
{
    return self.keywords[placeType];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)startWithDelegate:(id<MapViewLocationDelegate>)delegate
{
    sdelegate = delegate;
    self.showsUserLocation = YES;
    if ([CLLocationManager locationServicesEnabled]) { // 检查定位服务是否可用
        [locationManager startUpdatingLocation]; // 开始定位
    }
}

//add by kevin
- (void)stopLocate
{
    [locationManager stopUpdatingLocation];
}

#pragma mark - MKMapViewDelegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    CLLocationCoordinate2D mylocation = newLocation.coordinate;//手机GPS
    //lat.text = [[NSString alloc]initWithFormat:@"%lf",mylocation.latitude];
    //llong.text = [[NSString alloc]initWithFormat:@"%lf",mylocation.longitude];
    
    mylocation = [self translateGPS:mylocation];///火星GPS
    
    [self setMapPoint:mylocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray* placemarks,NSError *error)
     {
         if (placemarks.count >0   )
         {
             CLPlacemark * plmark = [placemarks objectAtIndex:0];
             
             NSString * country = plmark.country;
             NSString * city    = plmark.locality;
             NSLog(@"%@-%@-%@",country,city,plmark.name);
         }
         
         NSLog(@"%@",placemarks);
         
     }];
    
    
    if([sdelegate respondsToSelector:@selector(didCoordinateSuccess:)])
    {
        if(self.coordinateGPS.latitude == mylocation.latitude &&  self.coordinateGPS.longitude == mylocation.longitude )
        {
            self.userInteractionEnabled = NO;
        }
        [sdelegate didCoordinateSuccess:mylocation];
    }
    
    self.coordinateGPS = mylocation;

    
}
// 定位失败时调用
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"定位失败");
    if([sdelegate respondsToSelector:@selector(didCoordinateFailed:)])
    {
        [sdelegate didCoordinateFailed:error];
    }
    //[self startWithDelegate:sdelegate];
}

- (CLLocationCoordinate2D)translateGPS:(CLLocationCoordinate2D)coordinateGps
{
    int TenLat = 0;
    int TenLog = 0;
    TenLat = (int)(coordinateGps.latitude * 10);
    TenLog = (int)(coordinateGps.longitude * 10);
    NSString *sql = [[NSString alloc]initWithFormat:@"select offLat,offLog from gpsT where lat=%d and log = %d",TenLat,TenLog];
    sqlite3_stmt *stmtL = [locationSqlite NSRunSql:sql];
    
    int offLat = 0;
    int offLog = 0;
    while (sqlite3_step(stmtL)==SQLITE_ROW)
    {
        offLat = sqlite3_column_int(stmtL, 0);
        offLog = sqlite3_column_int(stmtL, 1);
        
    }
    coordinateGps.latitude = coordinateGps.latitude + offLat*0.0001;
    coordinateGps.longitude = coordinateGps.longitude + offLog*0.0001;
    return coordinateGps;
    
    
}

- (void)setMapPoint:(CLLocationCoordinate2D)myLocation
{
    //return;
    //POI* m_poi = [[POI alloc] initWithCoords:myLocation];
    //[self addAnnotation : m_poi];
    MKCoordinateRegion theRegion = { {0.0, 0.0 }, { 0.0, 0.0 } };
    theRegion.center = myLocation;
    [self setZoomEnabled: YES];
    [self setScrollEnabled: YES];
    theRegion.span.longitudeDelta = 0.01f;
    theRegion.span.latitudeDelta = 0.01f;
    [self setRegion:theRegion animated:YES];
}

- (void)dealloc
{
    [locationSqlite closeSqlite];
    locationSqlite = nil;
}

@end

@implementation POI

@synthesize coordinate,subtitle,title;

- (id)initWithCoords:(CLLocationCoordinate2D) coords{
    
    self = [super init];
    
    if (self != nil) {
        coordinate = coords;
    }
    
    return self;
}


@end
