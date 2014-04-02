
//
//  FileClient.m
//  StealTrunk
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2013年 StealTrunk. All rights reserved.
//

#import "FileClient.h"
#import "Reachability.h"


@implementation FileClient

#pragma mark -
#pragma mark Client Functions

static FileClient* _sharedInstance = nil;

+ (FileClient *)sharedInstance
{
    @synchronized(self)
    {
        if (_sharedInstance == nil)
            _sharedInstance = [[FileClient alloc] init];
    }
    return _sharedInstance;
}

#pragma mark - Login

- (id)init
{
    if(self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        
        Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        
//        reach.reachableBlock = ^(Reachability * reachability)
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//            });
//        };
//        
//        reach.unreachableBlock = ^(Reachability * reachability)
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//            });
//        };
        
        [reach startNotifier];
        
    }
    
    return self;

}

- (void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            nNetworkingType = 0;
            NSLog(@"没有网络");
            break;
        case ReachableViaWWAN:
            nNetworkingType = 1;
            NSLog(@"正在使用3G网络");
            break;
        case ReachableViaWiFi:
            nNetworkingType = 2;
            NSLog(@"正在使用wifi网络");
            break;
    }
    
}

- (int)getNetworkingType
{
    return nNetworkingType;
}
//App Secret：35adbb0e2cbfd3cf9383621d52bf73aa
//App Key：2183146084
//
//wy@geeko2.com / Qq000000

- (NSString*)getServerApiString:(NSString *)apiName
{
    //    std::ostringstream oss;
    //    oss << SERVER_IP << VERSION << "/" << apiName;
    //    cout<<oss.str();
    return [NSString stringWithFormat:@"%@%@/%@",[Global getServerBaseUrl],[Global getAppVersion],apiName];
}

//*****************************V**********************************
- (void)loginBySinaToken:(NSString*)loginType token:(NSString*)token cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    if(!token){
        [SVProgressHUD showErrorWithStatus:@"NO TOKEN"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:loginType forKey:@"login_type"];
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"login.php"]
                                                                   usePost:NO
                                                                     param:params
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}




- (void)logout:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"logout.php"]
                                                                   usePost:NO
                                                                     param:nil
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

//获取个人资料
- (void)getUserProfileWithUserToken:(NSString*)token userID:(NSString*)userID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:token forKey:@"token"];

    //change by kevin "接口要求"
    if (userID && userID.length>0) {
        [params setObject:userID forKey:@"user_id"];
    }
    
    

    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"user_profile_get.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//更新自己的个人资料   *****************************V**********************************
- (void)updateMyProfile:(Monstea_user_info *)userInfo avatar:(UIImage *)image delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError  progressSelector:(SEL)progressSelector
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:[[AccountDTO sharedInstance] session_info].token forKey:@"token"];
    
    if (userInfo) {
        if (userInfo.user_name) {
            [params setObject:userInfo.user_name forKey:@"name"];
        }
        
        if (userInfo.user_sign) {
            [params setObject:userInfo.user_sign forKey:@"sign_text"];
        }
        
        Monstea_user_info *currentUserInfo = [[AccountDTO sharedInstance] monstea_user_info];
        if (currentUserInfo.gender <= 0) {
            [params setObject:[NSString stringWithFormat:@"%d",userInfo.gender] forKey:@"gender"];
        }
        
        if (userInfo.show > 0) {
            [params setObject:[NSString stringWithFormat:@"%d",userInfo.show] forKey:@"show"];
        }
        
        if (userInfo.birthday && userInfo.birthday.length>0) {
            [params setObject:userInfo.birthday forKey:@"birthday"];
        }
        
        if (userInfo.blood && userInfo.blood.length>0) {
            [params setObject:userInfo.blood forKey:@"blood"];
        }
        
        if (userInfo.longitude != 300) {
            [params setObject:[NSString stringWithFormat:@"%lf", userInfo.longitude] forKey:@"longitude"];
            [params setObject:[NSString stringWithFormat:@"%lf", userInfo.latitude] forKey:@"latitude"];
        }
    }
    
    RequestSender *requestSender = [RequestSender easyRequestSenderWithURL:[self getServerApiString:@"user_profile_update.php"]
                                                                     Param:params
                                                                  Delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError];
    if (image) {
        requestSender.progressSelector = progressSelector;
        requestSender.image = image;
        [requestSender uploadData:UploadTypePicture];
    }else {
        [requestSender send];
    }
}

