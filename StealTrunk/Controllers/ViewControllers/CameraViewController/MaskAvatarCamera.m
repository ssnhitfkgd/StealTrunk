//
//  CameraViewController.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-30.
//
//

#import "MaskAvatarCamera.h"
#import "FileClient.h"
#import "KLSwitch.h"

@interface MaskAvatarCamera ()
{
    AVCaptureSession *_session;
    AVCaptureStillImageOutput *_dataOutput;
    AVCaptureVideoDataOutput *_dataOutputVideo;
}

@property (nonatomic, strong) IBOutlet UIView *cameraMainView;
@property (nonatomic, strong) IBOutlet UIView *camContent;
@property (nonatomic, strong) IBOutlet UIImageView *camPreviewView;
@property (nonatomic, strong) IBOutlet UIScrollView *maskScrol;
@property (nonatomic, strong) IBOutlet UIButton *shootBtn;
@property (nonatomic, strong) IBOutlet KLSwitch *maskBtn;
@property (nonatomic, strong) IBOutlet UIButton *closeBtn;
@property (nonatomic, strong) IBOutlet UIPageControl *maskPageControl;
@property (nonatomic, strong) IBOutlet UIButton *swapCameraBtn;

@property (nonatomic, strong) IBOutlet UIView *resultMainView;
@property (nonatomic, strong) IBOutlet UIImageView *resultImageView;
@property (nonatomic, strong) IBOutlet UIButton *backBtn;
@property (nonatomic, strong) IBOutlet UIButton *saveBtn;
@property (nonatomic, strong) IBOutlet UIButton *reverseBtn;
@property (nonatomic, strong) IBOutlet UIImageView *topImageView;
@property (nonatomic, strong) IBOutlet UIImageView *bottomImageView;

- (IBAction)closeBtnPress:(id)sender;
- (IBAction)shootBtnPress:(id)sender;
- (IBAction)maskBtnPress:(id)sender;
- (IBAction)backBtnPress:(id)sender;
- (IBAction)saveBtnPress:(id)sender;
- (IBAction)reverseBtnPress:(id)sender;
@end

@implementation MaskAvatarCamera
@synthesize cameraMainView = _cameraMainView;
@synthesize camContent = _camContent;
@synthesize camPreviewView = _camPreviewView;
@synthesize maskScrol = _maskScrol;
@synthesize closeBtn = _closeBtn;
@synthesize shootBtn = _shootBtn;
@synthesize maskBtn = _maskBtn;
@synthesize maskPageControl = _maskPageControl;
@synthesize swapCameraBtn = _swapCameraBtn;
@synthesize reverseBtn = _reverseBtn;
@synthesize topImageView = _topImageView;
@synthesize bottomImageView = _bottomImageView;

@synthesize resultMainView = _resultMainView;
@synthesize resultImageView = _resultImageView;
@synthesize backBtn = _backBtn;
@synthesize saveBtn = _saveBtn;

