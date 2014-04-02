//
//  Global.h
//  StealTrunk
//
//  Created by wangyong on 13-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Global : NSObject

UINavigationController *selected_navigation_controller();

+ (NSString *)getServerBaseUrl;
+ (NSString *)getAppVersion;
@end

@interface UIColor (RGB)
+ (UIColor *)colorWithRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b;
@end

//////////////////////////////////////常用RGB//////////////////////////////////////
#define RGB246 RGB(246,246,246)
#define RGB240 RGB(240,240,240)
#define RGB218 RGB(218,218,218)
#define RGB165 RGB(165,169,170)
#define RGB140 RGB(140,143,145)
#define RGB89 RGB(89,94,98)

#define BenRed   RGB(245,97,86)
#define BenGreen RGB(118,198,22)
#define BenBlue RGB(51,204,204)