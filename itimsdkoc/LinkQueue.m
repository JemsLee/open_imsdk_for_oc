//
//  LinkQueue.m
//  imSdkForOC
//
//  Created by Jem.Lee on 2022/10/14.
//


#import "LinkQueue.h"

@interface LinkQueue()
@property (nonatomic, strong) Node *front;  //队列头指针
@property (nonatomic, strong) Node *rear;   //队列尾指针
@end

@implementation LinkQueue

/**
 构造一个链队列
 @return 队列
 */
+(instancetype)constrcutLinkQueue {
    
    LinkQueue *linkQueue = [[LinkQueue alloc] init];
    Node *headNode = [[Node alloc] init];        //便于操作，创建一个头结点
    linkQueue.front = linkQueue.rear = headNode; //均指向头结点
    
    return linkQueue;
}


/**
 入队列
 @param node 节点元素
 */
-(void)enQueueWithNode:(Node *)node {
    
    /// 尾节点的next指针指向新节点
    self.rear.next = node;
    
    /// 更改尾指针指向新节点
    self.rear = node;

}


/**
 出队列
 @return 节点元素
 */
-(Node *)deQueue {
    
    if ([self isEmpty]) {
        return nil;
    }
    
    ///取出头结点的指向的首节点
    Node *node = self.front.next;
    
    ///更改头结点指针指向首节点的下一个节点
    self.front.next = node.next;
    
    ///判断取出的节点是否为尾指针指向的节点，如果是，队列元素则全部取完，此时将首尾指针均重新指向头结点
    if (self.rear == node) {
        self.rear = self.front;
    }
    return node;
}

/**
 队列是否为空
 @return 布尔值
 */
-(BOOL)isEmpty {
    if (self.front == self.rear) {
        return YES;
    }
    return NO;
}

/**
 获取元素个数
 @return 个数
 */
-(int)eleCount {
    if (self.front == self.rear) {
        return 0;
    }
    Node *p = self.front.next;
    int eleCount = 0;
    while (p) {
        eleCount ++;
        p = p.next;
    }
    return eleCount;
}

@end
