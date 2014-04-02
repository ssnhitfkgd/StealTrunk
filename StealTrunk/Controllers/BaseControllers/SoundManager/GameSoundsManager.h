//
//  GameSoundsManager.h
//  StealTrunk
//
//  Created by wangyong on 13-6-16.
//
//


#include "cocos2d.h"

@interface GameSoundsManager : CCNode
{
    NSString *delayedSoundEffectName;
    unsigned char musicTrackNumber;
}

+ (GameSoundsManager*)sharedGameSoundsManager;
- (void)playIntroSound;
- (void)disableSoundEffect;
- (void)enableSoundEffect;
- (void)playSoundEffect:(NSString*)fileName;
- (void)playBackgroundMusic;
- (void)stopBackgroundMusic;
- (void)restartBackgroundMusic;
- (void)playAboutSceneMusic;
- (void)preloadSounds;
- (void)levelClear;
- (void)levelLose;
@end
//GameSoundsManager : public CCNode
//{
//public:
//    ~GameSoundsManager();
//    string *delayedSoundEffectName;
//    unsigned char musicTrackNumber;
//    
//    static GameSoundsManager* sharedGameSoundsManager();
//    bool init();
//    void playIntroSound();
//    void disableSoundEffect();
//    void enableSoundEffect();
//    void playSoundEffect(const char *fileName);
//    void playBackgroundMusic();
//    void stopBackgroundMusic();
//    void restartBackgroundMusic();
//    void playAboutSceneMusic();
//    void preloadSounds();
//    void levelClear();
//    void levelLose();
//};
//#endif /* defined(__StealTrunk__GameSoundsManager__) */
