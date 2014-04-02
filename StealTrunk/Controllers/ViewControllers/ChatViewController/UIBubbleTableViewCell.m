//
//  UIBubbleTableViewCell.m
//
//  Created by Alex Barinov
//  StexGroup, LLC
//  http://www.stexgroup.com
//
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//


#import "UIBubbleTableViewCell.h"
#import "NSBubbleData.h"

@interface UIBubbleTableViewCell ()


@property (nonatomic, retain)NCMusicEngine *musicEngine;
- (void) setupInternalData;
@end

@implementation UIBubbleTableViewCell
@synthesize musicEngine = _musicEngine;

@synthesize dataInternal = _dataInternal;

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
	[self setupInternalData];
}

- (void) dealloc
{
	_dataInternal = nil;
}

- (void)setDataInternal:(NSBubbleDataInternal *)value
{
	_dataInternal = value;
	[self setupInternalData];
}

- (void) setupInternalData
{
    
    self.musicEngine = [NCMusicEngine sharedPlayer];
    _musicEngine.delegate = (id)self;
     
    if (self.dataInternal.header)
    {
        headerLabel.hidden = NO;
        headerLabel.text = self.dataInternal.header;
    }
    else
    {
        headerLabel.hidden = YES;
    }
    
    NSBubbleSendType sendType = self.dataInternal.data.sendType;
    
    
    float x = (sendType == BubbleTypeSomeoneElse) ? 20 : self.frame.size.width - 20 - self.dataInternal.messageViewSize.width;
    float y = 5 + (self.dataInternal.header ? 30 : 10);
    
    if(BubbleMessageTypeText == self.dataInternal.data.messageType)
    {
        contentLabel.hidden = NO;
        audioImageView.hidden = YES;
        contentLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        contentLabel.frame = CGRectMake(x, y, self.dataInternal.messageViewSize.width, self.dataInternal.messageViewSize.height);
        contentLabel.text = self.dataInternal.data.messageData;
    }
    else if(BubbleMessageTypeImage == self.dataInternal.data.messageType)
    {
        contentLabel.hidden = YES;
        audioImageView.hidden = NO;
        
        mediaFocusManager = [[ASMediaFocusManager alloc] init];
        mediaFocusManager.delegate = self;
        [mediaFocusManager installOnViews:[NSArray arrayWithObject:audioImageView]];
        
        audioImageView.frame = CGRectMake(x, y, self.dataInternal.messageViewSize.width, self.dataInternal.messageViewSize.height);
        BOOL localFile = [[NSFileManager defaultManager] fileExistsAtPath:self.dataInternal.data.messageData];
        if(localFile)
        {
            [audioImageView setImage:[UIImage imageWithContentsOfFile:self.dataInternal.data.messageData]];
        }
        else
        {
            [audioImageView setImageWithURL:[NSURL URLWithString:self.dataInternal.data.messageData] placeholderImage:[UIImage imageNamed:@""]];
        }
        
        [audioImageView setUserInteractionEnabled:YES];
        //[audioImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageButtonClicked:)]];
    }
    else if(BubbleMessageTypeAudio == self.dataInternal.data.messageType)
    {
        contentLabel.hidden = YES;
        audioImageView.hidden = NO;
        
        NSMutableArray * animationImages = [[NSMutableArray alloc]init];
        for (int i = 1; i < 4; i++) {
            NSString * str = [NSString stringWithFormat:@"wave%d",i];
            if (self.dataInternal.data.sendType != BubbleTypeSomeoneElse) {
                str = [str stringByAppendingString:@"self"];
            }
            UIImage * img = [UIImage imageNamed:str];
            [animationImages addObject:img];
            
        }
        audioImageView.animationImages = animationImages;
        audioImageView.animationDuration = 1;
        NSString *imageWave = self.dataInternal.data.sendType == 1?@"wave":@"waveself";

        audioImageView.frame = CGRectMake(x, y, self.dataInternal.messageViewSize.width, self.dataInternal.messageViewSize.height);
        [audioImageView setImage:[UIImage imageNamed:imageWave]];
        [audioImageView setUserInteractionEnabled:YES];

        [audioImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(audioButtonClicked:)]];

    }
    
    
    if (sendType == BubbleTypeSomeoneElse)
    {
        bubbleImage.image = [[UIImage imageNamed:@"bubbleSomeone.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:16];
        bubbleImage.frame = CGRectMake(x - 18, y - 6, self.dataInternal.messageViewSize.width + 30, self.dataInternal.messageViewSize.height + 15);
    }
    else {
        bubbleImage.image = [[UIImage imageNamed:@"bubbleMine.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:16];
        bubbleImage.frame = CGRectMake(x - 9, y - 6, self.dataInternal.messageViewSize.width + 26, self.dataInternal.messageViewSize.height + 15);
    }
    
}

- (void)imageButtonClicked:(UIGestureRecognizer*)sender
{
    NSLog(@"imageButtonClicked");
}

- (void)audioButtonClicked:(UIGestureRecognizer*)sender
{
    if(!self.dataInternal.data.messageData)
        return;
    

    UIImageView *voiceWave = (id)sender.view;    
    if([voiceWave isAnimating])
    {
       [voiceWave stopAnimating];
    }
    else
    {
        [voiceWave startAnimating];
    }
    
    voiceWaveTemp = voiceWave;
    
    if([_musicEngine isPlaying])
    {
        [_musicEngine stop];
    }
    else
    {
        [_musicEngine stop];
        [_musicEngine playUrl:[NSURL URLWithString:self.dataInternal.data.messageData]];
    }
    NSLog(@"audioButtonClicked");
}

#pragma mark - ASEngineDelegate
- (void)engine:(NCMusicEngine *)engine didChangePlayState:(NCMusicEnginePlayState)playState
{
    if(playState != NCMusicEnginePlayStatePlaying)
    {
        [audioImageView stopAnimating];
    }
}

#pragma mark - ASMediaFocusDelegate
- (UIImage *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager imageForView:(UIView *)view
{
    return ((UIImageView *)view).image;
}

- (CGRect)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager finalFrameforView:(UIView *)view
{
    return self.viewController.view.bounds;//self.viewController.view.bounds;
}

- (UIViewController *)parentViewControllerForMediaFocusManager:(ASMediaFocusManager *)mediaFocusManager
{
    return self.viewController;
}


@end
