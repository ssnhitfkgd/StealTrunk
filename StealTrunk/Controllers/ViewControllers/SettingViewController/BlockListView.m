//
//  BlockListView.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-22.
//
//

#import "BlockListView.h"

@implementation BlockListView
@synthesize userInfo = _userInfo;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createSubview];
        
        self.clipsToBounds = YES;
        self.height = 70;
        self.backgroundColor = [UIColor brownColor];
    }
    return self;
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return 70;
}

- (void)layoutSubviews
{
    
}

- (void)setObject:(id)item
{
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        self.userInfo = [[Monstea_user_info alloc] init];
        [self.userInfo parseWithDic:item];
        //
        
    }
    
    [self setNeedsLayout];
}

- (void)updateItem:(id)dto
{
    
}

- (void)createSubview
{

}

@end