//上传照片墙
- (void)updateMyAlbumWithUserToken:(NSString*)token image:(UIImage*)image addMethod:(NSString*)addMethod replaceID:(NSString*)replaceID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError progressSelector:(SEL)progressSelector
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    //[params setObject:file forKey:@"file"];
    [params setObject:addMethod forKey:@"add_method"];
    [params setObject:replaceID forKey:@"replace_id"];
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"my_album_upload.php"]
                                                                   usePost:NO
                                                                     param:params
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
        
                                                      selectorArgument:nil];
    requestSender.progressSelector = progressSelector;
    requestSender.image = image;
    [requestSender uploadData:UploadTypePhotoWall];
}

//删除
- (void)delMyAlbumWithUserToken:(NSString*)token photoID:(NSString*)photoID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:photoID forKey:@"photo_id"];
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"my_album_del.php"]
                                                                   usePost:NO
                                                                     param:params
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

//排序
//token，登录时返回的token
//order, 字符串，包含一串照片id，用","号隔开，记录照片的新顺序
- (void)sortMyAlbumWithUserToken:(NSString*)token order:(NSString*)order cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:order forKey:@"order"];
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"my_album_sort.php"]
                                                                   usePost:NO
                                                                     param:params
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

//个人动态
//类型定义
//define('USER_STATUS_TEXT', 1); //文本
//define('USER_STATUS_AUDIO', 2);//音频
- (void)createUserStatusWithUserToken:(NSString*)token type:(NSString*)type content:(NSString*)content file:(NSString*)file cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError progressSelector:(SEL)progressSelector
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:type forKey:@"type"];
    
    if (content) {
        [params setObject:content forKey:@"content"];
    }
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"user_status_create.php"]
                                                                   usePost:NO
                                                                     param:params
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    if (file) {
        requestSender.filePath = file;
    }
    requestSender.progressSelector = progressSelector;
    [requestSender uploadData:UploadTypeVoice];
}

//个人动态列表
- (void)listUserStatusWithUserToken:(NSString*)token userID:(NSString*)userID  pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID  cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:userID forKey:@"user_id"];
    
    [params setObject:pageSize forKey:@"limit"];
    [params setObject:offsetID forKey:@"offset_id"];
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"user_status_list.php"]
                                                                   usePost:NO
                                                                     param:params
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

//删除个人动态
- (void)deleteUserStatusWithStatusID:(NSString*)statusID delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:statusID forKey:@"status_id"];
    
    RequestSender *requestSender = [RequestSender easyRequestSenderWithURL:[self getServerApiString:@"user_status_delete.php"]
                                                                     Param:params
                                                                  Delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError];
    [requestSender send];
}

//评论
- (void)createUserStatusCommentWithUserToken:(NSString*)token statusID:(NSString*)statusID content:(NSString*)content replyToID:(NSString*)replyToID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:statusID forKey:@"status_id"];
    [params setObject:content forKey:@"content"];
    [params setObject:replyToID forKey:@"reply_to_id"];
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"user_status_comment_create.php"]
                                                                   usePost:NO
                                                                     param:params
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

//评论
- (void)listUserStatusCommentWithUserToken:(NSString*)token statusID:(NSString*)statusID   pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID   cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:statusID forKey:@"status_id"];
    
    
    [params setObject:pageSize forKey:@"limit"];
    [params setObject:offsetID forKey:@"offset_id"];
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"user_status_comment_list.php"]
                                                                   usePost:NO
                                                                     param:params
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

//删除评论
- (void)deleteUserStatusCommentWithUserToken:(NSString*)token commentID:(NSString*)commentID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:commentID forKey:@"comment_id"];
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"user_status_comment_delete.php"]
                                                                   usePost:NO
                                                                     param:params
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

