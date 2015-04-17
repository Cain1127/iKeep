//
//  enum_Header.h
//  iKeep
//
//  Created by mac on 14-10-16.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#ifndef iKeep_enum_Header_h
#define iKeep_enum_Header_h

//控件类型
typedef enum
{
    RequestAvertMessage = 0,
    RequestAvertImage,
    RequestMainHomePersonCardData,
    RequestMainHomeHealthyRecommendData,
    RequestHealthyNewsTextNewsListData,
    RequestHealthyNewsMediaNewsListData,
    RequestNewsDetailData,
    RequestMallListData,
    RequestHealthyFoodRecommendData,
    RequestJieqiHealthyFoodRecommendData
}HANDLE_ACTION_TYPE;

//请求类型
typedef enum
{
    advertMessageRequestType = 0,
    advertImageRequestType,
    mainHomePersonCardRequestType,
    mainHomeHealthyRecommendRequestType,
    healthyNewsTextNewsListRequestType,
    healthyNewsMediaNewsListRequestType,
    newsDetailDataRequestType,
    mallListDataRequestType,
    healthyFoodRecommendDataRequestVegetableType,
    healthyFoodRecommendDataRequestMeetType,
    jieqiHealthyFoodRecommendDataRequestType
}REQUEST_TYPE;

//导航栏中左中右等视图类型
typedef enum
{
    navigationBarLeftView = 0,
    navigationBarRightView,
    navigationBarMiddleView,
    navigationBarMiddleLeftView,
    navigationBarMiddleRightView
}NAVIGATION_BAR_VIEW_TYPE;

//自定义错误类型
typedef enum
{
    XDefultFailed = -1000,
    XRegisterFailed,
    XConnectFailed,
    XJIDPackagedFailed,
    XMyvCardPackagedFailed,
    MHPersonHeaderInfoAnalyzeFail
}CustomErrorFailed;

//DDMenu的类型：左功能视图、右功能视图
typedef enum
{
    LeftDDMenu = 0,
    RightDDMenu
}DDMENU_TYPE;

//DDMenu中不同的事件类型
typedef enum
{
    DefaultActionDDMenu = -1,
    AdvertShowActionDDMenu = 0,
    ChangeSkipTopicActionDDMenu,
    
    //左侧功能
    PrivateButtonActionDDMenu,
    HomeButtonActionDDMenu,
    HealthyButtonActionDDMenu,
    NewsButtonActionDDMenu,
    MallButtonActionDDMenu,
    
    //右侧功能
    ChangeIconActionDDMenu,
    AddNewFamiliesActionDDMenu,
    ExitButtonActionDDMenu,
    AddFamiliesActionDDMenu
}DDMENU_ACTION_TYPE;

//talk控件视图中，中间视图按钮类型
typedef enum
{
    TCNAMVLeftButtonActionType = 0,
    TCNAMVRightButtonActionType
}TC_NA_MIDDLE_VIEW_ACTION_TYPE;

//即时通讯的类开
typedef enum
{
    XMTypeSend,
    XMTypeReceive
}XMPP_MESSAGE_TYPE;

//通讯的消息是否读取
typedef enum
{
    XMReadStatuReaded,
    XMReadStatuUNReaded
}XMPP_MESSAGE_READFLAG;

//消息来源类型
typedef enum
{
    XMFromSelf,
    XMFromFamilies
}XM_FROM_TYPE;

//新闻咨询栏中：新闻和视屏分类
typedef enum
{
    MediaHealthyNews,
    MediaHealthyNewsHeader,
    TextHealthyNews,
    TextHealthyHeaderNews,
    ImageHealthyNews
}HEALTHY_NEWS_TYPE;

//商品列表中：评价高中低
typedef enum
{
    HighDesScore = 0,
    MiddleDesScore,
    LowDesScore
}GOODS_DESSCORE_LEVEL;

//广告页加载的类型：初始加载、通过主页面返回
typedef enum
{
    AdvertFirstLoadType,
    AdvertOtherLoadType
}ADERT_VIEW_TYPE;

//健康菜普类型
typedef enum
{
    JieqiHealthyFoodsRecommendType,
    HealthyFoodsRecommendType
}JIEQI_FOOD_TYPE;

#endif
