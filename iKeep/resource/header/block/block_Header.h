//
//  block_Header.h
//  iKeep
//
//  Created by mac on 14-10-16.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#ifndef iKeep_block_Header_h
#define iKeep_block_Header_h

#import "enum_Header.h"

/*----------button action block----------*/
typedef void (^BLOCK_VOID_ACTION)(void);
typedef void (^BLOCK_INT_ACTION)(int num);
typedef void (^BLOCK_BOOL_ACTION)(BOOL flag);
typedef void (^BLOCK_ARRAY_ACTION)(NSArray *array);
typedef void (^BLOCK_DICTIONARY_ACTION)(NSDictionary *dict);
typedef void (^BLOCK_NSSTRING_ACTION)(NSString *string);
typedef void (^BLOCK_NSSTRING_BLOCK_ACTION)(NSString *string,BLOCK_BOOL_ACTION callBack);
typedef void (^BLOCK_BLOCK_ACTION)(BLOCK_BOOL_ACTION callBack);
typedef void (^BLOCK_DDMENU_CALLBACK_ACTION)(DDMENU_ACTION_TYPE actionType,DDMENU_TYPE menuType);
typedef void (^BLOCK_ERROR_ACTION)(NSError *error);
typedef void (^BLOCK_ID_ACTION)(id result);
typedef BOOL (^BOOL_BLOCK_NSSTRING_ACTION)(NSString *jidString);

/*----------page control action block----------*/
typedef void (^BLOCK_PAGE_CONTROL_ACTION)(int page);

/*----------button action block----------*/
typedef void (^BLOCK_BUTTON_ACTION)(UIButton *button);

/*----------handler action block----------*/
@class YSMMainHandleDataModel;
typedef void (^BLOCK_HANDLER_ACTION)(YSMMainHandleDataModel *result);

/*----------同步请求acttion block----------*/
typedef void (^BLOCK_REQUEST_CALLBACK_ACTION)(NSData *data,NSError *error);

/*----------sender string action block----------*/
typedef void (^BLOCK_AVERT_MESSAGE_ANALYZE_ACTION)(NSString *str,CGFloat advertTime);

@class YSMRegistUserDataModel;
/*----------注册用户时如若成功返回执行的block----------*/
typedef void (^BLOCK_REGISTUSERMODEL_ACTION)(NSString *count);

/*---------健康推荐的数据模型事件--------*/
@class YSMHealthyRecommendCardDataModel;
typedef void (^BLOCK_HEALTHYRECOMMEND_ACTION)(YSMHealthyRecommendCardDataModel *model);

/*-------聊天视图相关block--------*/
@class YSMMessageModel;
typedef void (^BLOCK_TCMVACTIONTYPE_ACTION)(TC_NA_MIDDLE_VIEW_ACTION_TYPE actionType);
typedef void (^BLOCK_XMMODEL_ACTION)(YSMMessageModel *model);

/*---------新闻类型block---------*/
typedef void (^BLOCK_NEWSTYPE_ACTION)(HEALTHY_NEWS_TYPE newsType);

/*----------请闻详情数据模型block----------*/
@class YSMNewsDetailDataModel;
typedef void (^BLOCK_NEWSDETAIL_ACTION)(YSMNewsDetailDataModel *resultModel);

/*---------更新头像block--------*/
@class YSMvCardDataModel;
typedef void (^BLOCK_vCARDMODEL_ACTION)(YSMvCardDataModel *model);


#endif
