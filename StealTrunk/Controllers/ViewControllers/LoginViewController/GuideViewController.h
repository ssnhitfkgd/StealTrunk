//
//  GuideViewController.h
//  StealTrunk
//
//  Created by wangyong on 13-6-30.
//
//

#import <UIKit/UIKit.h>
#import "URBSegmentedControl.h"
#import "MapViewLocation.h"


@interface GuideViewController : UIViewController<UIScrollViewDelegate,MapViewLocationDelegate,UIAlertViewDelegate>


- (id)initPageIndex:(int)pageIndex;
@end
