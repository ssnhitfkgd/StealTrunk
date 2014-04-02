//
//  RequestSender.h
//  StealTrunk
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2013年 StealTrunk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

//uploadtype
typedef enum{
	UploadTypePicture = 0,
	UploadTypePhotoWall,
    UploadTypeVoice,
} UploadType;

@interface RequestSender : AFHTTPClient
{
    NSString *requestUrl;
    NSDictionary *dictParam;
    id deletage;
    SEL completeSelector;
    SEL errorSelector;
    BOOL usePost;
}

@property (nonatomic, strong) NSString *requestUrl;
@property (nonatomic, strong) NSDictionary *dictParam;
@property (nonatomic, strong) id delegate;
@property (nonatomic) SEL completeSelector;
@property (nonatomic) SEL errorSelector;
@property (nonatomic) SEL progressSelector;
@property (nonatomic, assign) BOOL usePost;
@property (nonatomic, assign)NSURLRequestCachePolicy cachePolicy;

@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong)NSString *filePath;

/*
 默认设置token
 */
+ (id)easyRequestSenderWithURL:(NSString *)theURL
                         Param:(NSMutableDictionary *)param
                      Delegate:(id)delegate
              completeSelector:(SEL)theCompleteSelector
                 errorSelector:(SEL)theErrorSelector;

+ (id)requestSenderWithURL:(NSString *)theUrl
                   usePost:(BOOL)isPost
                     param:(NSDictionary *)dictParam
                  cachePolicy:(NSURLRequestCachePolicy)cholicy
                  delegate:(id)theDelegate 
          completeSelector:(SEL)theCompleteSelector 
             errorSelector:(SEL)theErrorSelector
          selectorArgument:(id)theSelectorArgument;

- (void)send;
- (void)uploadData:(UploadType)type;
+ (id)currentClient;

@end
