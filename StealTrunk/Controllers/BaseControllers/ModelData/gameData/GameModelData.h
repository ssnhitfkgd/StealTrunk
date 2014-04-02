//
//  GameModelData.h
//  StealTrunk
//
//  Created by wangyong on 13-6-15.
//
//


@interface GameModelData : NSObject

@property (nonatomic, assign ,getter = getBackgroundMusicMuted)BOOL backgroundMusicMuted;
@property (nonatomic, assign, getter = getSoundEffectMuted)BOOL soundEffectMuted;


+ (id) sharedGameDataManager;
@end
