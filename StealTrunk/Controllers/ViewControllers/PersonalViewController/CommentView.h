//
//  CommentView.h
//  StealTrunk
//
//  Created by 点兄 on 13-8-6.
//
//

#import "BaseView.h"
#import "CommentDTO.h"

@interface CommentView : BaseView

@property (nonatomic, strong) CommentDTO *DTO;

- (void)setObject:(id)item;
+ (CGFloat)rowHeightForObject:(id)item;

@end
