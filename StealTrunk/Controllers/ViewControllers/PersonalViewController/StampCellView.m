//
//  StampCellView.m
//  StealTrunk
//
//  Created by 点兄 on 13-8-9.
//
//

#import "StampCellView.h"
#import "StampDTO.h"

@implementation StampCellView
@synthesize DTO = _DTO;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor purpleColor];
        self.height = 50;
    }
    return self;
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return 50;
}

- (void)setObject:(id)item
{
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        self.DTO = [[StampDTO alloc] init];
        [self.DTO parse2:item];
    }
    
    [self setNeedsLayout];
}


@end
