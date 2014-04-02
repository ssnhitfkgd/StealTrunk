//
//  SocketDataCommon.m
//  StealTrunk
//
//  Created by wangyong on 13-7-12.
//
//

#import "SocketDataCommon.h"
#import "AccountDTO.h"
#import "ChatViewController.h"

@interface GCDAsyncSocketPreBuffer : NSObject

- (id)initWithCapacity:(size_t)numBytes;

- (void)ensureCapacityForWrite:(size_t)numBytes;

- (size_t)availableBytes;
- (uint8_t *)readBuffer;

- (void)getReadBuffer:(uint8_t **)bufferPtr availableBytes:(size_t *)availableBytesPtr;

- (size_t)availableSpace;
- (uint8_t *)writeBuffer;

- (void)getWriteBuffer:(uint8_t **)bufferPtr availableSpace:(size_t *)availableSpacePtr;

- (void)didRead:(size_t)bytesRead;
- (void)didWrite:(size_t)bytesWritten;

- (void)reset;

@end

#define USE_SECURE_CONNECTION 1
#define ENABLE_BACKGROUNDING  0
static const float TIME_OUT_INTERVAL = 30.0f;

@implementation SocketDataCommon
@synthesize revDataArray;
@synthesize delegate;

static SocketDataCommon* _sharedInstance = nil;

+ (SocketDataCommon *)sharedInstance
{
    @synchronized(self)
    {
        if (_sharedInstance == nil)
            _sharedInstance = [[SocketDataCommon alloc] init];
    }
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        AccountDTO * account= [AccountDTO sharedInstance];
        host = [account session_info].host;
        port = 7777;
        self.revDataArray = [NSArray arrayWithObjects:[[NSMutableData alloc] init], [[NSMutableData alloc] init], [[NSMutableData alloc] init], [[NSMutableData alloc] init], nil];
        
        [self initSocket];
        
    }
    return self;
}

- (void)initSocket
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
	
	socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    [socket setAutoDisconnectOnClosedReadStream:NO];



    NSLog(@"Connecting to \"%@\" on port %hu...", host, port);

    NSError *err = nil;
    if (![socket connectToHost:host onPort:port withTimeout:TIME_OUT_INTERVAL error:&err])
    {
        NSLog(@"socket error : %@",err);
    }
   
    [socket readDataWithTimeout:-1 tag:SOCKET_TAG_AUTH_RQ];
    [socket readDataWithTimeout:-1 tag:SOCKET_TAG_HBT_RQ];
    [socket readDataWithTimeout:-1 tag:SOCKET_TAG_DATA_RQ];

    [socket readDataWithTimeout:-1 tag:SOCKET_TAG_COM];
}

- (void)auth_rq
{
    [socket readDataWithTimeout:-1 tag:SOCKET_TAG_AUTH_RQ];

    AccountDTO * account= [AccountDTO sharedInstance];
    NSString *auth_rq_string = [NSString stringWithFormat:@"{\"id\":%lld,\"type\":\"auth_rq\",\"token\":\"%@\"}\n",[account.monstea_user_info.user_id longLongValue],[account session_info].token];
    if(auth_rq_string)
    {
        NSData *data = [auth_rq_string dataUsingEncoding:NSUTF8StringEncoding];
        [socket writeData:data withTimeout:-1 tag:SOCKET_TAG_AUTH_RQ];
    }
}

- (void)hbt_rq:(NSString*)sock_id
{
    [socket readDataWithTimeout:-1 tag:SOCKET_TAG_HBT_RQ];

    //AccountDTO * account= [AccountDTO sharedInstance];
    NSString *hbt_rq_string = [NSString stringWithFormat:@"{\"id\":%@,\"type\":\"hbt_rq\"}\n",sock_id];
    if(hbt_rq_string)
    {
        NSData *data = [hbt_rq_string dataUsingEncoding:NSUTF8StringEncoding];
        [socket writeData:data withTimeout:-1 tag:SOCKET_TAG_HBT_RQ];
    }
    
    NSLog(@"socket hbt rq request");
    [self performSelector:@selector(hbt_rq:) withObject:sock_id afterDelay:6];
}

