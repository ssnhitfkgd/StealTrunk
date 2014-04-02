//
//  TribeView.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-20.
//
//

#import "BaseView.h"
#import "TribeDTO.h"

@interface TribeView : BaseView

@property (nonatomic, strong) UILabel *tribeInfo;

@property (nonatomic, strong) TribeDTO *tribeDTO;


- (void)setObject:(id)item;
+ (CGFloat)rowHeightForObject:(id)item;

@end
