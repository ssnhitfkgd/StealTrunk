//
//  PublishViewController.m
//  StealTrunk
//
//  Created by 点兄 on 13-8-1.
//
//

#import "PublishViewController.h"
#import "FileClient.h"
#import "CircularProgressView.h"

typedef enum{
    RecordStatusNormal = 0,
    RecordStatusPreparing,
    RecordStatusRecording,
} RecordStatus;

@interface PublishViewController ()

@property (nonatomic, strong) IBOutlet UIButton *closeBtn;
@property (nonatomic, strong) IBOutlet UIButton *publishBtn;
@property (nonatomic, strong) IBOutlet UIScrollView *sceneScroll;
@property (nonatomic, strong) IBOutlet UIPageControl *scenePageControl;
@property (nonatomic, strong) IBOutlet UIButton *emojiBtn;
@property (nonatomic, strong) IBOutlet UIScrollView *emojiScrol;
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IBOutlet UIButton *recordBtn;
@property (nonatomic, strong) IBOutlet UIImageView *micLight;
@property (nonatomic, strong) IBOutlet UIButton *deleteBtn;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) VoiceRecorderBase *recorderBase;
@property (nonatomic, strong) IBOutlet UIButton *playBtn;
@property (nonatomic, strong) IBOutlet UIView *shareView;
@property (nonatomic, strong) IBOutlet UIView *popeLeftView;
@property (nonatomic, strong) IBOutlet UIView *popeRightView;
@property (nonatomic, strong) IBOutlet CircularProgressView *circularProgressView;

@property (nonatomic, strong) NSTimer *monitorTimer;

@property (nonatomic, strong) NSMutableArray *scenes;
@property (nonatomic, strong) NSMutableArray *emojies;

- (IBAction)closeBtnPress:(id)sender;
- (IBAction)publishBtnPress:(id)sender;
- (IBAction)deleteBtnPress:(id)sender;
- (IBAction)playBtnPress:(id)sender;
- (IBAction)recordBtnPress:(id)sender;
- (IBAction)emojiBtnPress:(id)sender;

/*
 * 录音 or 播放录音
 */
- (void)statusChange:(BOOL)is_record;

/*
 * 录音状态：正常、准备中、录音中
 */
- (void)recordStatus:(RecordStatus)status;

/*
 * 表情键盘动画，is_show：True－出现，False－隐藏
 */
- (void)emojiScrolAnimation:(BOOL)is_show;

@end

@implementation PublishViewController
@synthesize closeBtn = _closeBtn;
@synthesize publishBtn = _publishBtn;
@synthesize sceneScroll = _sceneScroll;
@synthesize scenePageControl = _scenePageControl;
@synthesize emojiBtn = _emojiBtn;
@synthesize emojiScrol = _emojiScrol;
@synthesize statusLabel = _statusLabel;
@synthesize recordBtn = _recordBtn;
@synthesize micLight = _micLight;
@synthesize deleteBtn = _deleteBtn;
@synthesize recorder = _recorder;
@synthesize recorderBase = _recorderBase;
@synthesize playBtn = _playBtn;
@synthesize scenes = _scenes;
@synthesize emojies = _emojies;
@synthesize shareView = _shareView;
@synthesize monitorTimer = _monitorTimer;
@synthesize popeLeftView = _popeLeftView;
@synthesize popeRightView = _popeRightView;
@synthesize circularProgressView = _circularProgressView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.recorderBase = [[VoiceRecorderBase alloc] init];
    self.recorderBase.vrbDelegate = self;
    
    self.scenes = [NSMutableArray arrayWithObjects:[UIColor redColor],[UIColor yellowColor],[UIColor greenColor],[UIColor blueColor],[UIColor orangeColor], nil];
    
    self.emojies = [NSMutableArray arrayWithObjects:
                    [UIImage imageNamed:@"sticker_angry@2x.png"]
                    ,[UIImage imageNamed:@"sticker_cry@2x.png"]
                    ,[UIImage imageNamed:@"sticker_hello@2x.png"]
                    ,[UIImage imageNamed:@"sticker_love@2x.png"]
                    ,[UIImage imageNamed:@"sticker_question@2x.png"]
                    ,[UIImage imageNamed:@"sticker_sleep@2x.png"]
                    ,[UIImage imageNamed:@"sticker_smile@2x.png"]
                    ,[UIImage imageNamed:@"sticker_surprise@2x.png"]
                    ,[UIImage imageNamed:@"sticker_tumbling@2x.png"],nil];
    
    //set subviews
    UILongPressGestureRecognizer *longPrees = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(recordBtnLongPressed:)];
    longPrees.delegate = (id)self;
    [longPrees setAllowableMovement:10.];
    [longPrees setMinimumPressDuration:0.2];
    [self.recordBtn addGestureRecognizer:longPrees];
    
    //set backcolor & progresscolor
    UIColor *backColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0];
    UIColor *progressColor = [UIColor blueColor];
    
    [self.circularProgressView  initProgressWithFrame:CGRectMake(41, 57, 136, 136) backColor:backColor progressColor:progressColor lineWidth:20 audioPath:@""];
    
    self.recordBtn.layer.cornerRadius = self.recordBtn.width/2.0f;
    self.recordBtn.clipsToBounds = YES;
    
    self.playBtn.layer.cornerRadius = self.playBtn.width/2.0f;
    self.playBtn.clipsToBounds = YES;
    
    self.sceneScroll.contentSize = CGSizeMake(self.sceneScroll.width*self.scenes.count, self.sceneScroll.height);
    for (int i = 0; i<self.scenes.count; i++) {
        UIView *aScene = [[UIView alloc] initWithFrame:self.sceneScroll.bounds];
        aScene.left = self.sceneScroll.width*i;
        
        aScene.backgroundColor = [self.scenes objectAtIndex:i];
        
        [self.sceneScroll addSubview:aScene];
    }
    self.sceneScroll.delegate = self;
    
    self.scenePageControl.numberOfPages = self.scenes.count;
    
    self.emojiBtn.selected = NO;
    
    [self statusChange:YES];
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)statusChange:(BOOL)is_record
{
    //录音
    self.publishBtn.enabled = !is_record;
    self.statusLabel.hidden = !is_record;
    self.recordBtn.hidden = !is_record;
    self.micLight.hidden = !is_record;
    [self recordStatus:RecordStatusNormal];
    [self.circularProgressView updateProgressCircle:0.0];

    
    //播放录音
    self.playBtn.hidden = is_record;
    self.deleteBtn.hidden = is_record;
    self.shareView.hidden = is_record;
}

