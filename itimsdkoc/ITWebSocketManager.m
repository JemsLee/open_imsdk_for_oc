//
//  ITWebSocketManager.m
//  imSdkForOC
//
//  Created by Jem.Lee on 2022/10/11.
//

#import <Foundation/Foundation.h>
#import "ITWebSocketManager.h"
#import "ITWebSocket.h"
#import "Observable.h"
#import "MessageBody.h"
#import "AESCode.h"


@interface ITWebSocketManager ()
{
    Observable  *obs;
    NSString *ipAndPort;
    NSString *fromUid;
    NSString *token;
    NSString *deviceId;
    NSString *fbFlag;
    NSString *secKey;
}

@property (nonatomic,weak)NSTimer *pingTimer;
@property (nonatomic,assign)NSTimeInterval pingOverTime;
@property (nonatomic,assign)NSTimeInterval statusOverTime;
@property (nonatomic,assign)Boolean isLogin;


@end

@implementation ITWebSocketManager

- (void)ITWebSocketManager {
    
}

+ (instancetype)shareManager{
    static ITWebSocketManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.pingOverTime = 5;
        instance.statusOverTime = 2;
    });
    return instance;
}

//初始化
- (void)init:(NSString*)ipAndPort withFromUid:(NSString*)fromUid withToken:(NSString*)token withDeviceId:(NSString*)deviceId
withFbFlag:(NSString*)fbFlag { 
    
    obs = [[Observable alloc]init];
    self->ipAndPort = ipAndPort;
    self->fromUid = fromUid;
    self->token = token;
    self->deviceId = deviceId;
    self->fbFlag = fbFlag;
    self->secKey = [AESCode KeyStringMD5:fromUid];
}

- (void)start{
    [[ITWebSocket shareManager] inits:self->obs];
    [[ITWebSocket shareManager] itOpen:ipAndPort connect:^{
        [self->obs notifyStatusObservers:@"{\"status\":\"0\",\"desc\":\"Socket is opened\""];
        [self login];
    } receive:^(id message, ITSocketReceiveType type) {
        if (type == ITSocketReceiveTypeForMessage) {
            [self doReceive:message];
        }
    } failure:^(NSError *error) {
    }];
    
    
    // 开启定时器
    if(self.pingTimer != nil){
        [self.pingTimer invalidate];
        self.pingTimer = nil;
    }
    self.pingTimer = [NSTimer scheduledTimerWithTimeInterval:self.pingOverTime target:self selector:@selector(ping) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.pingTimer forMode:NSRunLoopCommonModes];
    
    
}
    
//停止
-(void)stop{
    [[ITWebSocket shareManager] itClose];
    [self.pingTimer invalidate];
    self.pingTimer = nil;
    _isLogin = NO;
}



//接受数据处理
-(void)doReceive:(NSString*)message{
    NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSMutableDictionary *rsDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        message = [AESCode aesDecrypt:message withKey:secKey];
    }else{
        NSString *resDesc = [rsDic objectForKey:@"resDesc"];
        if([resDesc isEqual: @"登录成功"]){
            self->_isLogin = YES;
        }
    }
    [self->obs notifyObservers:message];
}


//Login
- (void)login{
    
    NSMutableDictionary *dataArray = [[MessageBody shareManager] templeteData];
    [dataArray setValue:@"1000000" forKey:@"eventId"];
    [dataArray setValue:fromUid forKey:@"fromUid"];
    [dataArray setValue:token forKey:@"token"];
    [dataArray setValue:deviceId forKey:@"deviceId"];
    [dataArray setValue:fbFlag forKey:@"fbFlag"];
    [dataArray setValue:[self currentTimeStr] forKey:@"cTimest"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataArray options:kNilOptions error:nil];
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [[ITWebSocket shareManager] itSend:message];
    
}

//Ping
- (void)ping{
    
    if(self->_isLogin){
        NSMutableDictionary *dataArray = [[MessageBody shareManager] templeteData];
        [dataArray setValue:@"9000000" forKey:@"eventId"];
        [dataArray setValue:fromUid forKey:@"fromUid"];
        [dataArray setValue:deviceId forKey:@"deviceId"];
        [dataArray setValue:fbFlag forKey:@"fbFlag"];
        [dataArray setValue:[self currentTimeStr] forKey:@"cTimest"];
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:dataArray options:kNilOptions error:nil];
        NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        [self sendMessage:message];
    }
}

//send message to server
- (void) sendMessage:(NSString *) message{
    [[ITWebSocket shareManager] itSend:[AESCode aesEncrypt:message withKey:secKey]];
}

- (void) sendMessageObject:(MessageBody *) messageDic{
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:messageDic options:kNilOptions error:nil];
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [[ITWebSocket shareManager] itSend:[AESCode aesEncrypt:message withKey:secKey]];
    
}

//获取当前时间戳
- (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

//注册观察者
- (void)addObserver:(id<Observer>)o{
    [self->obs addObserver:o];
}

//取消观察者
- (void)cancelObserver:(id<Observer>)o{
    [self->obs cancelObserver:o];
}

//取消所有观察者
- (void)cancelAllObservers{
    [self->obs cancelAllObservers];
}

//获得所有观察者
- (NSInteger)countObservers{
    return [self->obs countObservers];
}


@end
