//
//  YSMMainHandler.h
//  iKeep
//
//  Created by mac on 14-10-18.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSMMainHandleDataModel.h"

@interface YSMMainHandler : NSObject

+ (YSMMainHandler *)shareMainHandler;

//默认请求
- (void)requestData:(HANDLE_ACTION_TYPE)actionType andAction:(BLOCK_HANDLER_ACTION)action;
//按给定页请求
- (void)requestData:(HANDLE_ACTION_TYPE)actionType andPage:(int)page andAction:(BLOCK_HANDLER_ACTION)action;
//按给定的ID请求数据
- (void)requestData:(HANDLE_ACTION_TYPE)actionType andID:(NSString *)objectID andAction:(BLOCK_HANDLER_ACTION)action;

@property (nonatomic,copy) BLOCK_HANDLER_ACTION action;

//*********************************************
//      定位功能
//*********************************************
#pragma mark - 定位功能
- (void)getCurrentCity:(BLOCK_NSSTRING_ACTION)successAction andFailCallBack:(BLOCK_NSSTRING_ACTION)failAction;

@end
