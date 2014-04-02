//
//  SceneManager.h
//  StealingTrunk
//
//  Created by wangyong on 13-6-13.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//

#import "cocos2d.h"

@interface SceneManager : CCLayer

- (SceneManager*)sharedSceneManager;
- (void)startGame;
- (void)startScene:(CCLayer *) layer;
- (CCScene *)wrapScene:(CCLayer *) layer;

@end
