//
//  CommentView.m
//  StealTrunk
//
//  Created by 点兄 on 13-8-6.
//
//

#import "CommentView.h"

@implementation CommentView
@synthesize DTO = _DTO;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor purpleColor];
    }
    return self;
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return 70;
}

- (void)setObject:(id)item
{
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        //self.DTO
    }
    
    [self setNeedsLayout];
}


@end
