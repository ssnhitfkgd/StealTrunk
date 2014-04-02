//
//  FileClient.h
//  StealTrunk
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2013年 StealTrunk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestSender.h"

#define pageCount @"20"


@interface FileClient : NSObject
{
    int nNetworkingType;
}

+ (FileClient *)sharedInstance;

- (void)reachabilityChanged:(NSNotification*)note;

- (int)getNetworkingType;

- (NSString*)getServerApiString:(NSString *)apiName;

- (void)loginBySinaToken:(NSString*)loginType token:(NSString*)token cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

- (void)logout:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//获取个人资料
- (void)getUserProfileWithUserToken:(NSString*)token userID:(NSString*)userID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;
//更新自己的个人资料
- (void)updateMyProfile:(Monstea_user_info *)userInfo avatar:(UIImage *)image delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError  progressSelector:(SEL)progressSelector;

//上传avatar
- (void)updateMyAlbumWithUserToken:(NSString*)token image:(UIImage*)image addMethod:(NSString*)addMethod replaceID:(NSString*)replaceID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError progressSelector:(SEL)progressSelector;

//删除
- (void)delMyAlbumWithUserToken:(NSString*)token photoID:(NSString*)photoID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//排序
//token，登录时返回的token
//order, 字符串，包含一串照片id，用","号隔开，记录照片的新顺序
- (void)sortMyAlbumWithUserToken:(NSString*)token order:(NSString*)order cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//个人动态
//类型定义
//define('USER_STATUS_TEXT', 1); //文本
//define('USER_STATUS_AUDIO', 2);//音频
- (void)createUserStatusWithUserToken:(NSString*)token type:(NSString*)type content:(NSString*)content file:(NSString*)file cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError progressSelector:(SEL)progressSelector;

//个人动态列表
- (void)listUserStatusWithUserToken:(NSString*)token userID:(NSString*)userID   pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID  cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//删除个人动态
- (void)deleteUserStatusWithStatusID:(NSString*)statusID delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//评论
- (void)createUserStatusCommentWithUserToken:(NSString*)token statusID:(NSString*)statusID content:(NSString*)content replyToID:(NSString*)replyToID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//评论
- (void)listUserStatusCommentWithUserToken:(NSString*)token statusID:(NSString*)statusID   pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID   cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//删除评论
- (void)deleteUserStatusCommentWithUserToken:(NSString*)token commentID:(NSString*)commentID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;
//对动态发表态度
- (void)markUserStatusLikeWithStatusID:(NSString*)statusID likeType:(NSString*)likeType delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//列表
- (void)listUserStatusLikeWithUserToken:(NSString*)token statusID:(NSString*)statusID  pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID   cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//获取附近地址
- (void)listNearByPlacesWithUserToken:(NSString*)token coordinateGps:(CLLocationCoordinate2D)coordinateGps radius:(NSString*)radius keywords:(NSString*)keywords cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//获取好友列表
- (void)listFriendsWithUserToken:(NSString *)token pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID  cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//获取好友申请、好友推荐列表
- (void)listFriendsRequestWithUserToken:(NSString *)token pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID    cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//发送好友申请
- (void)createFriendsRequestWithUserID:(NSString *)userID delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//发送好友确认
- (void)confirmFriendsRequestWithrequestID:(NSString *)requestID delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//加入黑名单
- (void)blockFriendsRequestWithUserID:(NSString *)userID Delegate:(id)theDelegate Selector:(SEL)theSelector SelectorError:(SEL)theSelectorError;

//解除加入黑名单
- (void)unBlockFriendsRequestWithUserID:(NSString *)userID Delegate:(id)theDelegate Selector:(SEL)theSelector SelectorError:(SEL)theSelectorError;

//黑名单列表
- (void)listBlockFriendsRequestWithUserToken:(NSString *)token pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID  cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//消息列表
- (void)listNotificationRequestWithUserToken:(NSString *)token  pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID  cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//确认消息
- (void)confirmNotificationRequestWithNotificationID:(NSString *)notificationID token:(NSString*)token cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//忽略消息
- (void)ignoreNotificationRequestWithNotificationID:(NSString *)notificationID token:(NSString*)token cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//私信:类型定义
//define('MESSAGE_TYPE_TO_ME', 1);//发送给我
//define('MESSAGE_TYPE_FROM_ME', 2);//我发送的
- (void)createUserMessageWithUserToken:(NSString *)token toUserID:(NSString*)toUserID message:(NSString*)message file:(id)file type:(int)type cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError  progressSelector:(SEL)progressSelector;

//私信:分组列表
- (void)listGroupMessageWithUserToken:(NSString *)token  pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//私信:分组列表
- (void)deleteGroupMessageWithUserToken:(NSString *)token userID:(NSString*)userID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//私信:私信列表
- (void)listUserMessageWithUserToken:(NSString *)token userID:(NSString*)userID   pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//私信:私信列表
- (void)deleteUserMessageWithUserToken:(NSString *)token messageID:(NSString*)messageID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//附近的人
/*
 gender, 可选，0:不限,1:男,2:女
 */
- (void)listNearByPeopleWithUserToken:(NSString *)token gender:(NSString *)gender coordinateGps:(CLLocationCoordinate2D)coordinateGps pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//附近的部落
- (void)listNearByTribeWithUserToken:(NSString *)token coordinateGps:(CLLocationCoordinate2D)coordinateGps pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID cachePolicy:(NSURLRequestCachePolicy)cholicy delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//部落内所有农场列表
- (void)listTribeFarmsWithUserToken:(NSString *)token tribeID:(NSString *)tribeID  pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID cachePolicy:(NSURLRequestCachePolicy)cholicy delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//加入部落
- (void)joinTribeWithUserToken:(NSString *)token tribeID:(NSString *)tribeID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//退出部落
- (void)exitTribeWithUserToken:(NSString *)token tribeID:(NSString *)tribeID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//获取农场信息
- (void)getFarmInfoWithUserToken:(NSString *)token userID:(NSString *)userID  cachePolicy:(NSURLRequestCachePolicy)cholicy delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;
//
- (void)setLocationFarmWithUserToken:(NSString *)token tribeID:(NSString*)tribeID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

- (void)getTribeWithUserToken:(NSString *)token tribeID:(NSString*)tribeID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//好友推荐:列表
- (void)listRecommendFriendsWithUserToken:(NSString *)token pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//好友推荐:忽略
- (void)ignoreRecommendFriendsRequestWithUserID:(NSString *)userID Token:(NSString *)token cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//好友邀请
- (void)listInvitaFriendsWithUserToken:(NSString *)token type:(NSString *)type pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//好友邀请:接受邀请
- (void)acceptInvitaFriendsWithUserToken:(NSString *)token userID:(NSString *)userID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//好友邀请:已接受的邀请列表
- (void)listAcceptedInviteFriendsWithUserToken:(NSString *)token  pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//好友邀请:成功被我邀请的好友列表
- (void)listInviteSeccessFriendsWithUserToken:(NSString *)token cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//好友动态列表
- (void)listFriendsStatusWithUserToken:(NSString *)token pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//商店
//种子列表
- (void)listSeedWithUserToken:(NSString *)token pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//购买种子
- (void)buySeedWithUserToken:(NSString *)token seedID:(NSString*)seedID count:(NSString *)count cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//我的种子列表
- (void)listMySeedWithUserToken:(NSString *)token pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//种植种子
- (void)growFarmWithUserToken:(NSString *)token seedID:(NSString*)seedID landID:(NSString *)landID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

@end
