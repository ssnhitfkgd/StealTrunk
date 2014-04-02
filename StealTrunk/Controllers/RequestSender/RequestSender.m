//
//  RequestSender.m
//  StealTrunk
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2013年 StealTrunk. All rights reserved.
//

#import "RequestSender.h"
#import "SBJSON.h"
#import "AFHTTPRequestOperation.h"
#import "Global.h"



static const float TIME_OUT_INTERVAL = 30.0f;

@implementation RequestSender
@synthesize progressSelector;
@synthesize requestUrl;
@synthesize usePost;
@synthesize dictParam;
@synthesize delegate;
@synthesize completeSelector;
@synthesize errorSelector;
@synthesize cachePolicy;
@synthesize filePath;

+ (id)currentClient
{
    static AFHTTPClient *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, ^{
        sharedInstance = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        [sharedInstance.operationQueue setMaxConcurrentOperationCount:1];
    });
    return sharedInstance;
}

+ (id)easyRequestSenderWithURL:(NSString *)theURL
                         Param:(NSMutableDictionary *)param
                      Delegate:(id)delegate
              completeSelector:(SEL)theCompleteSelector
                 errorSelector:(SEL)theErrorSelector
{
    NSString *token = [[AccountDTO sharedInstance] session_info].token;
    if (token && token.length > 0) {
        [param setObject:token forKey:@"token"];
    }
    
    RequestSender *requestSender = [RequestSender requestSenderWithURL:theURL
                                                               usePost:NO
                                                                 param:param
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                              delegate:delegate
                                                      completeSelector:theCompleteSelector
                                                         errorSelector:theErrorSelector
                                                      selectorArgument:nil];
    return requestSender;
}

+ (id)requestSenderWithURL:(NSString *)theUrl
                   usePost:(BOOL)isPost
                     param:(NSDictionary *)dictParam
               cachePolicy:(NSURLRequestCachePolicy)cholicy
                  delegate:(id)theDelegate
          completeSelector:(SEL)theCompleteSelector
             errorSelector:(SEL)theErrorSelector
          selectorArgument:(id)theSelectorArgument
{
    RequestSender *requestSender = [[RequestSender alloc] init];
    requestSender.requestUrl = theUrl;
    requestSender.usePost = isPost;
    requestSender.dictParam = dictParam;
    requestSender.delegate = theDelegate;
    requestSender.completeSelector = theCompleteSelector;
    requestSender.errorSelector = theErrorSelector;
    requestSender.cachePolicy = cholicy;
    NSLog(@"%@ \n %@", theUrl, dictParam);
    return requestSender;
    
}

- (void)send
{
    NSMutableString *queryStr = [[NSMutableString alloc] init];
    for (int i = 0; i < [dictParam count]; ++i)
    {
        NSString *key = [dictParam allKeys][i];
        NSString *value = [dictParam allValues][i];
        
        if(value && [value isKindOfClass:[NSString class]])
        {
            NSString *encodedValue = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                              (CFStringRef)value,
                                                                                              NULL,
                                                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                              kCFStringEncodingUTF8);
            [queryStr appendFormat:@"&%@=%@", key, encodedValue];

        }
        else
        {
            [queryStr appendFormat:@"&%@=%@", key, value];

        }
        
        
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]
                                                           cachePolicy:self.cachePolicy//NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:TIME_OUT_INTERVAL];
    
    
    
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[queryStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(self.delegate && self.completeSelector)
        {
            if([self.delegate respondsToSelector:self.completeSelector])
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self.delegate performSelector:self.completeSelector withObject:responseObject];
#pragma clang diagnostic pop
            }
        }
        
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSURLCache *urlCache = [NSURLCache sharedURLCache];
        [urlCache setMemoryCapacity:1*1024*1024];
        NSCachedURLResponse *response =
        [urlCache cachedResponseForRequest:request];
        
        //判断是否有缓存
        if (response != nil && self.delegate && self.completeSelector)
        {
            if([self.delegate respondsToSelector:self.completeSelector])
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self.delegate performSelector:self.completeSelector withObject:response.data];
#pragma clang diagnostic pop
                [urlCache removeCachedResponseForRequest:request];
            }
        }
        else
        {
            if(self.delegate && self.errorSelector)
            {
                if([self.delegate respondsToSelector:self.errorSelector])
                {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [self.delegate performSelector:self.errorSelector withObject:error];
#pragma clang diagnostic pop
                    
                }
            }
        }
        
	}];
	
	[operation start];
}

