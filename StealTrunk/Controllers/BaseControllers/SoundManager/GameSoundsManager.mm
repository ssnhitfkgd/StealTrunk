//
//  GameSoundsManager.cpp
//  StealTrunk
//
//  Created by wangyong on 13-6-16.
//
//

#import "GameSoundsManager.h"
#import "SimpleAudioEngine.h"
#import "GameModelData.h"
//#include "CDAudioManager.h"

@implementation GameSoundsManager

static GameSoundsManager *_sharedGameSounds = nil;

+ (GameSoundsManager*)sharedGameSoundsManager
{
	if(!_sharedGameSounds){
        _sharedGameSounds = [[GameSoundsManager alloc] init];
	}
	return _sharedGameSounds;
}


- (void)preloadSounds {
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"bird.mp3"];
}

//禁用音效
- (void)disableSoundEffect
{
    [[GameModelData sharedGameDataManager] setSoundEffectMuted:FALSE];
}

//启用音效
- (void)enableSoundEffect {
    [[GameModelData sharedGameDataManager] setBackgroundMusicMuted:TRUE];
}

//播放音效
- (void)playSoundEffect:(NSString*)fileName
{
    if ( [[GameModelData sharedGameDataManager] getSoundEffectMuted])
    {
        [[SimpleAudioEngine sharedEngine] playEffect:fileName];
    }
}

//介绍标签音效
- (void)playIntroSound {
    if ( [[GameModelData sharedGameDataManager] getSoundEffectMuted] ) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"introduction.mp3"];
    }
}

//播放背景音乐
- (void)playBackgroundMusic{
    
    //CDAudioManager::sharedManager->setMode(kAMM_FxPlusMusicIfNoOtherAudio);
    //CocosDenshion::SimpleAudioEngine::sharedEngine->s
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    if (![[GameModelData sharedGameDataManager] getBackgroundMusicMuted])
    {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"start.mp3" loop:TRUE];
        [[SimpleAudioEngine sharedEngine]  setBackgroundMusicVolume:0.15f];
    }
}

//停止背景音乐
- (void)stopBackgroundMusic {
    //CDAudioManager::sharedManager->setMode(kAMM_FxOnly);
    [[SimpleAudioEngine sharedEngine]  stopBackgroundMusic];
    [[GameModelData sharedGameDataManager] setBackgroundMusicMuted:FALSE];
}

//重启背景音乐
- (void)restartBackgroundMusic {
    [[GameModelData sharedGameDataManager] setBackgroundMusicMuted:FALSE];
    [self playBackgroundMusic];
}

//播放About页面的背景音乐
- (void)playAboutSceneMusic{
    
    if( [[GameModelData sharedGameDataManager] getBackgroundMusicMuted]){
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"aboutPage.mp3" loop:TRUE];
    }
}

//关卡胜利
- (void)levelClear{
    if (![[GameModelData sharedGameDataManager]  getSoundEffectMuted]) {
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"levelWin.mp3"];
    }
}

//关卡失败
- (void)levelLose{
    if (![[GameModelData sharedGameDataManager]  getSoundEffectMuted]) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"levelFailure.mp3"];
    }
}


@end