- (void)hbt_rp:(NSString*)sock_id
{
    //AccountDTO * account= [AccountDTO sharedInstance];
    NSString *hbt_rp_string = [NSString stringWithFormat:@"{\"id\":%@,\"type\":\"hbt_rp\"}\n",sock_id];
    if(hbt_rp_string)
    {
        NSData *data = [hbt_rp_string dataUsingEncoding:NSUTF8StringEncoding];
        [socket writeData:data withTimeout:-1 tag:SOCKET_TAG_HBT_RQ];
    }
    
}

- (void)data_rq:(NSString*)data sock_id:(NSString*)sock_id
{
    [socket readDataWithTimeout:-1 tag:SOCKET_TAG_DATA_RQ];

    //AccountDTO * account= [AccountDTO sharedInstance];
    //[account.monstea_user_info.user_id longLongValue]
    NSString *data_rq_string = [NSString stringWithFormat:@"{\"id\":%@,\"type\":\"data\",\"data\":\"%@\"}\n",sock_id,data];
    if(data_rq_string)
    {
        NSData *data = [data_rq_string dataUsingEncoding:NSUTF8StringEncoding];
        [socket writeData:data withTimeout:-1 tag:SOCKET_TAG_DATA_RQ];
    }
}

- (void)ack:(NSString*)sock_id
{
    //AccountDTO * account= [AccountDTO sharedInstance];
    
    NSString *ack_rq_string = [NSString stringWithFormat:@"{\"id\":%@,\"type\":\"ack\"}\\n", sock_id];
    if(ack_rq_string)
    {
        NSData *data = [ack_rq_string dataUsingEncoding:NSUTF8StringEncoding];
        [socket writeData:data withTimeout:-1 tag:SOCKET_TAG_COM];
    }
    
    
}

#pragma socket delegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{

    NSLog(@"localHost :%@ port:%hu", [sock localHost], [sock localPort]);
