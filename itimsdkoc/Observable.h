//
//  Observable.h
//  Observer_OC_Demo
//
//  Created by tianxiuping on 2017/10/1.
//  Copyright © 2017年 TXP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Observer.h"
//被观察者
@interface Observable : NSObject

//注册观察者
- (void)addObserver:(id<Observer>)o;

//取消观察者
- (void)cancelObserver:(id<Observer>)o;

//取消所有观察者
- (void)cancelAllObservers;

//获得所有观察者
- (NSInteger)countObservers;

//发送通知
-(void)notifyObservers;
-(void)notifyObservers:(NSObject*)msg;
-(void)notifyStatusObservers:(NSObject*)msg;

@end
