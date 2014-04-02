//
//  LBModelApiViewController.h
//  StealTrunk
//
//  Created by yong wang on 13-3-21.
//  Copyright (c) 2013年StealTrunk. All rights reserved.
//

typedef enum
{
    API_GET_USER_INFO = 0,//获取个人资料
    API_LIST_USER_STATUS,//个人动态
    API_LIST_USER_STATUS_COMMENT,//列表评论
    API_LIST_USER_STATUS_LIKE,//列表态度
    API_LIST_NEARBY_PLACES,//列表周边
    API_LIST_FRIENDS,//好友列表
    API_LIST_FRIENDS_REQUEST,//好友申请
    API_LIST_NEARBY_PEOPLE,//附近的人
    API_LIST_NEARBY_TRIBE,//附近的部落
    API_LIST_TRIBE_FARMS,//部落内所有农场列表
    API_LIST_BLOCK,//黑名单列表
    API_LIST_RECOMMEND,//好友推荐列表
    API_LIST_INVITE,//邀请微博好友列表
    API_LIST_INVITE_DETAIL,//邀请详情
    API_LIST_GROUP_CHAT,
    API_LIST_GROUP_MESSAGE,
    API_LIST_NOTIFICATION,//消息列表
    API_LIST_FRIENDS_STATUS,//好友动态汇总
    API_LIST_SEED,//种子列表
    API_LIST_MYSEED,//我的种子
    API_LIST_TASK,
    API_LIST_SCORE,
}API_GET_TYPE;

typedef enum
{
    ERROR_CODE_SUCCESS = 0,
    ERROR_CODE_NORMAL,         
    ERROR_CODE_NEED_AUTH,    
}API_GET_CODE;


#import "BaseController.h"
@interface ModelApiViewController : BaseController  {
    BOOL loading;
    int offsetID;
}
//
@property (nonatomic, strong) id model;

- (API_GET_TYPE)modelApi;
// subclass to override
- (BOOL)shouldLoad;
- (BOOL)isLoading;
- (void)reloadData;

- (void)loadData:(NSURLRequestCachePolicy)cachePolicy more:(BOOL)more;
- (void)didFinishLoad:(id)object;
- (id)transitionData:(NSData*)data;
- (void)didFailWithError:(int)type;
- (void)requestError:(NSError*)error;

- (void)loadMoreData:(NSNumber *)loadHeader;

//override
- (NSString *)getStatusID;
- (NSString *)getUserID;
- (NSString *)getGender;

- (CLLocationCoordinate2D)getLocationCoordinate;
- (NSString*)getRadius;
- (NSString*)getKeywords;
- (NSString *)getTribeID;
- (NSString *)getInviteType;

- (NSString*)getChatToUserID;

@end
