//
//  RecommentDTO.h
//  lebo
//
//  Created by King on 13-4-24.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "DataModelBase.h"

@interface RecommentDTO : DataModelBase
{    
    Monstea_user_info *userInfo;
    
    NSInteger *attended;
}

@property (nonatomic, strong) Monstea_user_info *userInfo;
@property (nonatomic, readonly) NSInteger *attended;
@end
