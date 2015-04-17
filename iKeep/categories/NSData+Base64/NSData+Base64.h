//
//  NSData+Base64.h
//  iKeep
//
//  Created by ysmeng on 14/11/4.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//



@interface NSData (Base64)

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;

- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;

- (NSString *)base64EncodedString;

@end
