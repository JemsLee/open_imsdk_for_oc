//
//  ViewController.m
//  imSdkForOC
//
//  Created by Jem.Lee on 2022/10/11.
//

#import "ViewController.h"
#import "AESCode.h"
#import "ITWebSocket.h"
#import "ITWebSocketManager.h"
#import "Observer.h"
#import "MessageBody.h"

@interface ViewController ()<Observer>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *ipAndPort = @"ws://13.250.111.190:9922";
    NSString *fromUid = @"1001_30088";
    NSString *token = @"123";
    NSString *deviceId = [self currentTimeStr];
    NSString *fbFlag = @"1001";
    
    [[ITWebSocketManager shareManager] init:ipAndPort withFromUid:fromUid withToken:token withDeviceId:deviceId withFbFlag:fbFlag];
    [[ITWebSocketManager shareManager] addObserver:self];
    [[ITWebSocketManager shareManager] start];
    
}

//获取当前时间戳
- (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}
    

- (void)update:(Observable *)o msg:(NSObject *)msg{
    NSLog(@"=%@",msg);
}

- (void)onStatusChange:(Observable *)o msg:(NSObject *)msg{
    NSLog(@"Status=%@",msg);
}


@end