- (void)recordStatus:(RecordStatus)status
{
    switch (status) {
        case RecordStatusNormal:
        {
            self.statusLabel.text = NSLocalizedString(@"按住录音", nil);
            self.statusLabel.textColor = [UIColor whiteColor];
            self.micLight.image = [UIImage imageNamed:@"Talkie_led_off"];
            //音效
            
            [self stopPopeAnimation];
        }
            break;
        case RecordStatusPreparing:
        {
            self.statusLabel.text = NSLocalizedString(@"准备中...", nil);
            self.statusLabel.textColor = [UIColor yellowColor];
            self.micLight.image = [UIImage imageNamed:@"Talkie_led_yellow"];
            //音效
            
        }
            break;
        case RecordStatusRecording:
        {
            self.statusLabel.text = NSLocalizedString(@"录音中...", nil);
            self.statusLabel.textColor = [UIColor greenColor];
            self.micLight.image = [UIImage imageNamed:@"Talkie_led_green"];
            //音效
            
            if (_monitorTimer)
                [_monitorTimer invalidate];
            
            _monitorTimer = [NSTimer
                            scheduledTimerWithTimeInterval:1.0/30.0
                            target:self
                            selector:@selector(showVoicePope)
                            userInfo:nil
                            repeats:YES
                            ];
        }
            break;
        default:
            break;
    }
}

- (void)recordBtnLongPressed:(UILongPressGestureRecognizer*) longPressedRecognizer
{
    //长按开始
    if(longPressedRecognizer.state == UIGestureRecognizerStateBegan) {
 
        [((UIButton*)longPressedRecognizer.view) setImage:[UIImage imageNamed:@"publish_recorder_selected"] forState:UIControlStateNormal];
        [self recordStatus:RecordStatusRecording];
        //设置文件名，开始录音
        [self beginRecordByFileName:[self.recorderBase getCurrentTimeString]];
        
    }
    //长按结束
    else if(longPressedRecognizer.state == UIGestureRecognizerStateEnded || longPressedRecognizer.state == UIGestureRecognizerStateCancelled){
        [((UIButton*)longPressedRecognizer.view) setImage:[UIImage imageNamed:@"publish_recorder"] forState:UIControlStateNormal];
        [self statusChange:NO];
        
        [self.recorder performSelector:@selector(stop) withObject:nil afterDelay:0.2f];
    }
}

- (void)emojiScrolAnimation:(BOOL)is_show
{
    [UIView animateWithDuration:0.15
                     animations:^{
                        
                         self.emojiScrol.top = is_show?(self.view.height-self.emojiScrol.height):self.view.height;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
}

//显示声音波普
- (void)showVoicePope
{
    if (self.recorder && self.recorder.recording) {
        [self.circularProgressView updateProgressCircle: self.recorder.currentTime / 60];
        [self.recorder updateMeters];
        [self beginPopeAnimation:fabs((60+[self.recorder averagePowerForChannel:0])/60)];//绝对值
    }else {
        NCMusicEngine *engine = [NCMusicEngine sharedPlayer];
        if (engine.player.playing){
            [self.circularProgressView updateProgressCircle: engine.player.currentTime / engine.player.duration];
            [engine.player updateMeters];
            [self beginPopeAnimation:fabs((60+[engine.player averagePowerForChannel:0])/60)];//绝对值
        }
    }
}

- (void)beginPopeAnimation:(float)power
{
    self.popeLeftView.alpha = power;
    self.popeRightView.alpha = power;
}

- (void)stopPopeAnimation
{
    if (_monitorTimer) {
        [_monitorTimer invalidate];
    }
    
    self.popeLeftView.alpha = 0;
    self.popeRightView.alpha = 0;
}

#pragma mark - 录音相关
//开始录音
- (void)beginRecordByFileName:(NSString*)_fileName{
    
    //设置文件名和录音路径
    self.recorderBase.recordFileName = _fileName;
    self.recorderBase.recordFilePath = [self.recorderBase getPathByFileName:self.recorderBase.recordFileName ofType:@"wav"];
    NSLog(@"Begin Record: %@",self.recorderBase.recordFilePath);
    self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:self.recorderBase.recordFilePath]
                                                settings:[self.recorderBase getAudioRecorderSettingDict]
                                                   error:nil];
    
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    
    
    [self.recorder prepareToRecord];
    
    //开始录音
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [self.recorder record];
    
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    NSLog(@"录音停止");
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags{
    NSLog(@"录音中断");
}

#pragma mark - Actions
- (IBAction)closeBtnPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{ }];
}

