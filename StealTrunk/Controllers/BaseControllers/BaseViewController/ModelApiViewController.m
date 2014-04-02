//
//  LBModelApiViewController.m
//  StealTrunk
//
//  Created by yong wang on 13-3-21.
//  Copyright (c) 2013年StealTrunk. All rights reserved.
//

#import "ModelApiViewController.h"
#import "FileClient.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "AccountDTO.h"

@implementation ModelApiViewController

@synthesize model = _model;

- (id)init{
    self = [super init]; 
    if (self) {
        offsetID = 0;
    }
    return self;
}

- (BOOL)isLoading {
    return loading;
}

// --- ---
- (NSURLRequestCachePolicy)getPolicy
{
    NSURLRequestCachePolicy getPolicy = NSURLRequestReloadRevalidatingCacheData;
    return getPolicy;
}

- (API_GET_TYPE)modelApi
{
    return 0;
}

- (void)loadMoreData:(NSNumber *)loadHeader
{
    BOOL loadMore = [loadHeader boolValue];
    [self loadData:loadMore ?NSURLRequestReturnCacheDataElseLoad:NSURLRequestReloadIgnoringLocalAndRemoteCacheData more:loadMore];
}

- (void)loadData:(NSURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
    API_GET_TYPE api_type = [self modelApi];
    loading = YES;

    NSString *offset_id = more ? [NSString stringWithFormat:@"%d",offsetID]:@"0";
    NSString *token = [[AccountDTO sharedInstance] session_info].token;
    if(token == nil) return;
    FileClient *client = [FileClient sharedInstance];
    switch (api_type) {
        case API_GET_USER_INFO:
            [client getUserProfileWithUserToken:token userID:[self getUserID] cachePolicy:cachePolicy delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_LIST_USER_STATUS:
            [client listUserStatusWithUserToken:token userID:[self getUserID]  pageSize:pageCount offsetID:offset_id  cachePolicy:cachePolicy delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_LIST_USER_STATUS_COMMENT:
            [client listUserStatusCommentWithUserToken:token statusID:[self getStatusID] pageSize:pageCount offsetID:offset_id cachePolicy:cachePolicy delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_LIST_USER_STATUS_LIKE:
            [client listUserStatusLikeWithUserToken:token statusID:[self getStatusID] pageSize:pageCount offsetID:offset_id  cachePolicy:cachePolicy delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_LIST_NEARBY_PLACES:
            [client listNearByPlacesWithUserToken:token coordinateGps:[self getLocationCoordinate] radius:[self getRadius] keywords:[self getKeywords]  cachePolicy:cachePolicy delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_LIST_FRIENDS:
            [client listFriendsWithUserToken:token pageSize:pageCount offsetID:offset_id  cachePolicy:cachePolicy delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_LIST_FRIENDS_REQUEST:
            [client listFriendsRequestWithUserToken:token pageSize:pageCount offsetID:offset_id  cachePolicy:cachePolicy delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_LIST_NOTIFICATION:
            [client listNotificationRequestWithUserToken:token pageSize:pageCount offsetID:offset_id  cachePolicy:cachePolicy delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_LIST_NEARBY_PEOPLE:
            [client listNearByPeopleWithUserToken:token   gender:[self getGender] coordinateGps:[self getLocationCoordinate] pageSize:pageCount offsetID:offset_id cachePolicy:cachePolicy delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_LIST_NEARBY_TRIBE:
        {
            [client listNearByTribeWithUserToken:token coordinateGps:[self getLocationCoordinate] pageSize:pageCount offsetID:offset_id cachePolicy:cachePolicy delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
        }
            break;
        case API_LIST_TRIBE_FARMS:
        {
            [client listTribeFarmsWithUserToken:token tribeID:[self getTribeID] pageSize:pageCount offsetID:offset_id cachePolicy:cachePolicy delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
        }
            break;
        case API_LIST_BLOCK:
        {
            [client listBlockFriendsRequestWithUserToken:token pageSize:pageCount offsetID:offset_id   cachePolicy:cachePolicy delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
        }
            break;
        case API_LIST_RECOMMEND:
        {
            [client listRecommendFriendsWithUserToken:token  pageSize:pageCount offsetID:offset_id  cachePolicy:cachePolicy delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
        }
            break;
        case API_LIST_INVITE:
        {
            [client listInvitaFriendsWithUserToken:token type:[self getInviteType]  pageSize:pageCount offsetID:offset_id  cachePolicy:cachePolicy delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
        }
            break;
        case API_LIST_INVITE_DETAIL:
        {
            [client listAcceptedInviteFriendsWithUserToken:token  pageSize:pageCount offsetID:offset_id  cachePolicy:cachePolicy delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
        }
            break;
        case API_LIST_GROUP_CHAT:
        {
            [client listGroupMessageWithUserToken:token  pageSize:pageCount offsetID:offset_id  cachePolicy:cachePolicy delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
        }
            break;
        case API_LIST_GROUP_MESSAGE:
        {
            [client listUserMessageWithUserToken:token userID:[self getChatToUserID]  pageSize:pageCount offsetID:offset_id  cachePolicy:cachePolicy delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
        }
            break;
        case API_LIST_FRIENDS_STATUS:
        {
            [client listFriendsStatusWithUserToken:token pageSize:pageCount offsetID:offset_id cachePolicy:cachePolicy delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
        }
            break;
        case API_LIST_SEED:
            [client listSeedWithUserToken:token pageSize:pageCount offsetID:offset_id cachePolicy:cachePolicy delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_LIST_MYSEED:
            [client listMySeedWithUserToken:token pageSize:pageCount offsetID:offset_id cachePolicy:cachePolicy delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_LIST_TASK:
#warning 缺少任务api
            break;
        case API_LIST_SCORE:
#warning 缺少成就api
            break;
        default:
            loading = NO;
            break;
    }
}

- (CLLocationCoordinate2D)getLocationCoordinate
{
    //重写 
    CLLocationCoordinate2D location;
    location.latitude = 0.000000;
    location.longitude = 0.000000;
    return location;
}

- (NSString*)getRadius
{
    //重写
    return @"";
}

- (NSString*)getKeywords
{
    return @"";
}

- (NSString *)getStatusID
{
    //override
    return @"";
}

- (NSString *)getUserID
{
    //override
    return @"";
}

- (NSString *)getGender
{
    //override
    return @"";
}


- (NSString *)getTribeID
{
    //override
    return @"";
}

- (NSString *)getInviteType
{
    //override
    return @"";
}

- (NSString*)getChatToUserID
{
    return @"";
}

- (void)didFinishLoad:(id)object {
#warning 移动到动态list中去
    //add by kevin, 在list中可能会存在error的数据（例如删除动态后，会把原位置数据替换为 error）
    NSMutableArray *realObjects = [NSMutableArray array];
    for (NSDictionary *obj in object) {
        if (![obj valueForKey:@"error"]) {
            [realObjects addObject:obj];
        }
    }
    
    if (_model) {
        // is loading more here
        [_model addObjectsFromArray:realObjects];
    } else {
        self.model = realObjects;
    }
}
 
- (BOOL)shouldLoad {
    return !loading;
}

#pragma mark -

- (void)reloadData {
    if ([self shouldLoad] && ![self isLoading]) {
        [self loadData:NSURLRequestReloadIgnoringCacheData more:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[self getPageName]];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.model == nil)
    {
        [self reloadData];
    }
    [MobClick beginLogPageView:[self getPageName]];
}

- (NSString*)getChannelInfo
{
    return nil;
}

- (NSString*)getPageName
{
    API_GET_TYPE api_type = [self modelApi];
    NSString *pageName = nil;
#warning 这个拿来干嘛的？  这个到时统计给友盟得  设置页面名字到时统计好区分
    
    switch (api_type) {
        case API_GET_USER_INFO:
            pageName = @"获取个人资料";
            break;
        case API_LIST_USER_STATUS:
            pageName = @"个人动态";
            break;
        case API_LIST_USER_STATUS_COMMENT:
            pageName = @"列表评论";
            break;
        case API_LIST_USER_STATUS_LIKE:
            pageName = @"列表态度";
            break;
        default:
            pageName = @"luo";
            break;
    }
    
    return pageName;
}

#pragma mark -

- (void)againLogin
{
    [[AppController shareInstance] logout];
}

- (id)transitionData:(NSData*)data
{
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", [json_string JSONValue]);
    if(json_string.length > 0)
    {
        NSDictionary *dict = [json_string JSONValue];
        NSString *error = [dict objectForKey:@"code"];
        if (error && ERROR_CODE_NEED_AUTH == [error intValue]) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"别处登录,请重新登陆"];
            [self againLogin];
        }else if (error && ERROR_CODE_NORMAL == [error intValue]) {
            NSLog(@"error  :  %@",error);
            return nil;
        }else if (error && ERROR_CODE_SUCCESS == [error intValue]){
            id responseObject = [[json_string JSONValue] objectForKey:@"data"];
            if(responseObject && ([responseObject isKindOfClass:[NSArray class]] || [responseObject isKindOfClass:[NSDictionary class]]))
            {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {//add by kevin
                    id offset = [responseObject objectForKey:@"offset_id"];
                    if(offset && ![offset isKindOfClass:[NSNull class]])
                        offsetID = [offset integerValue];
                }
                
                return responseObject;
            }
        }
    }
   
    return nil;
}

- (void)requestDidFinishLoad:(NSData*)data
{
    id obj = [self transitionData:data];
    [self didFinishLoad:obj];
    loading = NO;
}

- (void)didFailWithError:(int)type
{
    //override
}

- (void)requestError:(NSError*)error
{
    NSLog(@"%@",error);
    loading = NO;
    [self didFailWithError:error.code];
}

- (void)requestDidFinishLoadSearchFriends:(NSData *)data
{
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", [json_string JSONValue]);
    [self reloadData];
}


@end
