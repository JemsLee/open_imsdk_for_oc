//
//  MessageBody.m
//  imSdkForOC
//
//  Created by Jem.Lee on 2022/10/13.
//

#import <Foundation/Foundation.h>
#import "MessageBody.h"

@interface MessageBody()

@end

@implementation MessageBody

+ (instancetype)shareManager{
    static MessageBody *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSMutableDictionary *) templeteData {
    
    NSMutableDictionary * messageDic = [[NSMutableDictionary alloc] init];
    
    [messageDic setValue:@"" forKey:@"eventId"];//事件ID，参考事件ID文件
    [messageDic setValue:@"" forKey:@"fromUid"];//发送者ID
    [messageDic setValue:@"" forKey:@"token"];//发送者token
    [messageDic setValue:@"" forKey:@"channelId"];//用户的channelId
    
    [messageDic setValue:@"" forKey:@"toUid"];//接收者ID，多个以逗号隔开
    [messageDic setValue:@"1" forKey:@"mType"];//消息类型
    [messageDic setValue:@"" forKey:@"cTimest"];//客户端发送时间搓
    [messageDic setValue:@"" forKey:@"sTimest"];//服务端接收时间搓
    [messageDic setValue:@"" forKey:@"dataBody"];//消息体，可以自由定义，以字符串格式传入
    
    [messageDic setValue:@"0" forKey:@"isGroup"];//是否群组 1-群组，0-个人
    [messageDic setValue:@"" forKey:@"groupId"];//群组ID
    [messageDic setValue:@"" forKey:@"groupName"];//群组名称
    [messageDic setValue:@"" forKey:@"pkGroupId"];//pk时使用
    [messageDic setValue:@"" forKey:@"spUid"];//特殊用户ID
    
    [messageDic setValue:@"0" forKey:@"isAck"];//客户端接收到服务端发送的消息后，返回的状态= 1；dataBody结构 sTimest,sTimest,sTimest,sTimest......
    
    [messageDic setValue:@"0" forKey:@"isCache"];//是否需要存离线 1-需要，0-不需要
    [messageDic setValue:@"" forKey:@"deviceId"];//唯一设备id，目前用AFID作为标识，登录时带入
    [messageDic setValue:@"" forKey:@"oldChannelId"];//准备离线的channel
    [messageDic setValue:@"0" forKey:@"isRoot"];//是否机器人 1-机器人
    [messageDic setValue:@"fbFlag" forKey:@"fbFlag"];//分包的标记
    
    return messageDic;
}

@end
