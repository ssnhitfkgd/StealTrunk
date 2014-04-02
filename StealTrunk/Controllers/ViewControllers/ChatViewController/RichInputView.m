//
//  RichInputView.m
//  StealTrunk
//
//  Created by 点兄 on 13-8-7.
//
//

#import "RichInputView.h"

#define INPUT_SINGLE_LINE_HEIGHT 38 //预定义文本输入框单行高度
#define INPUT_FONT_SIZE        16 //预定义文本输入框字体
#define SUBVIEW_HEIGHT 34.0 //输入框subview高度
#define SUBVIEW_TAG 4.0 //输入框subview的间距

#define EMOJI_KEYBOARD_HEIGHT 216.0

@interface RichInputView()

- (void)text_voiceBtnPress:(id)sender;
- (void)emojiBtnPress:(id)sender;

@end

@implementation RichInputView
@synthesize delegate = _delegate;

@synthesize contentView = _contentView;
@synthesize growingTextView = _growingTextView;
@synthesize text_voiceBtn = _text_voiceBtn;
@synthesize text_emojiBtn = _text_emojiBtn;
@synthesize pushToTalkBtn = _pushToTalkBtn;
@synthesize recorderBase = _recorderBase;
@synthesize recorder = _recorder;
@synthesize emojiKeyboard = _emojiKeyboard;
@synthesize talkSendtip = _talkSendtip;
@synthesize isPan = _isPan;
@synthesize isCancle = _isCancle;
@synthesize imageViewBack = _imageViewBack;

