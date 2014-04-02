//
//  UIBubbleTableViewCell.h
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


#import <UIKit/UIKit.h>
#import "NSBubbleDataInternal.h"
#import "ASMediaFocusManager.h"
#import "NCMusicEngine.h"

@interface UIBubbleTableViewCell : UITableViewCell<ASMediasFocusDelegate,NCMusicEngineDelegate>
{
    IBOutlet UILabel *headerLabel;
    IBOutlet UILabel *contentLabel;
    IBOutlet UIImageView *bubbleImage;
    IBOutlet UIImageView *audioImageView;
    ASMediaFocusManager *mediaFocusManager;
    UIImageView *voiceWaveTemp;

}

@property (nonatomic, strong) NSBubbleDataInternal *dataInternal;

@end