- (IBAction)publishBtnPress:(id)sender
{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"发布中...", nil) maskType:SVProgressHUDMaskTypeGradient];
    
    //转格式
    NSString *amrFilePath = [self.recorderBase getPathByFileName:[self.recorderBase getCurrentTimeString] ofType:@"amr"];
    if(0 == [self.recorderBase wavToAmr:[self.recorder.url absoluteString]  amrSavePath:amrFilePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:[self.recorder.url absoluteString]  error:nil];
        
//        NSString *documentsDirectory = [NSHomeDirectory()
//                                        stringByAppendingPathComponent:@"Documents/"];
//        NSLog(@"Documentsdirectory  list: %@",
//              [[NSFileManager defaultManager]  contentsOfDirectoryAtPath:documentsDirectory error:nil]);
//        NSLog(@"translate finished del wav");
        
        NSString *token = [[AccountDTO sharedInstance] session_info].token;
        
        [[FileClient sharedInstance] createUserStatusWithUserToken:token
                                                              type:@"2"
                                                           content:nil
                                                              file:amrFilePath
                                                       cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                          delegate:self
                                                          selector:@selector(requestDidFinishLoad:)
                                                     selectorError:@selector(requestError:)
                                                  progressSelector:@selector(requestProgress:)];
    }
}

- (IBAction)playBtnPress:(id)sender
{
    NSLog(@"Play recorderURL:%@",[self.recorder.url absoluteString]);
    
    //可以播放的wav
    if ([[NCMusicEngine sharedPlayer] isPlaying]) {
        [[NCMusicEngine sharedPlayer] stop];
    }

    [[NCMusicEngine sharedPlayer] setPlayer:nil];
    [[NCMusicEngine sharedPlayer] playLocalFile:self.recorder.url];
    [[NCMusicEngine sharedPlayer] setDelegate:self];
    
    if (_monitorTimer)
        [_monitorTimer invalidate];
    
    _monitorTimer = [NSTimer
                     scheduledTimerWithTimeInterval:1.0/30.0
                     target:self
                     selector:@selector(showVoicePope)
                     userInfo:nil
                     repeats:YES
                     ];
}

- (IBAction)deleteBtnPress:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"取消", nli)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"重新录制", nil), nil];
    actionSheet.tag = 1000;
    [actionSheet showInView:self.view];
}

- (IBAction)recordBtnPress:(id)sender
{
    [self recordStatus:RecordStatusPreparing];
}

- (IBAction)emojiBtnPress:(id)sender
{
    self.emojiBtn.selected = !self.emojiBtn.selected;
    [self emojiScrolAnimation:self.emojiBtn.selected];
}

#pragma mark - Delegates
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1000) {
        if (buttonIndex == 0) {
            //删除文件
            [[NSFileManager defaultManager] removeItemAtPath:[self.recorder.url absoluteString]  error:nil];
            self.recorder = nil;
            
            //恢复录音状态
            [self statusChange:YES];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = (int)round(scrollView.contentOffset.x/scrollView.width);
    self.scenePageControl.currentPage = index;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        int index = (int)round(scrollView.contentOffset.x/scrollView.width);
        self.scenePageControl.currentPage = index;
    }
}

- (void)engine:(NCMusicEngine *)engine playProgress:(CGFloat)progress
{
    if (progress == 1.0) {
        [self stopPopeAnimation];
    }
}

- (void)requestDidFinishLoad:(NSData*)data
{
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if(json_string.length > 0){
        id responseObject = [[json_string JSONValue] objectForKey:@"code"];
        if(responseObject && 0 == [responseObject integerValue]){
            //success!
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"发布成功", nil)];
            
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            
        }else{
            [self requestError:[[json_string JSONValue]  objectForKey:@"data"]];
        }
    }else{
        [self requestError:@"json is null"];
    }
}

- (void)requestError:(NSString *)error
{
    if (error) {
        [SVProgressHUD showErrorWithStatus:error];
    }
}

- (void)requestProgress:(NSNumber *)progress
{
    [SVProgressHUD showProgress:[progress floatValue] status:NSLocalizedString(@"发布中...", nil) maskType:SVProgressHUDMaskTypeGradient];
}

@end
