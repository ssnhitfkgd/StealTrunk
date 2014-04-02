//
//  NCMusicEngine.h
//  NCMusicEngine
//
//  Created by nickcheng on 12-12-2.
//  Copyright (c) 2012年 NC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define kNCMusicEngineCacheFolderName @"com.engine.cache"
#define kNCMusicEngineCheckMusicInterval 0.1f // Seconds
#define kNCMusicEngineSizeBuffer 100000.0f // Bytes
#define kNCMusicEnginePauseMargin 1.0f  // Seconds
#define kNCMusicEnginePlayMargin 5.0f // Seconds

@protocol NCMusicEngineDelegate;


typedef enum {
  NCMusicEnginePlayStateStopped,
  NCMusicEnginePlayStatePlaying,
  NCMusicEnginePlayStatePaused,
  NCMusicEnginePlayStateEnded,
  NCMusicEnginePlayStateError
} NCMusicEnginePlayState;

typedef enum {
  NCMusicEngineDownloadStateNotDownloaded,
  NCMusicEngineDownloadStateDownloading,
//  NCMusicEngineDownloadStatePartial,
  NCMusicEngineDownloadStateDownloaded,
  NCMusicEngineDownloadStateError
} NCMusicEngineDownloadState;

//@interface AudioPlayer : AVAudioPlayer
//+ (id)sharedPlayer;
//- (void)playUrl:(NSURL*)url;
//@end

@interface NCMusicEngine : NSObject<AVAudioSessionDelegate>

@property (nonatomic, assign, readonly) NCMusicEnginePlayState playState;
@property (nonatomic, assign, readonly) NCMusicEngineDownloadState downloadState;
@property (nonatomic, strong, readonly) NSError *error;
@property (weak) id<NCMusicEngineDelegate> delegate;
@property (nonatomic, strong) AVAudioPlayer *player;

- (void)playLocalFile:(NSURL *)url ;
- (id)initWithSetBackgroundPlaying:(BOOL)setBGPlay;
- (void)playLocalFile:(NSURL*)url;
- (void)playUrl:(NSURL*)url;
- (void)playUrl:(NSURL *)url withCacheKey:(NSString *)cacheKey;
- (void)pause;
- (void)resume;
- (void)stop; // Stop music and stop download.
- (BOOL)isPlaying;
+ (id)sharedPlayer;
@end


@protocol NCMusicEngineDelegate <NSObject>

//- (NSURL*)engineExpectsNextUrl:(NCMusicEngine *)engine;

@optional
- (void)engine:(NCMusicEngine *)engine didChangePlayState:(NCMusicEnginePlayState)playState;
- (void)engine:(NCMusicEngine *)engine didChangeDownloadState:(NCMusicEngineDownloadState)downloadState;
- (void)engine:(NCMusicEngine *)engine downloadProgress:(CGFloat)progress;
- (void)engine:(NCMusicEngine *)engine playProgress:(CGFloat)progress;

@end