- (id)init
{
    self = [super init];
    
    if (self) {
        
        self.frame = CGRectMake(0, 0, 320, SUBVIEW_HEIGHT+SUBVIEW_TAG*2+EMOJI_KEYBOARD_HEIGHT);
        self.autoresizesSubviews = YES;
        self.clipsToBounds = NO;
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SUBVIEW_HEIGHT+SUBVIEW_TAG*2)];
        self.contentView.autoresizesSubviews = YES;
        self.contentView.backgroundColor = RGB(237, 237, 237);
        
        self.recorderBase = [[VoiceRecorderBase alloc] init];
        self.recorderBase.vrbDelegate = self;
        
        ///////////////////////////////////////subview/////////////////////////////////////////////
        //语音、文字切换按钮
        UIImage * imgVoice = [UIImage imageNamed:@"voice"];
        UIImage * imgTextBlue = [UIImage imageNamed:@"txt_blue"];
        self.text_voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.text_voiceBtn.frame = CGRectMake(SUBVIEW_TAG, SUBVIEW_TAG, SUBVIEW_HEIGHT, SUBVIEW_HEIGHT);
        [self.text_voiceBtn setBackgroundImage:imgVoice forState:UIControlStateNormal];
        [self.text_voiceBtn setBackgroundImage:imgTextBlue forState:UIControlStateSelected];
        [self.text_voiceBtn addTarget:self action:@selector(text_voiceBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        self.text_voiceBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        
        //文字输入
        self.growingTextView = [[HPGrowingTextView alloc] init];
        self.growingTextView.font = [UIFont systemFontOfSize:INPUT_FONT_SIZE];
        self.growingTextView.delegate = self;
        self.growingTextView.internalTextView.backgroundColor = [UIColor whiteColor];
        self.growingTextView.frame = CGRectMake(0, 0, self.contentView.width-(SUBVIEW_TAG*2+SUBVIEW_HEIGHT)*2, SUBVIEW_HEIGHT - 20);
        self.growingTextView.left = self.text_voiceBtn.right + SUBVIEW_TAG;
        self.growingTextView.centerY = self.contentView.height/2.0 - 10;
        self.growingTextView.returnKeyType = UIReturnKeySend;
        self.growingTextView.maxNumberOfLines = 3;
        self.growingTextView.contentMode = UIControlContentVerticalAlignmentBottom;
        [self.growingTextView setHeight:30];
        self.growingTextView.top = 7;
        self.growingTextView.internalTextView.enablesReturnKeyAutomatically = YES;
        
        //语音输入
        self.pushToTalkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.pushToTalkBtn.backgroundColor = [UIColor yellowColor];
        self.pushToTalkBtn.frame = self.growingTextView.frame;
        [self.pushToTalkBtn setTitle:NSLocalizedString(@"按住说话", nil) forState:UIControlStateNormal];
        [self.pushToTalkBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        self.pushToTalkBtn.hidden=YES;
        [self.pushToTalkBtn addTarget:self action:@selector(onTalkTouchDown:) forControlEvents:UIControlEventTouchDown];
        [self.pushToTalkBtn addTarget:self action:@selector(onTalkTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //表情输入
        UIImage *imgFace = [UIImage imageNamed:@"happy"];
        UIImage *imgText = [UIImage imageNamed:@"txt_blue"];
        self.text_emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.text_emojiBtn.frame = CGRectMake(0, 0, imgFace.size.width,20);
        self.text_emojiBtn.left = self.growingTextView.right+SUBVIEW_TAG;
        self.text_emojiBtn.top = self.text_voiceBtn.top + 8;
        [self.text_emojiBtn setTitle:@"发送" forState:UIControlStateNormal];
        [self.text_emojiBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [self.text_emojiBtn setBackgroundColor:RGB(120,196,44)];
//        [self.text_emojiBtn setBackgroundImage:imgFace forState:UIControlStateNormal];
//        [self.text_emojiBtn setBackgroundImage:imgText forState:UIControlStateSelected];
        [self.text_emojiBtn addTarget:self action:@selector(text_emojiBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        self.text_emojiBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        
        self.emojiKeyboard = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, EMOJI_KEYBOARD_HEIGHT)];
        self.emojiKeyboard.backgroundColor = [UIColor blueColor];
        self.emojiKeyboard.top = self.contentView.bottom + 10;
        
        [self.contentView addSubview:self.text_voiceBtn];
        [self.contentView addSubview:self.text_emojiBtn];
        [self.contentView addSubview:self.growingTextView];
        [self.contentView addSubview:self.pushToTalkBtn];
        [self addSubview:self.contentView];
        [self addSubview:self.emojiKeyboard];
        
        self.imageViewBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"audio_state_back"]];
        [self addSubview:_imageViewBack];
        _imageViewBack.center = self.center;
        _imageViewBack.centerY = -200;
        _imageViewBack.hidden = YES;
        
        

        self.talkSendtip = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 41, 69)];
        //_talkSendtip.hidden = YES;
        [_imageViewBack addSubview:_talkSendtip];
        _talkSendtip.left = 54;
        _talkSendtip.top = 40;
        
        [self.pushToTalkBtn addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleTalkGesture:)]];
        
        
        peakImageArray = [[NSArray alloc]initWithObjects:
                        [UIImage imageNamed:@"speaker_0.png"],
                        [UIImage imageNamed:@"speaker_1.png"],
                        [UIImage imageNamed:@"speaker_2.png"],
                        [UIImage imageNamed:@"speaker_3.png"],
                        [UIImage imageNamed:@"speaker_4.png"],
                        [UIImage imageNamed:@"speaker_5.png"],
                        [UIImage imageNamed:@"speaker_6.png"],
                        [UIImage imageNamed:@"speaker_7.png"],
                        [UIImage imageNamed:@"speaker_8.png"],
                        [UIImage imageNamed:@"speaker_9.png"],
                        [UIImage imageNamed:@"speaker_10.png"],
                        [UIImage imageNamed:@"speaker_11.png"],
                        [UIImage imageNamed:@"speaker_12.png"],
                        [UIImage imageNamed:@"speaker_13.png"],
                        [UIImage imageNamed:@"speaker_14.png"],
                        nil];
    }
    
    return self;
}