//	
//#if USE_SECURE_CONNECTION
//	{
//		// Connected to secure server (HTTPS)
//        
//#if ENABLE_BACKGROUNDING && !TARGET_IPHONE_SIMULATOR
//		{
//			// Backgrounding doesn't seem to be supported on the simulator yet
//			
//			[sock performBlock:^{
//				if ([sock enableBackgroundingOnSocket])
//					NSLog(@"Enabled backgrounding on socket");
//				else
//					NSLog(@"Enabling backgrounding failed!");
//			}];
//		}
//#endif
//		
//		// Configure SSL/TLS settings
//		NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithCapacity:3];
//		
//		// If you simply want to ensure that the remote host's certificate is valid,
//		// then you can use an empty dictionary.
//		
//		// If you know the name of the remote host, then you should specify the name here.
//		//
//		// NOTE:
//		// You should understand the security implications if you do not specify the peer name.
//		// Please see the documentation for the startTLS method in GCDAsyncSocket.h for a full discussion.
//		
//		[settings setObject:host
//					 forKey:(NSString *)kCFStreamSSLPeerName];
//		
//		// To connect to a test server, with a self-signed certificate, use settings similar to this:
//		
//        //	// Allow expired certificates
//        //	[settings setObject:[NSNumber numberWithBool:YES]
//        //				 forKey:(NSString *)kCFStreamSSLAllowsExpiredCertificates];
//        //
//        //	// Allow self-signed certificates
//        //	[settings setObject:[NSNumber numberWithBool:YES]
//        //				 forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
//        //
//        //	// In fact, don't even validate the certificate chain
//        //	[settings setObject:[NSNumber numberWithBool:NO]
//        //				 forKey:(NSString *)kCFStreamSSLValidatesCertificateChain];
//		
//		NSLog(@"Starting TLS with settings:\n%@", settings);
//		
//		[sock startTLS:settings];
//		
//		// You can also pass nil to the startTLS method, which is the same as passing an empty dictionary.
//		// Again, you should understand the security implications of doing so.
//		// Please see the documentation for the startTLS method in GCDAsyncSocket.h for a full discussion.
//		
//	}
//#else
//	{
//		// Connected to normal server (HTTP)
//		
//#if ENABLE_BACKGROUNDING && !TARGET_IPHONE_SIMULATOR
//		{
//			// Backgrounding doesn't seem to be supported on the simulator yet
//			
//			[sock performBlock:^{
//				if ([sock enableBackgroundingOnSocket])
//					NSLog(@"Enabled backgrounding on socket");
//				else
//					NSLog(@"Enabling backgrounding failed!");
//			}];
//		}
//#endif
//	}
//#endif
    
    
    [self auth_rq];
    
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
    NSString *requestStr = [NSString stringWithFormat:@"GET / HTTP/1.1\r\nHost: %@\r\n\r\n", host];
	NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
	
	[sock writeData:requestData withTimeout:-1 tag:0];
	[sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:SOCKET_TAG_COM];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
    if(socket.isDisconnected)
    {
        [self reConnect];
    }

}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	NSString *httpResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"socket:%p didReadData:%ld info:%@", sock, tag,httpResponse);

    if(![httpResponse rangeOfString:@"\n"].length)
    {
        [self.revDataArray[tag] appendData:data];
    }
    else
    {
        [self.revDataArray[tag] appendData:data];
        httpResponse = [[NSString alloc] initWithData:self.revDataArray[tag] encoding:NSUTF8StringEncoding];
        [self.revDataArray[tag] setData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
        if(httpResponse)
        {
            id obj = [httpResponse JSONValue];
            if(obj && [obj isKindOfClass:[NSDictionary class]])
            {
                id resID = [obj objectForKey:@"id"];
                NSLog(@"socket_id:           %@",resID);
                id resType = [obj objectForKey:@"type"];
                
                if([resType isEqualToString:@"error"])
                {
                    if(socket.isDisconnected)
                    {
                        [self performSelector:@selector(reConnect) withObject:nil afterDelay:5];
                    }
                    else
                    {
                        [self performSelector:@selector(hbt_rq:) withObject:resID afterDelay:5];
                    }
                    return;
                }
                
                if(resID && resType)
                {
                    switch (tag) {
                        case SOCKET_TAG_AUTH_RQ:
                            if([resType isEqualToString:@"auth_rp"])
                            {
                                [self performSelector:@selector(hbt_rq:) withObject:resID afterDelay:10];
                            }
                            break;
                        default:
                            if([resType isEqualToString:@"hbt_rp"])
                            {
                                
                            }
                            else if([resType isEqualToString:@"data"])
                            {
                                
                                [self ack:resID];
                                id data = [obj objectForKey:@"data"];
                                if(data && [data isKindOfClass:[NSDictionary class]])
                                {
                                    id type = [data objectForKey:@"type"];
                                    if(type && [type isEqualToString:@"message"])
                                    {
                                        if(delegate && [delegate respondsToSelector:@selector(socketReceiveData:)])
                                        {
                                            [delegate performSelector:@selector(socketReceiveData:) withObject:data];
                                        }
                                        else
                                        {
                                            id userObj = [data objectForKey:@"user"];
                                            if(userObj && [userObj isKindOfClass:[NSDictionary class]])
                                            {
                                                id userID = [userObj objectForKey:@"id"];
                                                if(userID && [userID isKindOfClass:[NSString class]])
                                                {
                                                    id userMsgCount = [[NSUserDefaults standardUserDefaults] objectForKey:userID];
                                                    //if(userMsgCount)
                                                    {
                                                        //保存数据到本地 做列表消息数提示用
                                                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",userMsgCount?([userMsgCount intValue]+1):1] forKey:userID];
                                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                                    }
                                                }
                                            }
                                            
                                        }
                                    }
                                    else
                                    {
                                        //植物生长状态
                                    }
                                }
                           
                                
                            }
                            else
                            {
                                [self reConnect];
                            }
                            break;
                    }
                    
                    socket_id = resID;
                    
                    
                }
            }
            
        }
    }
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
	NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
    [self performSelector:@selector(reConnect) withObject:nil afterDelay:5];
}

- (void)onSocket:(GCDAsyncSocket *)sock willDisconnectWithError:(NSError *)err{
    NSLog(@"onSocket:%p willDisconnectWithError:%@", sock, err);
    [self performSelector:@selector(reConnect) withObject:nil afterDelay:5];
}

- (void)reConnect
{
    [self disconnect];
    [self initSocket];
}

- (void)disconnect
{
    if(socket)
    {
        [socket disconnect];
        socket = nil;
    }
}

@end
