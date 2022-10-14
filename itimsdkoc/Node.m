//
//  Node.m
//  imSdkForOC
//
//  Created by Jem.Lee on 2022/10/14.
//

#import "Node.h"

@implementation Node

-(instancetype)initWithData:(NSString*)data {
    self = [super init];
    if (self) {
        self.data = data;
        self.next = nil;
    }
    return self;
}

@end
