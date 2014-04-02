//
//  NearbyPeopleCell.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-16.
//
//

#import <UIKit/UIKit.h>
#import "NearbyPeopleView.h"
#import "TableCellDelegate.h"

@interface NearbyPeopleCell : UITableViewCell<TableCellDelegate>

@property (nonatomic, strong) NearbyPeopleView *cellView;

@end