//对动态发表态度
- (void)markUserStatusLikeWithStatusID:(NSString*)statusID likeType:(NSString*)likeType delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:statusID forKey:@"status_id"];
    [params setObject:likeType forKey:@"like_type"];

    RequestSender *requestSender = [RequestSender easyRequestSenderWithURL:[self getServerApiString:@"user_status_like_mark.php"]
                                                                     Param:params
                                                                  Delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError];
    
    [requestSender send];
}

//列表
- (void)listUserStatusLikeWithUserToken:(NSString*)token statusID:(NSString*)statusID  pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID   cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:statusID forKey:@"status_id"];
    
    [params setObject:pageSize forKey:@"limit"];
    [params setObject:offsetID forKey:@"offset_id"];
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"user_status_like_list.php"]
                                                                   usePost:NO
                                                                     param:params
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

- (void)listNearByPlacesWithUserToken:(NSString*)token coordinateGps:(CLLocationCoordinate2D)coordinateGps radius:(NSString*)radius keywords:(NSString*)keywords cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:[NSString stringWithFormat:@"%lf",coordinateGps.longitude] forKey:@"longitude"];
    [params setObject:[NSString stringWithFormat:@"%lf",coordinateGps.latitude] forKey:@"latitude"];
    [params setObject:radius forKey:@"radius"];
    [params setObject:token forKey:@"token"];
    [params setObject:keywords forKey:@"keywords"];
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"nearby_location.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//获取好友列表
- (void)listFriendsWithUserToken:(NSString *)token pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID    cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    
    [params setObject:pageSize forKey:@"limit"];
    [params setObject:offsetID forKey:@"offset_id"];
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"friend_list.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//获取好友申请、好友推荐
- (void)listFriendsRequestWithUserToken:(NSString *)token  pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    
    [params setObject:pageSize forKey:@"limit"];
    [params setObject:offsetID forKey:@"offset_id"];
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"friend_request_list.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//发送好友申请
- (void)createFriendsRequestWithUserID:(NSString *)userID delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userID forKey:@"user_id"];
    
    RequestSender *requestSender = [RequestSender easyRequestSenderWithURL:[self getServerApiString:@"friend_request_create.php"]
                                                                     Param:params
                                                                  Delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError];
    [requestSender send];
}

//发送好友确认
- (void)confirmFriendsRequestWithrequestID:(NSString *)requestID delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:requestID forKey:@"request_id"];
    
    RequestSender *requestSender = [RequestSender easyRequestSenderWithURL:[self getServerApiString:@"friend_request_confirm.php"]
                                                                     Param:params
                                                                  Delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError];
    [requestSender send];
}

//加入黑名单
- (void)blockFriendsRequestWithUserID:(NSString *)userID Delegate:(id)theDelegate Selector:(SEL)theSelector SelectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userID forKey:@"user_id"];
    
    RequestSender *requestSender = [RequestSender easyRequestSenderWithURL:[self getServerApiString:@"friend_block.php"]
                                                                     Param:params
                                                                  Delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError];
    
    [requestSender send];
}

//解除加入黑名单
- (void)unBlockFriendsRequestWithUserID:(NSString *)userID Delegate:(id)theDelegate Selector:(SEL)theSelector SelectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userID forKey:@"user_id"];
    
    RequestSender *requestSender = [RequestSender easyRequestSenderWithURL:[self getServerApiString:@"friend_unblock.php"]
                                                                     Param:params
                                                                  Delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError];
    
    [requestSender send];
}

//黑名单列表
- (void)listBlockFriendsRequestWithUserToken:(NSString *)token  pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:pageSize forKey:@"limit"];
    [params setObject:offsetID forKey:@"offset_id"];
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"friend_block_list.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//消息列表
- (void)listNotificationRequestWithUserToken:(NSString *)token pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID  cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    
    [params setObject:pageSize forKey:@"limit"];
    [params setObject:offsetID forKey:@"offset_id"];
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"notification_list.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//确认消息
- (void)confirmNotificationRequestWithNotificationID:(NSString *)notificationID token:(NSString*)token cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:notificationID forKey:@"notification_id"];

    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"notification_confirm.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//忽略消息
