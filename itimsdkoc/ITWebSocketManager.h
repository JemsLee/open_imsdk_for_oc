//
//  ITWebSocketManager.h
//  imSdkForOC
//
//  Created by Jem.Lee on 2022/10/11.
//

#import "Observer.h"
#ifndef ITWebSocketManager_h
#define ITWebSocketManager_h


#endif /* ITWebSocketManager_h */


@interface ITWebSocketManager:NSObject

/**
单例调用
 */
+ (instancetype)shareManager;

- (void)init:(NSString*)ip withFromUid:(NSString*)fromUid withToken:(NSString*)token withDeviceId:(NSString*)deviceId
withFbFlag:(NSString*)fbFlag ;

- (void) start;

- (void) stop;

- (void) login;

- (void) ping;

- (void) sendMessage:(NSString *) message;

-(void) ITWebSocketManager;

//注册观察者
- (void)addObserver:(id<Observer>)o;

//取消观察者
- (void)cancelObserver:(id<Observer>)o;

//取消所有观察者
- (void)cancelAllObservers;

//获得所有观察者
- (NSInteger)countObservers;
@end
