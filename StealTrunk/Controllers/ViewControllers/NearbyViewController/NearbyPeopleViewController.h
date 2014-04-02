//
//  NearbyPeopleViewController.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-11.
//
//

#import "TableApiViewController.h"
#import "MapViewLocation.h"

@interface NearbyPeopleViewController : TableApiViewController//<MapViewLocationDelegate>

@property (nonatomic, assign) CLLocationCoordinate2D myCoordinate;

@end