- (void)ignoreNotificationRequestWithNotificationID:(NSString *)notificationID token:(NSString*)token cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:notificationID forKey:@"notification_id"];
    
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"notification_ignore.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//私信:类型定义
//define('MESSAGE_TYPE_TO_ME', 1);//发送给我
//define('MESSAGE_TYPE_FROM_ME', 2);//我发送的
//define('USER_MESSAGE_TEXT', 1);//文本
//define('USER_MESSAGE_AUDIO', 2);//音频
//define('USER_MESSAGE_IMAGE', 3);//图片
- (void)createUserMessageWithUserToken:(NSString *)token toUserID:(NSString*)toUserID message:(NSString*)message file:(id)file type:(int)type cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError progressSelector:(SEL)progressSelector
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:toUserID forKey:@"to_user_id"];
    [params setObject:message forKey:@"message"];
    [params setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    if (type == 2) {
        [params setObject:@"audio.amr" forKey:@"file"];
    }
    else if(type == 3){
        [params setObject:@"picture.jpg" forKey:@"file"];
    }
    else
    {
        [params setObject:@"" forKey:@"file"];
    }

    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"user_message_create.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    
    if (type == 2) {
        requestSender.progressSelector = progressSelector;
        requestSender.filePath = file;
        [requestSender uploadData:UploadTypeVoice];
    }
    else if(type == 3){
        requestSender.progressSelector = progressSelector;
        requestSender.image = file;
        [requestSender uploadData:UploadTypePicture];
    }
    else
    {
        [requestSender send];
    }
}

//私信:分组列表
- (void)listGroupMessageWithUserToken:(NSString *)token  pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    
    [params setObject:pageSize forKey:@"limit"];
    [params setObject:offsetID forKey:@"offset_id"];
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"user_message_group_list.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//私信:分组列表
- (void)deleteGroupMessageWithUserToken:(NSString *)token userID:(NSString*)userID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:userID forKey:@"user_id"];

    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"message_group_delete.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//私信:私信列表
- (void)listUserMessageWithUserToken:(NSString *)token userID:(NSString*)userID   pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:userID forKey:@"user_id"];
    [params setObject:pageSize forKey:@"limit"];
    [params setObject:offsetID forKey:@"offset_id"];
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"user_message_list.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//私信:私信列表
- (void)deleteUserMessageWithUserToken:(NSString *)token messageID:(NSString*)messageID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:messageID forKey:@"message_id"];
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"user_message_delete.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//附近的人
- (void)listNearByPeopleWithUserToken:(NSString *)token gender:(NSString *)gender coordinateGps:(CLLocationCoordinate2D)coordinateGps pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:gender forKey:@"gender"];
    [params setObject:[NSString stringWithFormat:@"%lf",coordinateGps.longitude] forKey:@"longitude"];
    [params setObject:[NSString stringWithFormat:@"%lf",coordinateGps.latitude] forKey:@"latitude"];
    
    [params setObject:pageSize forKey:@"limit"];
    [params setObject:offsetID forKey:@"offset_id"];
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"nearby_user.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//附近的部落
- (void)listNearByTribeWithUserToken:(NSString *)token coordinateGps:(CLLocationCoordinate2D)coordinateGps  pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID cachePolicy:(NSURLRequestCachePolicy)cholicy delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:[NSString stringWithFormat:@"%lf",coordinateGps.longitude] forKey:@"longitude"];
    [params setObject:[NSString stringWithFormat:@"%lf",coordinateGps.latitude] forKey:@"latitude"];
    
    [params setObject:pageSize forKey:@"limit"];
    [params setObject:offsetID forKey:@"offset_id"];
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"nearby_tribe.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

