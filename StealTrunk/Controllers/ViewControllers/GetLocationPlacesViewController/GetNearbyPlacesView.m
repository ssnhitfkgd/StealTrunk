//
//  GetNearbyPlacesView.m
//  StealTrunk
//
//  Created by wangyong on 13-7-4.
//
//

#import "GetNearbyPlacesView.h"

@implementation GetNearbyPlacesView
@synthesize placeTipImageView = _placeTipImageView;
@synthesize textLabel = _textLabel;
@synthesize locationDto = _locationDto;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createSubview];
    }
    return self;
}

+ (CGFloat)rowHeightForObject:(id)item
{
    
    //    if(item && [item isKindOfClass:[NSDictionary class]])
    //    {
    //    }
    
    return 44;
}

- (void)layoutSubviews
{
    
}

- (void)setObject:(id)item
{
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        self.locationDto = [[GetLocationDto alloc] init];
        if([_locationDto parse2:item])
        {
            [_textLabel setText:_locationDto.name];
        }
    }
    
    [self setNeedsLayout];
}

- (void)updateItem:(id)dto
{
    
}

- (void)createSubview
{
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];

    self.placeTipImageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    [_placeTipImageView setFrame:CGRectMake(3, 0, 38, 38)];
    [_placeTipImageView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ];
    [self addSubview:_placeTipImageView];
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(_placeTipImageView.right + 10, 0, 150, 20)];
    _textLabel.top = _placeTipImageView.top;
    [_textLabel setTextAlignment:UITextAlignmentLeft];
    [_textLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [_textLabel setBackgroundColor:[UIColor clearColor]];
    [_textLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
    [_textLabel setTextColor:[UIColor colorWithRed:30./255. green:30./255. blue:30./255. alpha:1.0]];
    _textLabel.font = [UIFont systemFontOfSize:14];
    [_textLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapped:)]];
    [self addSubview:_textLabel];
}



@end