#pragma mark - Actions
- (void)text_voiceBtnPress:(id)sender
{
    self.text_voiceBtn.selected = !self.text_voiceBtn.selected;
    
    //selected：输入语音
    if (self.text_voiceBtn.selected) {
        self.text_emojiBtn.selected = NO;
        [self inputVoice];
        [self hideKeyboard];
        
        if ([self.delegate respondsToSelector:@selector(showEmojiKeybord:)]) {
            [self.delegate showEmojiKeybord:NO];
        }
        
    }else {
        [self inputText];
    }
}

- (void)text_emojiBtnPress:(id)sender
{
    [self growingTextViewShouldReturn:self.growingTextView];
    return;
    self.text_emojiBtn.selected = !self.text_emojiBtn.selected;
    
    //selected：输入表情
    if (self.text_emojiBtn.selected) {
        [self inputEmoji];
        
        [self hideKeyboard];
        
        self.text_voiceBtn.selected = NO;
        self.growingTextView.hidden = NO;
        self.pushToTalkBtn.hidden = YES;
    }else {
        [self inputText];
    }
}

- (void)hideKeyboard
{
    [self.growingTextView.internalTextView resignFirstResponder];
}

- (void)inputText
{
    self.growingTextView.hidden = NO;
    [self.growingTextView becomeFirstResponder];
    
    self.pushToTalkBtn.hidden = YES;
}
- (void)inputVoice
{
    self.growingTextView.hidden = YES;
    [self.growingTextView resignFirstResponder];
    
    self.pushToTalkBtn.hidden = NO;
}
- (void)inputEmoji
{
    [self.growingTextView resignFirstResponder];
    
    //显示表情键盘
    if ([self.delegate respondsToSelector:@selector(showEmojiKeybord:)]) {
        [self.delegate showEmojiKeybord:YES];
    }
}

#pragma mark - 文字输入相关
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
    
    float diff = growingTextView.height - height;
    
    float bottom = self.bottom;
    
    self.height -= diff;
    
    self.bottom = bottom;
    
    if ([self.delegate respondsToSelector:@selector(viewHeightChange:)]) {
        [self.delegate viewHeightChange:diff];
    }
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView{
    
    //空字段判断
    if (growingTextView.text != nil && ![[growingTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]isEqualToString:@""]){
        
        [self.delegate sendText:growingTextView.text];
        
        self.growingTextView.text = nil;
    }
    
    return YES;
}


#pragma mark - 语音输入相关
- (void)handleTalkGesture:(UIPanGestureRecognizer *)pan{
    
    CGPoint point = [pan locationInView:self];
    CGRect containsRect = self.contentView.frame;
    containsRect.size.height += 30;//加大操作空间
    containsRect.origin.y -= 30;
    self.isCancle = !CGRectContainsPoint(_pushToTalkBtn.frame, point);
    if(self.isCancle)
    {
        if(!CGRectContainsPoint(_imageViewBack.frame,point))
        {
            [_talkSendtip setImage:[UIImage imageNamed:@"audio_delete_ready"]];
        }
        else
        {
            [_talkSendtip setImage:[UIImage imageNamed:@"audio_ready_delete"]];
        }
    }
//    else
//    {
//        [_talkSendtip setImage:[UIImage imageNamed:@"speaker_5"]];
//    }
    NSLog(@"%d",self.isCancle);
    self.isPan = YES;
    
    if (UIGestureRecognizerStateEnded == pan.state){
        //_talkSendtip.hidden = YES;
        _imageViewBack.hidden = YES;
        [self.recorder stop];
        [self.pushToTalkBtn setTitle:NSLocalizedString(@"按住说话", nil) forState:UIControlStateNormal];

    }
}

- (void)onTalkTouchDown:(UIButton *)sender{
    self.isPan = NO;
    //_talkSendtip.hidden = NO;
    _imageViewBack.hidden = NO;

    [sender setTitle:@"松开停止" forState:UIControlStateNormal];
    [self beginRecordByFileName:[self.recorderBase getCurrentTimeString]];
    [self performSelector:@selector(updateMetersByAvgPower) withObject:nil afterDelay:0.2];
}


