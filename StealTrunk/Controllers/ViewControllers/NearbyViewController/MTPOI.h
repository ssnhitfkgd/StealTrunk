//
//  MTPOI.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-21.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Corelocation/Corelocation.h>

@interface MTPOI : NSObject <MKAnnotation>

@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,copy) NSString *title;

-(id) initWithCoords:(CLLocationCoordinate2D) coords;

@end
