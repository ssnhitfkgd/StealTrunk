//
//  NCMusicEngine.m
//  NCMusicEngine
//
//  Created by nickcheng on 12-12-2.
//  Copyright (c) 2012年 NC. All rights reserved.
//

#import "NCMusicEngine.h"
#import "AFDownloadRequestOperation.h"
#import <AVFoundation/AVFoundation.h>
//
//@implementation AudioPlayer
//+ (id)sharedPlayer
//{
//    static NCMusicEngine *sharedInstance = nil;
//    static dispatch_once_t predicate = 0;
//    dispatch_once(&predicate, ^{
//        sharedInstance = [[self alloc] init];
//    });
//    
//    return sharedInstance;
//}
//
//- (void)playUrl:(NSURL*)url
//{
//    self 
//    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:&error];
//
//}
//@end
@interface NCMusicEngine () <AVAudioPlayerDelegate>

@property (nonatomic, assign, readwrite) NCMusicEnginePlayState playState;
@property (nonatomic, assign, readwrite) NCMusicEngineDownloadState downloadState;
@property (nonatomic, strong, readwrite) NSError *error;

@property (nonatomic, strong) AFDownloadRequestOperation *operation;

@property (nonatomic, assign) BOOL _pausedByUser;

- (void)playLocalFile;

@end

@implementation NCMusicEngine {
  //
  NSString *_localFilePath;
  NSTimer *_playCheckingTimer;
}

@synthesize operation = _operation;
@synthesize player = _player;
@synthesize playState = _playState;
@synthesize downloadState = _downloadState;
@synthesize error = _error;
@synthesize delegate;
@synthesize _pausedByUser;


#pragma mark -
#pragma mark Init

+ (id)sharedPlayer
{
    static NCMusicEngine *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

//耳机拔掉侦听事件回调 [myPlayer 为当前类，即为self]
void audioRouteChangeCallback(void *inClientData, AudioSessionPropertyID inID, UInt32 inDataSize, const void *inData)
{
    CFDictionaryRef routeChangeDictionary = inData;
    CFNumberRef routeChangeReasonRef = CFDictionaryGetValue(routeChangeDictionary, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
    SInt32 routeChangeReason;
    CFNumberGetValue (routeChangeReasonRef, kCFNumberSInt32Type, &routeChangeReason);
    if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {     //拔掉耳机
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    } else if (routeChangeReason == kAudioSessionRouteChangeReason_NewDeviceAvailable) {    //插入耳机
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
    }
}

- (id)init {

    //添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sensorStateChange:)
                                                 name:@"UIDeviceProximityStateDidChangeNotification"
                                               object:nil];

    AudioSessionAddPropertyListener (kAudioSessionProperty_AudioRouteChange,
                                       audioRouteChangeCallback,
                                       (__bridge void *)(self));
    return [self initWithSetBackgroundPlaying:YES];

}

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
    }
    else
    {
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

- (id)initWithSetBackgroundPlaying:(BOOL)setBGPlay {
  //
    if((self = [super init]) == nil) return nil;

    // Custom initialization
    _playState = NCMusicEnginePlayStateStopped;
    _downloadState = NCMusicEngineDownloadStateNotDownloaded;
    _pausedByUser = NO;

    //


    if (setBGPlay) {
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }

    //
    [[NSNotificationCenter defaultCenter] addObserverForName:AFNetworkingOperationDidStartNotification
                                                    object:nil
                                                     queue:nil
                                                usingBlock:^(NSNotification *note) {
                                                  NSLog(@"Operation Started: %@", [note object]);
                                                }];
    return self;
}

#pragma mark -
#pragma mark Public Methods

- (void)playUrl:(NSURL*)url {
    
  NSString *cacheKey = [self cacheKeyFromUrl:url];
  [self playUrl:url withCacheKey:cacheKey];
}

- (void)playUrl:(NSURL *)url withCacheKey:(NSString *)cacheKey {
  //
    self.downloadState = NCMusicEngineDownloadStateNotDownloaded;
    self.playState = NCMusicEnginePlayStateStopped;
    if (self.player)
    {
        [self.player stop];
        self.player = nil;
    }
    //
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSString *localFileName = [NSString stringWithFormat:@"%@.%@", cacheKey, url.pathExtension];
    NSString *localFilePath = [[[self class] cacheFolder] stringByAppendingPathComponent:localFileName];

    _localFilePath = localFilePath;

    //
    //  NSLog(@"Target: %@", _localFilePath);
    if (self.operation)
    {
        if (!self.operation.isCancelled) [self.operation cancel];
        self.operation = nil;
    }
    self.operation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:_localFilePath shouldResume:YES];
    __typeof(&*self) __weak weakSelf = self;
    [self.operation setProgressiveDownloadProgressBlock:^(AFDownloadRequestOperation *ro, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
    //
        #ifdef DDLogInfo
            DDLogInfo(@"[NCMusicEngine] Download Progress: %u, %lld, %lld, %lld, %lld",
            bytesRead, totalBytesRead, totalBytesExpected, totalBytesReadForFile, totalBytesExpectedToReadForFile);
        #else
            NSLog(@"[NCMusicEngine] Download Progress: %u, %lld, %lld, %lld, %lld",
            bytesRead, totalBytesRead, totalBytesExpected, totalBytesReadForFile, totalBytesExpectedToReadForFile);
        #endif
        
        // 
        if (weakSelf.delegate &&
        [weakSelf.delegate conformsToProtocol:@protocol(NCMusicEngineDelegate)] &&
        [weakSelf.delegate respondsToSelector:@selector(engine:downloadProgress:)])
        {
            CGFloat p = (CGFloat)totalBytesReadForFile / (CGFloat)totalBytesExpectedToReadForFile;
            if (p > 1) p = 1;
            [weakSelf.delegate engine:weakSelf downloadProgress:p];
        }

        //
        if (weakSelf.downloadState != NCMusicEngineDownloadStateDownloading)
            weakSelf.downloadState = NCMusicEngineDownloadStateDownloading;

        //
        if (weakSelf.playState == NCMusicEnginePlayStatePaused)
        {
            NSTimeInterval playerCurrentTime = weakSelf.player.currentTime;
            NSTimeInterval playerDuration = weakSelf.player.duration;
            if (playerDuration - playerCurrentTime >= kNCMusicEnginePlayMargin && !weakSelf._pausedByUser)
                [weakSelf playLocalFile];
        }

        //
        if (totalBytesReadForFile > kNCMusicEngineSizeBuffer && !weakSelf.player)
        {
            [weakSelf playLocalFile];
        }
    }];

    [self.operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
    //
        #ifdef DDLogInfo
            DDLogInfo(@"[NCMusicEngine] Music file downloaded successful.");
        #else
            NSLog(@"[NCMusicEngine] Music file downloaded successful.");
        #endif

        //
        if (weakSelf.delegate &&
        [weakSelf.delegate conformsToProtocol:@protocol(NCMusicEngineDelegate)] &&
        [weakSelf.delegate respondsToSelector:@selector(engine:downloadProgress:)])
        {
            [weakSelf.delegate engine:weakSelf downloadProgress:1];
        }

        //
        weakSelf.downloadState = NCMusicEngineDownloadStateDownloaded;

        //
        [weakSelf playLocalFile];
        if (weakSelf.playState != NCMusicEnginePlayStatePaused || !weakSelf._pausedByUser)
        {
            [weakSelf playLocalFile];
        }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        #ifdef DDLogError
            DDLogError(@"[NCMusicEngine] Music file download error: %@", error);
        #else
            NSLog(@"[NCMusicEngine] Music file download error: %@", error);
        #endif

        //
        [weakSelf playLocalFile];
        if (error.code != -999) {
            weakSelf.error = error;
            weakSelf.downloadState = NCMusicEngineDownloadStateError;
            weakSelf.playState = NCMusicEnginePlayStateError;
        }
    }];
  
  [self.operation start];
  
}