- (void)updateMetersByAvgPower{
        //-160表示完全安静，0表示最大输入值
        //
    
    if(self.isCancle)
    {
        [self performSelector:@selector(updateMetersByAvgPower) withObject:nil afterDelay:0.1];
        return;
    }
    [_recorder updateMeters];
    int _avgPower = [_recorder averagePowerForChannel:0];
    NSInteger imageIndex = 0;
    if ( _avgPower < -90)
        imageIndex = 0;
    else if (_avgPower >= -90 && _avgPower < -85)
        imageIndex = 1;
    else if (_avgPower >= -80 && _avgPower < -75)
        imageIndex = 2;
    else if (_avgPower >= -75 && _avgPower < -70)
        imageIndex = 3;
    else if (_avgPower >= -70 && _avgPower < -65)
        imageIndex = 4;

    else if (_avgPower >= -65 && _avgPower < -55)
        imageIndex = 5;

    else if (_avgPower >= -55 && _avgPower < -50)
        imageIndex = 6;

    else if (_avgPower >= -50 && _avgPower < -45)
        imageIndex = 7;

    else if (_avgPower >= -45 && _avgPower < -30)
        imageIndex = 8;
    else if (_avgPower >= -30 && _avgPower < -25)
        imageIndex = 9;
    else if (_avgPower >= -25 && _avgPower < -20)
        imageIndex = 10;
    else if (_avgPower >= -20 && _avgPower < -15)
        imageIndex = 11;
    else if (_avgPower >= -15 && _avgPower < -10)
        imageIndex = 12;
    else if (_avgPower >= -10 && _avgPower < -5)
        imageIndex = 13;
    else if (_avgPower >= -5 && _avgPower <= 0)
        imageIndex = 14;

    imageIndex += -1;
    _talkSendtip.image = [peakImageArray objectAtIndex:imageIndex];
    [self performSelector:@selector(updateMetersByAvgPower) withObject:nil afterDelay:0.2];
}

- (void)onTalkTouchUpInside:(UIButton *)sender{
    if (self.isPan) {
        return;
    }
    
    _imageViewBack.hidden = YES;
    //_talkSendtip.hidden = YES;
    self.isCancle = NO;
    [self.recorder stop];
}

//开始录音
- (void)beginRecordByFileName:(NSString*)_fileName{
    
    //设置文件名和录音路径
    self.recorderBase.recordFileName = _fileName;
    self.recorderBase.recordFilePath = [self.recorderBase getPathByFileName:self.recorderBase.recordFileName ofType:@"wav"];
    NSLog(@"%@",self.recorderBase.recordFilePath);
    self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:self.recorderBase.recordFilePath]
                                                settings:[self.recorderBase getAudioRecorderSettingDict]
                                                   error:nil];
    self.recorder.delegate = (id)self;
    self.recorder.meteringEnabled = YES;
    
    
    [self.recorder prepareToRecord];
    
    //开始录音
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [self.recorder record];
    
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    
    //[SVProgressHUD showWithStatus:NSLocalizedString(@"发布中...", nil) maskType:SVProgressHUDMaskTypeGradient];
    if (!self.isCancle) {
        //转格式
        NSString *amrFilePath = [self.recorderBase getPathByFileName:[self.recorderBase getCurrentTimeString] ofType:@"amr"];
        if(0 == [self.recorderBase wavToAmr:[self.recorder.url absoluteString]  amrSavePath:amrFilePath])
        {
            [[NSFileManager defaultManager] removeItemAtPath:[self.recorder.url absoluteString]  error:nil];
            
            if ([self.delegate respondsToSelector:@selector(sendVoice:)]) {
                [self.delegate sendVoice:amrFilePath];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"sorry，录音失败", nil)];
        }
    }
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags{
    NSLog(@"录音中断");
}

- (void)VoiceRecorderBaseRecordFinish:(NSString *)_filePath fileName:(NSString*)_fileName
{
    //do something
}

@end
