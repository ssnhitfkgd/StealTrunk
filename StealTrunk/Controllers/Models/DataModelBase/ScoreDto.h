//
//  ScoreDto.h
//  StealTrunk
//
//  Created by wangyong on 13-8-20.
//
//

#import "DataModelBase.h"

@interface ScoreDto : DataModelBase

@property (nonatomic, copy) NSString *score_photo_url;
@property (nonatomic, copy) NSString *score_name;
@property (nonatomic, copy) NSString *score_description;
@property (nonatomic, copy) NSString *score_state;
@end
