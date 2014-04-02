//
//  ScoreView.m
//  StealTrunk
//
//  Created by wangyong on 13-8-20.
//
//

#import "ScoreView.h"

@implementation ScoreView
@synthesize scorePhotoImageView = _scorePhotoImageView;
@synthesize scoreNameLabel = _scoreNameLabel;
@synthesize scoreDescriptionLabel = _scoreDescriptionLabel;
@synthesize scoreState = _scoreState;

@synthesize scoreDto = _scoreDto;


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

- (void)setObject:(id)item
{
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        self.scoreDto = [[ScoreDto alloc] init];
        if([_scoreDto parse2:item])
        {
            [_scorePhotoImageView setImageWithURL:[NSURL URLWithString:_scoreDto.score_photo_url]];
            [_scoreNameLabel setText: _scoreDto.score_name];
            [_scoreDescriptionLabel setText:_scoreDto.score_description];
        }
    }
    
    [self setNeedsLayout];
}

- (void)createSubview
{
    self.scorePhotoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 34, 34)];
    _scorePhotoImageView.backgroundColor = [UIColor redColor];
    
    self.scoreNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_scorePhotoImageView.right + 10, 0, 200, 20)];
    [_scoreNameLabel setFont:[UIFont systemFontOfSize:14]];
    _scoreNameLabel.backgroundColor = [UIColor blueColor];
    
    self.scoreDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(_scorePhotoImageView.right + 10, 0, 0, 20)];
    [_scoreDescriptionLabel setFont:[UIFont systemFontOfSize:14]];
    _scoreDescriptionLabel.bottom = _scorePhotoImageView.bottom;
    _scoreDescriptionLabel.backgroundColor = [UIColor greenColor];
    
    
    [self addSubview:_scorePhotoImageView];
    [self addSubview:_scoreNameLabel];
    [self addSubview:_scoreDescriptionLabel];
}




@end