- (void)listTribeFarmsWithUserToken:(NSString *)token tribeID:(NSString *)tribeID  pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID cachePolicy:(NSURLRequestCachePolicy)cholicy delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:tribeID forKey:@"tribe_id"];
    [params setObject:pageSize forKey:@"limit"];
    [params setObject:offsetID forKey:@"offset_id"];
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"tribe_farm_list.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//获取农场信息
//请求地址
- (void)getFarmInfoWithUserToken:(NSString *)token userID:(NSString *)userID  cachePolicy:(NSURLRequestCachePolicy)cholicy delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:userID forKey:@"user_id"];
    
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"farm_get.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//设置农场位置
- (void)setLocationFarmWithUserToken:(NSString *)token locationName:(NSString*)locationName locationType:(NSString*)locationType coordinate:(CLLocationCoordinate2D)coordinate  cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:locationName forKey:@"location_name"];
    [params setObject:locationType forKey:@"location_type"];
    [params setObject:[NSString stringWithFormat:@"%lf",coordinate.latitude] forKey:@"latitude"];
    [params setObject:[NSString stringWithFormat:@"%lf",coordinate.longitude] forKey:@"longitude"];
    
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"farm_location_set.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//加入部落
- (void)joinTribeWithUserToken:(NSString *)token tribeID:(NSString *)tribeID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:tribeID forKey:@"tribe_id"];
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"tribe_join.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//退出部落
- (void)exitTribeWithUserToken:(NSString *)token tribeID:(NSString *)tribeID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:tribeID forKey:@"tribe_id"];
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"tribe_join.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}


//
- (void)setLocationFarmWithUserToken:(NSString *)token tribeID:(NSString*)tribeID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:tribeID forKey:@"tribe_id"];
    
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"tribe_join.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//部落详情
- (void)getTribeWithUserToken:(NSString *)token tribeID:(NSString*)tribeID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:tribeID forKey:@"tribe_id"];
    
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"tribe_get.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//好友推荐:列表
- (void)listRecommendFriendsWithUserToken:(NSString *)token pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    
    [params setObject:pageSize forKey:@"limit"];
    [params setObject:offsetID forKey:@"offset_id"];
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"friend_recommend_list.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//好友推荐:忽略
- (void)ignoreRecommendFriendsRequestWithUserID:(NSString *)userID Token:(NSString *)token cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:userID forKey:@"user_id"];
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"friend_recommend_ignore.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//好友邀请
- (void)listInvitaFriendsWithUserToken:(NSString *)token type:(NSString *)type pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:type forKey:@"type"];
    
    [params setObject:pageSize forKey:@"limit"];
    [params setObject:offsetID forKey:@"offset_id"];
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"friend_invite_avail_list.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//好友邀请:接受邀请
- (void)acceptInvitaFriendsWithUserToken:(NSString *)token userID:(NSString *)userID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:userID forKey:@"user_id"];
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"friend_invite_accept.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//好友邀请:已接受的邀请列表
- (void)listAcceptedInviteFriendsWithUserToken:(NSString *)token  pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID  cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:pageSize forKey:@"limit"];
    [params setObject:offsetID forKey:@"offset_id"];
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"friend_invite_list.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//好友邀请:成功被我邀请的好友列表
- (void)listInviteSeccessFriendsWithUserToken:(NSString *)token cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"friend_invite_success_list.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//好友动态列表
- (void)listFriendsStatusWithUserToken:(NSString *)token pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:pageSize forKey:@"limit"];
    [params setObject:offsetID forKey:@"offset_id"];
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"friend_status_list.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//商店
//种子列表
- (void)listSeedWithUserToken:(NSString *)token pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:pageSize forKey:@"limit"];
    [params setObject:offsetID forKey:@"offset_id"];
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"seed_list.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//购买种子
- (void)buySeedWithUserToken:(NSString *)token seedID:(NSString*)seedID count:(NSString *)count cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:seedID forKey:@"seed_id"];
    [params setObject:count forKey:@"count"];
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"seed_buy.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//我的种子列表
- (void)listMySeedWithUserToken:(NSString *)token pageSize:(NSString*)pageSize offsetID:(NSString *)offsetID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:pageSize forKey:@"limit"];
    [params setObject:offsetID forKey:@"offset_id"];
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"my_seed_list.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

//种植种子
- (void)growFarmWithUserToken:(NSString *)token seedID:(NSString*)seedID landID:(NSString *)landID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:seedID forKey:@"seed_id"];
    [params setObject:landID forKey:@"land_id"];
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:[self getServerApiString:@"farm_grow.php"]
                                                               usePost:NO
                                                                 param:params
                                                           cachePolicy:cholicy
                                                              delegate:theDelegate
                                                      completeSelector:theSelector
                                                         errorSelector:theSelectorError
                                                      selectorArgument:nil];
    [requestSender send];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _sharedInstance = nil;
}

@end
