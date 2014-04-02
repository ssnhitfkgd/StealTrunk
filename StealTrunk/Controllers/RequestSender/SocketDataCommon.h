//
//  SocketDataCommon.h
//  StealTrunk
//
//  Created by wangyong on 13-7-12.
//
//

#import "DataModelBase.h"
#import "GCDAsyncSocket.h"

typedef enum
{
    SOCKET_TAG_AUTH_RQ = 0,
    SOCKET_TAG_HBT_RQ,
    SOCKET_TAG_DATA_RQ,
    SOCKET_TAG_COM,
}
SOCKET_TAG;

@protocol SocketDataCommonDelegate <NSObject>
- (void)socketReceiveData:(id)data;
@end

@interface SocketDataCommon : NSObject<SocketDataCommonDelegate>
{
    GCDAsyncSocket *socket;
    NSString *host;
    uint16_t port;
    long long socket_id;
}

@property (nonatomic, retain) id<SocketDataCommonDelegate>  delegate;
@property (nonatomic, strong) NSArray *revDataArray;
+ (SocketDataCommon *)sharedInstance;

- (void)initSocket;


- (void)hbt_rq:(NSString*)sock_id;

- (void)hbt_rp:(NSString*)sock_id;

- (void)data_rq:(NSString*)data sock_id:(NSString*)sock_id;

- (void)ack:(NSString*)sock_id;

@end
