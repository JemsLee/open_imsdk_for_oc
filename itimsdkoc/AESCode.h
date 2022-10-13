//
//  AESCode.h
//  imSdkForOC
//
//  Created by Jem.Lee on 2022/10/11.
//

#ifndef AESCode_h
#define AESCode_h


#endif /* AESCode_h */

#import <UIKit/UIKit.h>

@interface AESCode : NSObject


/**
 * User Key Md5
 */
+(NSString *)KeyStringMD5:(NSString *)srcStr;

/**
 * AES加密
 * @param sourceStr 要加密的内容
 * @param key 使用的秘钥
 */
+ (NSString *)aesEncrypt:(NSString *)sourceStr withKey:(NSString *)key;
 
/**
 * AES解密
 * @param secretStr 要解密的内容
 * @param key 使用的秘钥
 */
+ (NSString *)aesDecrypt:(NSString *)secretStr withKey:(NSString *)key;

@end
