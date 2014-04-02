//
//  TaskDto.h
//  StealTrunk
//
//  Created by wangyong on 13-8-20.
//
//

#import "DataModelBase.h"

@interface TaskDto : DataModelBase

@property (nonatomic, copy) NSString *task_photo_url;
@property (nonatomic, copy) NSString *task_name;
@property (nonatomic, copy) NSString *task_description;
@property (nonatomic, copy) NSString *task_state;
@end
