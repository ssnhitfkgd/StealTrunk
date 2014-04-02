//
//  TribeDTO.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-20.
//
//

#import "DataModelBase.h"

@interface TribeDTO : DataModelBase

@property (nonatomic, copy) NSString *tribe_id;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *tribe_name;
@property (nonatomic, copy) NSString *tribe_type;
@property (nonatomic, copy) NSString *farm_count;
@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, copy) NSMutableArray *top10_list;

- (BOOL)parse2:(NSDictionary *)result;
- (BOOL)parse:(NSDictionary *)dict;

@end
