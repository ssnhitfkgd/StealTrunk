//
//  DesireCell.m
//  StealTrunk
//
//  Created by wangyong on 13-7-17.
//
//

#import "DesireCell.h"
#import "DesireView.h"

@implementation DesireCell
@synthesize channelViewArray = _channelViewArray;

static const CGFloat dx = 106.f;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.channelViewArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 3; i++) {
            DesireView *channelView = [[DesireView alloc] initWithFrame:CGRectMake(i*(dx+1), 0, dx, dx)];
            [channelView setHidden:YES];
             [_channelViewArray addObject:channelView];
            [self.contentView addSubview:channelView];
        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setObject:(id)item
{
    if(item == nil)
        return;
    
    for(int i = 0; i < [item count]; i++)
    {
        if([item count] - i > 0){
            DesireView *desireView = [_channelViewArray objectAtIndex:i];
            if(desireView)
            {
                [desireView setHidden:NO];
                [desireView setObject:[item objectAtIndex:i]];
            }
        }
    }
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return [DesireView rowHeightForObject];
}

@end
