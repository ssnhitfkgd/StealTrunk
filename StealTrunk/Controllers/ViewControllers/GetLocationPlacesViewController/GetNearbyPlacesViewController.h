//
//  GetNearbyPlacesViewController.h
//  StealTrunk
//
//  Created by wangyong on 13-7-4.
//
//

#import "TableApiViewController.h"
#import "MapViewLocation.h"


@interface GetNearbyPlacesViewController : TableApiViewController
{
    PLACES_TYPE placeType;
}

@property (nonatomic, strong) NSMutableArray *dataArray;

- (id)initWithRadius:(NSString *)radius keywords:(NSString *)keywords;
- (CLLocationCoordinate2D)getLocationCoordinate;
- (NSString*)getRadius;
- (NSString*)getKeywords;

@end