- (BOOL)isPlaying
{
    return self.player.isPlaying;
}

- (void)pause {
    if (self.player && self.player.isPlaying)
    {
        [self.player pause];
        _pausedByUser = YES;
        self.playState = NCMusicEnginePlayStatePaused;
        [_playCheckingTimer invalidate];
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];

    }
}

- (void)resume {
    if (self.player && !self.player.isPlaying) {
        [self.player play];
        self.playState = NCMusicEnginePlayStatePlaying;
        [self startPlayCheckingTimer];
        //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    }
}

// Stop music and stop download.
- (void)stop {
    if (self.player)
    {
        [self.player stop];
        self.playState = NCMusicEnginePlayStateStopped;
        [_playCheckingTimer invalidate];
    }
    if (self.operation && !self.operation.isCancelled)
    {
        [self.operation cancel];
    }

    //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
}

#pragma mark -
#pragma mark Private

- (void)handlePlayCheckingTimer:(NSTimer *)timer {
  //
    NSTimeInterval playerCurrentTime = self.player.currentTime;
    NSTimeInterval playerDuration = self.player.duration;

    if (self.delegate &&
    [self.delegate conformsToProtocol:@protocol(NCMusicEngineDelegate)] &&
    [self.delegate respondsToSelector:@selector(engine:playProgress:)])
    {
        if (playerDuration <= 0)
        {
            [self.delegate engine:self playProgress:0];
        }
        else
        {
            [self.delegate engine:self playProgress:playerCurrentTime / playerDuration];
        }
    }

  //
//  if (playerDuration - playerCurrentTime < kNCMusicEnginePauseMargin && self.downloadState != NCMusicEngineDownloadStateDownloaded) {
//    [self pause];
//    _pausedByUser = NO;
//  }
}

- (void)playLocalFile:(NSURL *)url {
    //
    if (!self.player)
    {
        NSError *error = nil;
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        self.player.meteringEnabled = YES;//add by kevin
        
        self.player.delegate = self;
        //初始化播放器的时候如下设置
        UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
        AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                                sizeof(sessionCategory),
                                &sessionCategory);
        
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                                 sizeof (audioRouteOverride),
                                 &audioRouteOverride);
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        //默认情况下扬声器播放
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];
        
        if (error) {
#ifdef DDLogError
            DDLogError(@"[NCMusicEngine] AVAudioPlayer initial error: %@", error);
#else
            NSLog(@"[NCMusicEngine] AVAudioPlayer initial error: %@", error);
#endif
            self.error = error;
            self.playState = NCMusicEnginePlayStateError;
            [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];

        }
    }
    //
    if (self.player)
    {
        if (!self.player.isPlaying)
        {
        //
            if ([self.player prepareToPlay]) NSLog(@"OK1");
            if ([self.player play]) NSLog(@"OK2");

            //
            self.playState = NCMusicEnginePlayStatePlaying;
            [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];

            //
            [self startPlayCheckingTimer];
        }
    }
}

