//
//  LinkQueue.h
//  imSdkForOC
//
//  Created by Jem.Lee on 2022/10/14.
//

#import <Foundation/Foundation.h>
#import "Node.h"

NS_ASSUME_NONNULL_BEGIN

@interface LinkQueue : NSObject


/**
 构造一个链队列
 @return 队列
 */
+(instancetype)constrcutLinkQueue;


/**
 入队列
 @param node 节点元素
 */
-(void)enQueueWithNode:(Node *)node;


/**
 出队列
 @return 节点元素
 */
-(Node *)deQueue;


/**
 队列是否为空
 @return 布尔值
 */
-(BOOL)isEmpty;


/**
 获取元素个数
 @return 个数
 */
-(int)eleCount;


@end

NS_ASSUME_NONNULL_END
