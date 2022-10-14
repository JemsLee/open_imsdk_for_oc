//
//  Node.h
//  imSdkForOC
//
//  Created by Jem.Lee on 2022/10/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Node : NSObject
@property (nonatomic, assign) NSString* data;
@property (nonatomic, strong, nullable) Node *next;
-(instancetype)initWithData:(NSString*)data;
@end

NS_ASSUME_NONNULL_END
