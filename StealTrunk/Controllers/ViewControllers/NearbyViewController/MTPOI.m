//
//  MTPOI.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-21.
//
//

#import "MTPOI.h"

@implementation MTPOI

@synthesize coordinate = _coordinate;
@synthesize subtitle = _subtitle;
@synthesize title = _title;

- (id) initWithCoords:(CLLocationCoordinate2D) coords{
    
    self = [super init];
    
    if (self != nil) {
        
        _coordinate = coords;
        
    }
    
    return self;
    
}



@end
