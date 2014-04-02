//
//  MapViewLocation
//  StealTrunk
//
//  Created by wangyong on 13-7-1.
//
//

#import <MapKit/MapKit.h>
#import "CSqlite.h"

@protocol MapViewLocationDelegate <NSObject>
- (void)didCoordinateSuccess:(CLLocationCoordinate2D)coordinate;
- (void)didCoordinateFailed:(NSError*)error;
@end


@interface POI : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
- (id) initWithCoords:(CLLocationCoordinate2D) coords;
@end


typedef enum
{
    PLACE_COMMUNITY = 0,
    PLACE_OFFICE,
    PLACE_SCHOOL,
}PLACES_TYPE;

@interface MapViewLocation : MKMapView
<CLLocationManagerDelegate>
{
    CSqlite *locationSqlite;
    CLLocationManager *locationManager;
    CLLocationCoordinate2D coordinateGPS;
    NSString *radius;
}

@property(nonatomic, strong) id<MapViewLocationDelegate> sdelegate;
@property(nonatomic, assign) CLLocationCoordinate2D coordinateGPS;
@property(nonatomic, strong) NSArray *keywords;


+ (MapViewLocation *)shareInstance;
- (NSString *)getLocationRadius;
- (NSString *)getLocationKeywords:(PLACES_TYPE)placeType;
- (void)startWithDelegate:(id<MapViewLocationDelegate>)delegate;
- (void)stopLocate;//add by kevin

@end
