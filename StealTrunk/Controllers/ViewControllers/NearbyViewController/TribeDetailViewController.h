//
//  TribeDetailViewController.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-21.
//
//

#import "TableApiViewController.h"
#import "TribeDTO.h"
#import <MapKit/MKMapView.h>
#import "MapViewLocation.h"

@interface TribeDetailViewController : TableApiViewController<MapViewLocationDelegate>
@property (nonatomic, strong) TribeDTO *DTO;
@property (nonatomic, strong) MKMapView *mapView;

+ (TribeDetailViewController *)creatWithDTO:(TribeDTO *)DTO;

- (void)joinTribe:(id)sender;
@end
