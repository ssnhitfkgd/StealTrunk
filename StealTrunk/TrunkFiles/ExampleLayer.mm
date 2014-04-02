/*******************************************************************************
 * Copyright (c) 2013, Esoteric Software
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 ******************************************************************************/

#import "ExampleLayer.h"
#include "CCScrollView.h"
#import "FarmProgressView.h"
#include "SkeletonJson.h"


@implementation ExampleLayer

+ (CCScene*) scene {
	CCScene *scene = [CCScene node];
	[scene addChild:[ExampleLayer node]];
	return scene;
}

- (void)initFram
{

    // ask director for the window size
 
    [[CCDirector sharedDirector].view addSubview:[FarmProgressView shareInstance]];
    
	CGSize size = [[CCDirector sharedDirector] winSize];
    
    CCLayer *layer = [CCLayer node];

    CCScrollView *scroller = [[CCScrollView alloc] initWithViewSize:size];
    scroller.anchorPoint = ccp(0,1);
    scroller.position = ccp(0, 0);
    [scroller setContentSize:CGSizeMake(320, 320)];
    [scroller setDirection:CCScrollViewDirectionVertical];
    [scroller setDelegate:self];
    [scroller setBounces:YES];
    [scroller setContentOffset:CGPointZero];
    //[scroller setClipsToBounds:YES];
    [scroller setContentOffset:CGPointZero];
    [scroller addChild:layer];
    //[scroller setContainer:layer];
    [self addChild:scroller z:0];
    
	CCSprite *background;
    background = [CCSprite spriteWithFile:@"farm_bk_up.png"];
    background.scaleX = 1.0;
    background.scaleY = 1.0;
    background.anchorPoint = ccp(0,1);
	background.position = ccp(0, size.height);
	// add the label as a child to this Layer
	[layer addChild:background z:-1];

    CCSprite *farm_tree;
    farm_tree = [CCSprite spriteWithFile:@"farm_tree_right.png"];
    farm_tree.scaleX = 1.0;
    farm_tree.scaleY = 1.0;
    farm_tree.anchorPoint = ccp(0,1);
	farm_tree.position = ccp(0, size.height);
	// add the label as a child to this Layer
	[layer addChild:farm_tree z:4];
    
    
    farm_tree = [CCSprite spriteWithFile:@"farm_tree_left.png"];
    farm_tree.scaleX = 1.0;
    farm_tree.scaleY = 1.0;
    farm_tree.anchorPoint = ccp(1,1);
	farm_tree.position = ccp(size.width, size.height);
	[layer addChild:farm_tree z:4];
    
   
    CCSprite *frontBack = [CCSprite spriteWithFile:@"farm_moutain.png"];
    frontBack.scaleX = 1.0;
    frontBack.scaleY = 1.0;
    frontBack.anchorPoint = ccp(0,1);
	frontBack.position = ccp(0, size.height - 175 + 132 - 26);
	// add the label as a child to this Layer
	[layer addChild:frontBack z:1];
    
    background = [CCSprite spriteWithFile:@"farm_tree.png"];
    background.scaleX = 1.0;
    background.scaleY = 1.0;
    background.anchorPoint = ccp(0,1);
	background.position = ccp(0, size.height - 175 + 132 - 26 + 18);
	// add the label as a child to this Layer
	[layer addChild:background z:3];
    //[layer setContentSize:CGSizeMake(320, 10)];
  
    background = [CCSprite spriteWithFile:@"farm_bk_bottom.png"];
    background.scaleX = 1.0;
    background.scaleY = 1.0;//1.055;
    background.anchorPoint = ccp(0,1);
	background.position = ccp(0, size.height - 144);
	[layer addChild:background z:3];
    
    for (int i = 0; i < 5; i++) {
        for(int j = 0; j < 4; j++)
        {
            
            CCSprite *farm_sand_pit = [CCSprite spriteWithFile:@"farm_sand_pit.png"];
            
            [farm_sand_pit setAnchorPoint:CGPointZero];
            farm_sand_pit.scaleX = 1.0;
            farm_sand_pit.scaleY = 1.0;
            farm_sand_pit.position = ccp(j*300/4 +10, i*64 + 12 + 32);
            //farm_sand_pit.position = ccp(j*300/4 +10, i*40 + 12 + 48);
            // add the label as a child to this Layer
            [background addChild:farm_sand_pit z:2 tag:i*j];
            
        }
    }


//    animationNodeLineboy = [CCSkeletonAnimation skeletonWithFile:@"LineBoy.json" atlasFile:@"LineBoy.atlas" scale:0.5];
//    [animationNodeLineboy setAnimation:@"GangnanStyle" loop:YES];
//    animationNodeLineboy.timeScale = 1.0f;//动画速度
//	animationNodeLineboy.debugBones = false;//显示/隐藏骨骼
//	[animationNodeLineboy setPosition:ccp(240, 190)];
//	[layer addChild:animationNodeLineboy z:10];
//    [animationNodeLineboy updateWorldTransform];


    animationNodeLineboy = [CCSkeletonAnimation skeletonWithFile:@"spineboy.json" atlasFile:@"spineboy.atlas" scale:0.5];
    
    [animationNodeLineboy setAnimation:@"jump" loop:YES];

    animationNodeLineboy.timeScale = 1.0f;//动画速度
    
	animationNodeLineboy.debugBones = false;//显示/隐藏骨骼
    BOOL a = [animationNodeLineboy setAttachment:@"left hand" attachmentName:@"dagger"];

	[animationNodeLineboy setPosition:ccp(240, 190)];

	[layer addChild:animationNodeLineboy z:10];
   
   
    
    animationNodeWeather = [CCSkeletonAnimation skeletonWithFile:@"sunny.json" atlasFile:@"sunny.atlas" scale:0.5];
    
    [animationNodeWeather setAnimation:@"animation" loop:YES];
    animationNodeWeather.timeScale = 0.08f;//动画速度
	animationNodeWeather.debugBones = false;//显示/隐藏骨骼
	[animationNodeWeather setPosition:ccp(size.width/2, 300)];
    [animationNodeWeather setSkin:@"sun"];
    [animationNodeWeather setSlotsToSetupPose];
	[layer addChild:animationNodeWeather z:2];
    
    //**************************************************************************************************
    
    animationNodeWeather = [CCSkeletonAnimation skeletonWithFile:@"sunny.json" atlasFile:@"sunny.atlas" scale:0.5];
    
 

    [animationNodeWeather setAnimation:@"animation" loop:YES];
    animationNodeWeather.timeScale = 0.08f;//动画速度
	animationNodeWeather.debugBones = false;//显示/隐藏骨骼
	[animationNodeWeather setPosition:ccp(size.width/2, 300)];
    
    [animationNodeWeather setSkin:@"sun"];
    [animationNodeWeather setSlotsToSetupPose];
	[layer addChild:animationNodeWeather z:2];


//    CCSkeletonAnimation *animationNode = [CCSkeletonAnimation skeletonWithFile:@"goblins.json" atlasFile:nil scale:1];
//    [animationNode setMixFrom:@"walk" to:@"jump" duration:0.1f];
//    [animationNode setMixFrom:@"jump" to:@"walk" duration:0.4f];
//    [animationNode setAnimation:@"walk" loop:YES];
//    [animationNode addAnimation:@"jump" loop:NO afterDelay:0];
//    [animationNode addAnimation:@"walk" loop:YES afterDelay:0];
//    [animationNode addAnimation:@"jump" loop:NO afterDelay:0.3];
//    [animationNode addAnimation:@"walk" loop:YES afterDelay:0];
    

}