- (void)uploadData:(UploadType)type
{
    NSMutableString *queryStr = [[NSMutableString alloc] init];
    for (int i = 0; i < [dictParam count]; ++i)
    {
        NSString *key = [dictParam allKeys][i];
        NSString *value = [dictParam allValues][i];
        
        if(value && [value isKindOfClass:[NSString class]])
        {
            NSString *encodedValue = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                  (CFStringRef)value,
                                                                                                  NULL,
                                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                  kCFStringEncodingUTF8);
            [queryStr appendFormat:@"&%@=%@", key, encodedValue];
            
        }
        else
        {
            [queryStr appendFormat:@"&%@=%@", key, value];
            
        }
        
        
    }
    
    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:[self.requestUrl stringByAppendingFormat:@"?%@",queryStr]  parameters:nil constructingBodyWithBlock: ^(id formData)
                                    {
                                        switch (type) {
                                            case UploadTypePicture:
                                            {
                                                //头像
                                                NSData * data = UIImageJPEGRepresentation(self.image, 0.8);
                                                NSLog(@"image length:%d",[data length]);
                                                
                                                [formData appendPartWithFileData:data name:@"avatar" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
                                            }
                                                break;
                                            case UploadTypePhotoWall:
                                            {
                                                //照片墙
                                                NSData * data = UIImageJPEGRepresentation(self.image, 0.8);
                                                NSLog(@"image length:%d",[data length]);
                                                
                                                [formData appendPartWithFileData:data name:@"file" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
                                            }
                                            case UploadTypeVoice:
                                            {
                                                //声音
                                                if(self.dictParam)
                                                {
                                                    NSData * data = [NSData dataWithContentsOfFile:self.filePath];
                                                    NSLog(@"audio length:%d",[data length]);
                                                    //[formData appendPartWithFileURL:[NSURL fileURLWithPath:self.filePath] name:@"audio.amr" error:nil];
                                                    
                                                    [formData appendPartWithFileData:data name:@"file" fileName:@"audio.amr" mimeType:@"audio/amr"];
                                                }
                                            }
                                            
                                            default:
                                                break;
                                        }
                                    }];
    
    [request setTimeoutInterval:TIME_OUT_INTERVAL];
    
    [request setHTTPMethod:@"POST"];
    //[request setHTTPBody:[queryStr dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(self.delegate && self.completeSelector)
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.delegate performSelector:self.completeSelector withObject:responseObject];
#pragma clang diagnostic pop
            
        }
        
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error : %@",error);
        if(self.delegate && self.errorSelector){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.delegate performSelector:self.errorSelector withObject:error];
#pragma clang diagnostic pop
            
        }
	}];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        if([self.delegate respondsToSelector:self.progressSelector])
        {
            float percent = (float)totalBytesWritten/totalBytesExpectedToWrite;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.delegate performSelector:self.progressSelector withObject:[NSNumber numberWithFloat:percent]];
#pragma clang diagnostic pop
            
        }
    }];
    
    [[RequestSender currentClient] enqueueHTTPRequestOperation:operation];
}

+ (void)cancelCurrentUploadRequest
{
    for (NSOperation *operation in [[[RequestSender currentClient] operationQueue] operations])
    {
        if (![operation isKindOfClass:[AFHTTPRequestOperation class]])
            continue;
        [operation cancel];
    }
}

+ (void)cancelAllHTTPOperations
{
    for (NSOperation *operation in [[[RequestSender currentClient] operationQueue] operations])
    {
        [operation cancel];
    }
}
@end
