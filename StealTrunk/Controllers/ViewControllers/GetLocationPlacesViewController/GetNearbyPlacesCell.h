//
//  GetNearbyPlacesCell.h
//  StealTrunk
//
//  Created by wangyong on 13-7-4.
//
//

#import <UIKit/UIKit.h>
#import "GetNearbyPlacesView.h"
#import "TableCellDelegate.h"


@interface GetNearbyPlacesCell : UITableViewCell<TableCellDelegate>

@property(nonatomic, strong) GetNearbyPlacesView *nearbyPlacesView;
@end
