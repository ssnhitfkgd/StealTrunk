//
//  EncodeUtil.h
//  StealTrunk
//
//  Created by wangyong on 13/7/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncodeUtil : NSObject

+ (NSString *)getMD5ForString:(NSString *)string;
+ (UIImage *)convertImage:(UIImage *)origImage scope:(CGFloat)scope;

@end
