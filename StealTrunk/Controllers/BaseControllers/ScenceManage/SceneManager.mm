//
//  SceneManager.m
//  StealingTrunk
//
//  Created by wangyong on 13-6-13.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//


#import "SceneManager.h"
//#include "HelloWorldScene.h"


@implementation SceneManager


static SceneManager *_sharedContext = nil;

- (SceneManager*)sharedSceneManager
{
	if(!_sharedContext){
        _sharedContext = [[SceneManager alloc] init];
	}
	return _sharedContext;
}

- (void)startGame:(CCLayer *)layer
{
    [self startScene:layer];
}

- (void)startScene:(CCLayer *)layer
{
    CCDirector *director = [CCDirector sharedDirector];
    CCScene *newScene = [self wrapScene:layer];
    
    if ([director runningScene])
    {
        [director replaceScene:newScene];
    }
    else {
        [director runWithScene:newScene];
    }
}

- (CCScene * )wrapScene:(CCLayer * )layer
{
    CCScene *newScene = [CCScene node];
    [newScene addChild:layer];
    return newScene;
}


@end