@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // セッションの開始
    [_session startRunning];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_session stopRunning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    self.view = self.cameraMainView;
    
    // ビデオキャプチャデバイスの取得
    AVCaptureDevice *device = [self cameraWithPosition:AVCaptureDevicePositionFront];
    
    // デバイス入力の取得 - input
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:NULL];
    
    // フラッシュをオフ
    NSError *error = nil;
    if ([device lockForConfiguration:&error]) {
        if ([device isFlashModeSupported:AVCaptureFlashModeOff]) {
            device.flashMode = AVCaptureFlashModeOff;
        }
        
        [device unlockForConfiguration];
    }
    
    // イメージデータ出力の作成 - output
    _dataOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    AVVideoCodecJPEG, AVVideoCodecKey, nil];
    _dataOutput.outputSettings = outputSettings;
    
    // ビデオデータ出力の作成 - output
    NSMutableDictionary *settings;
    settings = [NSMutableDictionary dictionary];
    [settings setObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                 forKey:(__bridge id) kCVPixelBufferPixelFormatTypeKey];
    
    _dataOutputVideo = [[AVCaptureVideoDataOutput alloc] init];
    _dataOutputVideo.videoSettings = settings;
    [_dataOutputVideo setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    // セッションの作成
    _session = [[AVCaptureSession alloc] init];
    [_session addInput:deviceInput];
    [_session addOutput:_dataOutput];
    [_session addOutput:_dataOutputVideo];
    
    // ここ重要、AVCaptureSessionPreset1280x720だとフロントカメラで落ちる
    _session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    //添加mask
    NSArray *maskArray = [NSArray arrayWithObjects:
                          [UIImage imageNamed:@"mask01"],
                          [UIImage imageNamed:@"mask02"],
                          [UIImage imageNamed:@"mask03"],
                          [UIImage imageNamed:@"mask04"],
                          [UIImage imageNamed:@"mask05"],nil];
    
    self.maskScrol.backgroundColor = [UIColor clearColor];
    self.maskScrol.contentSize = CGSizeMake(320*5, 320);
    self.maskScrol.delegate = self;
    for (int i = 0; i<maskArray.count; i++) {
        UIImageView *mask = [[UIImageView alloc] initWithImage:[maskArray objectAtIndex:i]];
        mask.frame = CGRectMake(320*i, 0, 320, 320);
        mask.contentMode = UIViewContentModeBottomRight;
        [self.maskScrol addSubview:mask];
    }
    
    self.maskPageControl.numberOfPages = maskArray.count;
    
    self.maskBtn.selected = YES;//显示面罩
    
//    [_topImageView setImage:[[UIImage imageNamed:@"camera_back"] stretchableImageWithLeftCapWidth:0 topCapHeight:3]];
//    [_bottomImageView setImage:[[UIImage imageNamed:@"camera_back"] stretchableImageWithLeftCapWidth:0 topCapHeight:3]];
//
//    [_topImageView setBackgroundColor:[UIColor clearColor]];
//    [_bottomImageView setBackgroundColor:[UIColor clearColor]];
    
    [_shootBtn setTitle:@"" forState:UIControlStateNormal];
    [_shootBtn setBackgroundColor:[UIColor clearColor]];
    [_shootBtn setBackgroundImage:[UIImage imageNamed:@"camera_shoot"] forState:UIControlStateNormal];
    [_shootBtn setBackgroundImage:[UIImage imageNamed:@"camera_shoot_selected"] forState:UIControlStateSelected|UIControlStateHighlighted];
    
    [_closeBtn setTitle:@"" forState:UIControlStateNormal];
    [_closeBtn setBackgroundColor:[UIColor clearColor]];
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"camera_cancel"] forState:UIControlStateNormal];
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"camera_cancel_selected"] forState:UIControlStateSelected|UIControlStateHighlighted];
    
    [_reverseBtn setTitle:@"" forState:UIControlStateNormal];
    [_reverseBtn setBackgroundColor:[UIColor clearColor]];
    [_reverseBtn setBackgroundImage:[UIImage imageNamed:@"camera_swip"] forState:UIControlStateNormal];
    [_reverseBtn setBackgroundImage:[UIImage imageNamed:@"camera_swip_selected"] forState:UIControlStateSelected|UIControlStateHighlighted];

    [_maskBtn setOnImage:[UIImage imageNamed:@"camera_slide@2x.png"]];
    [_maskBtn configureSwitch];
    [_maskBtn setOnTintColor: [UIColor blueColor]];
    [_maskBtn setOn:NO animated: NO];
    [_maskBtn setDidChangeHandler:^(BOOL isOn) {
        [self maskBtnPress:_maskBtn];
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// AVCaptureStillImageOutputで呼ばれる
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    self.camPreviewView.image = [self imageFromSampleBuffer:sampleBuffer];
    
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

// Create a UIImage from sample buffer data
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    //4 test
    //    if (width > height) {
    //        width = height;
    //    }else {
    //        height = width;
    //    }
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress,
                                                 width,
                                                 height,
                                                 8,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage
                                         scale:1.0f
                                   orientation:self.swapCameraBtn.selected?UIImageOrientationRight:UIImageOrientationLeftMirrored];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

#pragma mark - Actions
- (IBAction)closeBtnPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)shootBtnPress:(id)sender
{
    [self.resultImageView setImage:[UIImage convertViewToImage:self.camContent]];
    
    // Flash the screen white and fade it out to give UI feedback that a still image was taken
    UIView *flashView = [[UIView alloc] initWithFrame:self.camContent.frame];
    [flashView setBackgroundColor:[UIColor whiteColor]];
    [[[self view] window] addSubview:flashView];
    
    [UIView animateWithDuration:.4f
                     animations:^{
                         [flashView setAlpha:0.f];
                     }
                     completion:^(BOOL finished){
                         [flashView removeFromSuperview];
                         
                         self.view = self.resultMainView;
                     }
     ];
}