- (void)scrollViewDidScroll:(CCScrollView*)scrollView
{
  
   // BOOL a = [animationNodeLineboy setAttachment:@"left hand" attachmentName:@"dagger"];
    
   // [animationNodeLineboy setSlotsToSetupPose];

    CGPoint offSet = [scrollView contentOffset];

    if(offSet.y > 80)
    {
         [animationNodeLineboy setAttachment:@"left hand" attachmentName:@"left-hand"];

    }
    else
    {
         [animationNodeLineboy setAttachment:@"left hand" attachmentName:@"dagger"];

    }
    [animationNodeLineboy setPosition:ccp(240, 190)];

    if (offSet.y > 120) {
        [scrollView setContentOffset:CGPointMake(offSet.x, 120)];
    }

}

- (id) init {
	self = [super init];
	if (!self) return nil;
    [self setTouchEnabled:YES];
    [self setAccelerometerEnabled:YES];
    
    [self initFram];
    
   // [[CCDirector sharedDirector].view setHeight:1200];


//    animationNode = [CCSkeletonAnimation skeletonWithFile:@"LineBoy.json" atlasFile:@"LineBoy.atlas" scale:0.5];
//    [animationNode setAnimation:@"GangnanStyle" loop:YES];

    /*
	animationNode = [CCSkeletonAnimation skeletonWithFile:@"spineboy.json" atlasFile:@"spineboy.atlas" scale:1];
	[animationNode setMixFrom:@"walk" to:@"jump" duration:0.1f];
	[animationNode setMixFrom:@"jump" to:@"walk" duration:0.4f];
	[animationNode setAnimation:@"walk" loop:YES];
	[animationNode addAnimation:@"jump" loop:NO afterDelay:0];
	[animationNode addAnimation:@"walk" loop:YES afterDelay:0];
    [animationNode addAnimation:@"jump" loop:NO afterDelay:0.3];
	[animationNode addAnimation:@"walk" loop:YES afterDelay:0];
     */
     
//	animationNode.timeScale = 1.0f;//动画速度
//	animationNode.debugBones = false;//显示/隐藏骨骼

	//CGSize windowSize = [[CCDirector sharedDirector] winSize];// 貌似没用？
//	[animationNode setPosition:ccp(200, 190)];
//	[self addChild:animationNode];


	return self;
}
//
//- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    for( UITouch *touch in touches ) {
//		CGPoint location = [touch locationInView: [touch view]];
//		beginPoint = [[CCDirector sharedDirector] convertToGL: location];
//        
//        
//    }
//}
//
//- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
////    for( UITouch *touch in touches ) {
////		CGPoint location = [touch locationInView: [touch view]];
////		location = [[CCDirector sharedDirector] convertToGL: location];
////        animationNode.position = ccpAdd(animationNode.position, ccp(0,(location.y - beginPoint.y)))  ;
////        beginPoint = location;
////
////    }
//}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}
@end
