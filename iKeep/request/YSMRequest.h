//
//  YSMRequest.h
//  iKeep
//
//  Created by mac on 14-10-18.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSMRequest : NSObject

////////////////////////////////////////////////////////////////////////////
//                                                                                                                                            //
//                                   属性                                                                                                 //
//                                                                                                                                            //
////////////////////////////////////////////////////////////////////////////
@property (nonatomic,assign) NSInteger requestTag;//记录请求的tag

////////////////////////////////////////////////////////////////////////////
//                                                                                                                                            //
//                                   类方法                                                                                             //
//                                                                                                                                            //
////////////////////////////////////////////////////////////////////////////
+ (void)doSyncRequest:(REQUEST_TYPE)requestType andTag:(NSInteger)tag andCallBack:(BLOCK_REQUEST_CALLBACK_ACTION)action;

+ (void)doSyncRequest:(REQUEST_TYPE)requestType andURL:(NSURL *)url andTag:(NSInteger)tag andCallBack:(BLOCK_REQUEST_CALLBACK_ACTION)action;

////////////////////////////////////////////////////////////////////////////
//                                                                                                                                            //
//                                   对象方法                                                                                         //
//                                                                                                                                            //
////////////////////////////////////////////////////////////////////////////

@end
