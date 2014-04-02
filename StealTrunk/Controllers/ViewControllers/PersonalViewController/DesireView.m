//
//  DesireView.m
//  StealTrunk
//
//  Created by wangyong on 13-7-17.
//
//

#import "DesireView.h"
#import "Global.h"

#define DESIRE_VIEW_HEIGHT 90.f
#define DESIRE_VIEW_WIDTH 90.f

#define ROW_HEIGHT 106.f

@implementation DesireView
@synthesize desireImageView = _desireImageView;
@synthesize desireNameLabel = _desireNameLabel;
@synthesize delImageView = _delImageView;


+ (CGFloat)rowHeightForObject{
    return  ROW_HEIGHT;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createSubview];
    }
    return self;
}

- (void)createSubview
{
    // TODO: this is nothing but a poor man's solution
    // may want to turn to three20's mighty TTStyledTextLabel later on.
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];

    self.userInteractionEnabled = YES;

    self.desireImageView = [[UIImageView alloc] initWithFrame:CGRectMake((DESIRE_VIEW_WIDTH - 170/2)/2, (DESIRE_VIEW_WIDTH - 152/2 - 18)/2, 170/2, 152/2)];
    [_desireImageView.layer setBackgroundColor:[UIColor clearColor].CGColor];
    [_desireImageView setBackgroundColor:[UIColor clearColor]];
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setFrame:CGRectMake(0, 0, DESIRE_VIEW_WIDTH, DESIRE_VIEW_HEIGHT)];
    //[button addSubview:_desireImageView];
    [_button setUserInteractionEnabled:YES];
    [_button addTarget:self action:@selector(desireBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    //[_button setBackgroundColor:[UIColor redColor]];
    [_button.layer addSublayer:_desireImageView.layer];
    [self addSubview:_button];
    
    self.desireNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 106 - 24, DESIRE_VIEW_WIDTH, 20)];
    _desireNameLabel.centerX = _desireImageView.centerX;
    _desireNameLabel.font = [UIFont boldSystemFontOfSize:14];
    _desireNameLabel.textColor = [UIColor whiteColor];
    _desireNameLabel.backgroundColor = [UIColor clearColor];
    [_button addSubview:_desireNameLabel];
    
    
    self.delImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-2, -2, 12, 12)];
    [_delImageView setImage:[UIImage imageNamed:@"success.png"]];

    UILongPressGestureRecognizer *longPrees = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(recordBtnLongPressed:)];
    longPrees.delegate = (id)self;
    [_button addGestureRecognizer:longPrees];
    

}

- (void)recordBtnLongPressed:(UILongPressGestureRecognizer*) longPressedRecognizer
{
    //长按开始
    if(longPressedRecognizer.state == UIGestureRecognizerStateBegan) {
        if(![_delImageView isDescendantOfView:longPressedRecognizer.view])
            [longPressedRecognizer.view addSubview:_delImageView];
    }//长按结束
    else if(longPressedRecognizer.state == UIGestureRecognizerStateEnded || longPressedRecognizer.state == UIGestureRecognizerStateCancelled){
    }
    
}

- (UIImage *)getRandomColor:(int)fromValue toValue:(int)toValue
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"desireBackGround_%d",(uint)(fromValue + (arc4random() % (toValue - fromValue + 1)))]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)setObject:(id)item {
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        
        NSString *desireImageURL = [item objectForKey:@"desireImageUrl"];
        NSString *desireName = [item objectForKey:@"desire"];
        NSString *colorTag = [item objectForKey:@"colorTag"];
        if (desireImageURL && desireName && colorTag) {
            [_desireImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Global getServerBaseUrl], desireImageURL]]];
            [_desireNameLabel setText:[NSString stringWithFormat:@"#%@#",desireName]];
            [_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"desire_back_%@.png", colorTag]] forState:UIControlStateNormal];
            [_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"desire_back_%@_select.png", colorTag]] forState:UIControlStateHighlighted];
        }
        NSLog(@"desireURL %@", [NSString stringWithFormat:@"%@%@",[Global getServerBaseUrl],desireImageURL]);
    }
}

- (void)desireBtnTapped:(id)sender
{

}

@end
