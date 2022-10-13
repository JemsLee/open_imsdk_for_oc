//
//  Observable.m
//  Observer_OC_Demo
//
//  Created by tianxiuping on 2017/10/1.
//  Copyright © 2017年 TXP. All rights reserved.
//

#import "Observable.h"

@interface Observable()

@property (nonatomic,strong) NSMutableArray *obsArray;
@end

@implementation Observable


- (instancetype)init
{
    self = [super init];
    if (self) {
        _obsArray =[[NSMutableArray alloc]init];
    }
    return self;
}
//注册观察者
- (void)addObserver:(id<Observer>)o{
    
    [_obsArray addObject:o];
}

//取消观察者
- (void)cancelObserver:(id<Observer>)o{
    
    [_obsArray removeObject:o];
}

//取消所有观察者
- (void)cancelAllObservers{
    
    [_obsArray removeAllObjects];
}

//获得所有观察者
- (NSInteger)countObservers{
    
    return _obsArray.count;
}

//发送通知
-(void)notifyObservers{
    
    [self notifyObservers:nil];
}
-(void)notifyObservers:(NSObject*)msg{
    
    for (id<Observer>o in _obsArray) {
        [o update:self msg:msg];
    }
}

-(void)notifyStatusObservers:(NSObject*)msg{
    for (id<Observer>o in _obsArray) {
        [o onStatusChange:self msg:msg];
    }
}

@end
