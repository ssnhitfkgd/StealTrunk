//
//  TribeView.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-20.
//
//

#import "TribeView.h"

@implementation TribeView
@synthesize tribeInfo = _tribeInfo;
@synthesize tribeDTO = _tribeDTO;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self createSubview];
        
        self.clipsToBounds = YES;
        self.height = 80;
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

- (void)setObject:(id)item
{
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        self.tribeDTO = [[TribeDTO alloc] init];
        if([self.tribeDTO parse2:item])
        {
            self.tribeInfo.text = [NSString stringWithFormat:@"%@-%@-%@",self.tribeDTO.tribe_name,self.tribeDTO.tribe_type,self.tribeDTO.farm_count];
        }
    }
    
    [self setNeedsLayout];
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return 80;
}

- (void)createSubview
{
    self.tribeInfo = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 40)];
    [self addSubview:self.tribeInfo];
}

@end
