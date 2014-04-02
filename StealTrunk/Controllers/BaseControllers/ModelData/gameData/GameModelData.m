//
//  GameModelData.cpp
//  StealTrunk
//
//  Created by wangyong on 13-6-15.
//
//

#import "GameModelData.h"

@implementation GameModelData
@synthesize soundEffectMuted;
@synthesize backgroundMusicMuted;

static GameModelData *_sharedGameData = nil;

+ (id)sharedGameDataManager
{
	if(!_sharedGameData){
        _sharedGameData = [[GameModelData alloc] init];
	}
	return _sharedGameData;
}

- (id)init
{
    self = [super init];
    if(self)
    {
    }
    
    return self;
}

- (NSString*)getPlist
{
    NSString *filePath = [FileUtil getBasePath];
    NSString *plistPath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_gameData.plist", [[AccountDTO sharedInstance] monstea_user_info].user_id]];
    return plistPath;
}

@end
