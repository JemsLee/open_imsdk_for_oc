

#import <Foundation/Foundation.h>
#import "Observable.h"

typedef NS_ENUM(NSInteger,ITSocketStatus){
    ITSocketStatusConnected,// 已连接
    ITSocketStatusFailed,// 失败
    ITSocketStatusClosedByServer,// 系统关闭
    ITSocketStatusClosedByUser,// 用户关闭
    ITSocketStatusReceived// 接收消息
};

typedef NS_ENUM(NSInteger,ITSocketReceiveType){
    ITSocketReceiveTypeForMessage,
    ITSocketReceiveTypeForPong
};
/**
连接成功回调
 */
typedef void(^ITSocketDidConnectBlock)(void);
/**
失败回调
 */
typedef void(^ITSocketDidFailBlock)(NSError *error);
/**
关闭回调
 */
typedef void(^ITSocketDidCloseBlock)(NSInteger code,NSString *reason,BOOL wasClean);
/**
消息接收回调
 */
typedef void(^ITSocketDidReceiveBlock)(id message ,ITSocketReceiveType type);

@interface ITWebSocket : NSObject
/**
连接回调
 */
@property (nonatomic,copy)ITSocketDidConnectBlock connect;
/**
接收消息回调
 */
@property (nonatomic,copy)ITSocketDidReceiveBlock receive;
/**
失败回调
 */
@property (nonatomic,copy)ITSocketDidFailBlock failure;
/**
关闭回调
 */
@property (nonatomic,copy)ITSocketDidCloseBlock close;
/**
当前的socket状态
 */
@property (nonatomic,assign,readonly)ITSocketStatus itSocketStatus;
/**
超时重连时间，默认1秒
 */
@property (nonatomic,assign)NSTimeInterval overtime;

@property (nonatomic,assign)NSTimeInterval loopovertime;
/**@author Clarence
 *重连次数,默认5次
 */
@property (nonatomic, assign)NSUInteger reconnectCount;
/**
单例调用
 */
+ (instancetype)shareManager;
/**
开启socket
 *@param urlStr  服务器地址@param connect 连接成功回调@param receive 接收消息回调@param failure 失败回调
 */
- (void)itOpen:(NSString *)urlStr connect:(ITSocketDidConnectBlock)connect receive:(ITSocketDidReceiveBlock)receive failure:(ITSocketDidFailBlock)failure;
/**
关闭socket
 *@param close 关闭回调
 */
- (void)itClose:(ITSocketDidCloseBlock)close;
/**
发送消息，NSString 或者 NSData
 *@param data Send a UTF8 String or Data.
 */
- (void)itSend:(id)data;

- (void)itClose;

- (void)inits:(Observable *)fobs;

- (void)itReconnect;

- (void)itCheckStatus;
@end