- (IBAction)maskBtnPress:(id)sender
{
    self.maskScrol.hidden = self.maskBtn.selected;
    
    self.maskBtn.selected = !self.maskBtn.selected;
}

- (IBAction)backBtnPress:(id)sender
{
    self.view = self.cameraMainView;
}

- (IBAction)reverseBtnPress:(id)sender
{
    // Assume the session is already running
    
    NSArray *inputs = _session.inputs;
    
    for ( AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;
            
            if (position == AVCaptureDevicePositionFront)
                newCamera = [self backFacingCamera];
            else
                newCamera = [self frontFacingCamera];
            
            
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            
            // beginConfiguration ensures that pending changes are not applied immediately
            [_session beginConfiguration];
            [_session removeInput:input];
            [_session addInput:newInput];
            // Changes take effect once the outermost commitConfiguration is invoked.
            [_session commitConfiguration];
            break;
        }
    }
    
    for(AVCaptureConnection *connection in _dataOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if([[port mediaType] isEqualToString:AVMediaTypeVideo])
            {
                break;
            }
        }
        
    }

}

- (NSUInteger) cameraCount
{
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
}
#pragma mark Device Counts
- (AVCaptureDevice *) frontFacingCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

// Find a back facing camera, returning nil if one is not found
- (AVCaptureDevice *) backFacingCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}


- (IBAction)saveBtnPress:(id)sender
{
    //修改头像
    [[FileClient sharedInstance] updateMyProfile:nil
                                          avatar:self.resultImageView.image
                                        delegate:self
                                        selector:@selector(uploadAvatarSuccess:)
                                   selectorError:@selector(uploadAvatarError:)
                                progressSelector:@selector(uploadAvatarProgress:)];
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"上传头像", nil) maskType:SVProgressHUDMaskTypeGradient];
}

- (void)uploadAvatarSuccess:(NSData *)data
{
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if(json_string.length > 0){
        id responseObject = [[json_string JSONValue] objectForKey:@"code"];
        if(responseObject && 0 == [responseObject integerValue]){
            NSDictionary *dict = [[json_string JSONValue]  objectForKey:@"data"];
            if(dict)
            {
                Monstea_user_info *userInfo = [[Monstea_user_info alloc] init];
                [userInfo parseWithDic:dict];
                [AccountDTO saveMonstea:userInfo];
                
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"上传完成", nil)];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(alreadyUpdateAvatar:)]) {
                    [self.delegate alreadyUpdateAvatar:userInfo.avatar];
                }
                
                [self dismissViewControllerAnimated:YES completion:^{ }];
            }
            else
            {
                [self uploadAvatarError:nil];
            }
        }else{
            [self uploadAvatarError:[[json_string JSONValue]  objectForKey:@"data"]];
        }
    }else{
        [self uploadAvatarError:@"json is null"];
    }
}

- (void)uploadAvatarError:(NSString *)error
{
    if (error) {
        [SVProgressHUD showErrorWithStatus:error];
    }
}

- (void)uploadAvatarProgress:(NSNumber *)progress
{
    [SVProgressHUD showProgress:[progress floatValue] status:NSLocalizedString(@"上传头像", nil) maskType:SVProgressHUDMaskTypeGradient];
}

//前后镜切换
- (IBAction)swapCameraBtnPress:(id)sender {
    
    self.swapCameraBtn.selected = !self.swapCameraBtn.selected;
    
    NSArray *inputs = _session.inputs;
    for (AVCaptureDeviceInput *input in inputs) {
        AVCaptureDevice *device = input.device;
        
        if ([device hasMediaType :AVMediaTypeVideo]) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera;
            AVCaptureDeviceInput *newInput;
            
            if (position == AVCaptureDevicePositionFront) {
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
                newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            } else {
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
                newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            }
            
            // beginConfiguration ensures that pending changes are not applied immediately
            [_session beginConfiguration];
            
            [_session removeInput :input];
            [_session addInput :newInput];
            
            // Changes take effect once the outermost commitConfiguration is invoked.
            [_session commitConfiguration];
            break;
        }
    }
}

#pragma mark - Delegates
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = (int)round(scrollView.contentOffset.x/scrollView.width);
    self.maskPageControl.currentPage = index;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        int index = (int)round(scrollView.contentOffset.x/scrollView.width);
        self.maskPageControl.currentPage = index;
    }
}

@end
