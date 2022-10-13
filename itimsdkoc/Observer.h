//
//  Observer.h
//  Observer_OC_Demo
//
//  Created by tianxiuping on 2017/10/1.
//  Copyright © 2017年 TXP. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Observable;

//观察者->抽象
@protocol Observer <NSObject>
//
-(void)update:(Observable*)o msg:(NSObject*)msg;

-(void)onStatusChange:(Observable*)o msg:(NSObject*)msg;

@end
