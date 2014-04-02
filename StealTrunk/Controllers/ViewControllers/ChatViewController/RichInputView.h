//
//  RichInputView.h
//  StealTrunk
//
//  Created by 点兄 on 13-8-7.
//
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "VoiceRecorderBase.h"

@protocol RichInputViewDelegate <NSObject>

@optional

//发送文字回调
- (void)sendText:(NSString *)text;

//发送语音回调
- (void)sendVoice:(NSString *)voice;

//文字高度回调
- (void)viewHeightChange:(CGFloat)diff;

//显示表情键盘
- (void)showEmojiKeybord:(BOOL)show;

@end

@interface RichInputView : UIView<HPGrowingTextViewDelegate,VoiceRecorderBaseDelegate>
{
    NSArray *peakImageArray;
}

@property (nonatomic, strong) UIView *contentView; //content input

@property (nonatomic, strong) UIButton *text_emojiBtn;
@property (nonatomic, strong) UIView *emojiKeyboard;

@property (nonatomic, strong) UIButton *text_voiceBtn; //文字、语音输入切换按钮
@property (nonatomic, strong) HPGrowingTextView *growingTextView;

@property (nonatomic, strong) UIButton *pushToTalkBtn;
@property (nonatomic, strong) VoiceRecorderBase *recorderBase;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) UIImageView *talkSendtip;
@property (nonatomic, assign) BOOL isCancle;
@property (nonatomic, assign) BOOL isPan;
@property (nonatomic, strong) UIImageView *imageViewBack;
@property (nonatomic, assign) id<RichInputViewDelegate>delegate;

- (void)hideKeyboard;

@end