- (void)playLocalFile {
  //
    if (!self.player) {
        NSURL *musicUrl = [[NSURL alloc] initFileURLWithPath:_localFilePath isDirectory:NO];
        NSError *error = nil;
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:&error];
        self.player.delegate = self;
        //初始化播放器的时候如下设置
        UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
        AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                      sizeof(sessionCategory),
                      &sessionCategory);

        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                       sizeof (audioRouteOverride),
                       &audioRouteOverride);

        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        //默认情况下扬声器播放
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];

        if (error)
        {
            #ifdef DDLogError
            DDLogError(@"[NCMusicEngine] AVAudioPlayer initial error: %@", error);
            #else
            NSLog(@"[NCMusicEngine] AVAudioPlayer initial error: %@", error);
            #endif
            self.error = error;
            self.playState = NCMusicEnginePlayStateError;
            [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        }
    }
    //  //
    if (self.player)
    {
        if (!self.player.isPlaying)
        {
        //
            if ([self.player prepareToPlay]) NSLog(@"OK1");
            if ([self.player play]) NSLog(@"OK2");

            //
            self.playState = NCMusicEnginePlayStatePlaying;
            [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
            //
            [self startPlayCheckingTimer];
        }
    }
}

- (void)startPlayCheckingTimer {
  //
    if (_playCheckingTimer)
    {
        [_playCheckingTimer invalidate];
        _playCheckingTimer = nil;
    }
    _playCheckingTimer = [NSTimer scheduledTimerWithTimeInterval:kNCMusicEngineCheckMusicInterval
                                            target:self
                                          selector:@selector(handlePlayCheckingTimer:)
                                          userInfo:nil
                                           repeats:YES];
}

- (void)dealloc
{
    AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_AudioRouteChange, audioRouteChangeCallback, (__bridge void *)(self));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)cacheKeyFromUrl:(NSURL *)url {
    NSString *key = [NSString stringWithFormat:@"%x", url.absoluteString.hash];
    return key;
}

- (void)setPlayState:(NCMusicEnginePlayState)playState {
    _playState = playState;
    if (self.delegate &&
    [self.delegate conformsToProtocol:@protocol(NCMusicEngineDelegate)] &&
    [self.delegate respondsToSelector:@selector(engine:didChangePlayState:)])
        [self.delegate engine:self didChangePlayState:_playState];
}

- (void)setDownloadState:(NCMusicEngineDownloadState)downloadState {
    _downloadState = downloadState;
    if (self.delegate &&
    [self.delegate conformsToProtocol:@protocol(NCMusicEngineDelegate)] &&
    [self.delegate respondsToSelector:@selector(engine:didChangeDownloadState:)])
        [self.delegate engine:self didChangeDownloadState:_downloadState];
}

#pragma mark -
#pragma mark Static

+ (NSString *)cacheFolder {
    static NSString *cacheFolder;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *cacheDir = [[[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject] path];
        cacheFolder = [cacheDir stringByAppendingPathComponent:kNCMusicEngineCacheFolderName];

        // ensure all cache directories are there (needed only once)
        NSError *error = nil;
        if(![[NSFileManager new] createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:&error])
        {
            #ifdef DDLogError
              DDLogError(@"[NCMusicEngine] Failed to create cache directory at %@", cacheFolder);
            #else
              NSLog(@"[NCMusicEngine] Failed to create cache directory at %@", cacheFolder);
            #endif
        }
    });
    return cacheFolder;
}

#pragma mark -
#pragma mark AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        //
        [self stop];
        self.playState = NCMusicEnginePlayStateEnded;
        //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
        //
        if (self.delegate &&
        [self.delegate conformsToProtocol:@protocol(NCMusicEngineDelegate)] &&
        [self.delegate respondsToSelector:@selector(engine:playProgress:)]) {
            [self.delegate engine:self playProgress:1.f];
        }
    }
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
}


@end
