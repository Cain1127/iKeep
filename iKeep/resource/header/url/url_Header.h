//
//  url_Header.h
//  iKeep
//
//  Created by mac on 14-10-18.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#ifndef iKeep_url_Header_h
#define iKeep_url_Header_h

/*************************************************************/
//                      XMPP服务器信息
/*************************************************************/
#pragma mark - XMPP服务器信息
#define XMPP_SERVER_DOMAIN @"ysmeng.local"
//#define XMPP_SERVER_HOST @"192.168.1.101"
#define XMPP_SERVER_HOST @"10.3.132.16"

/*************************************************************/
//                      请求数据使用的URL
/*************************************************************/
#pragma mark - 请求数据使用的URL
//广告页地址：引用的是网易新闻广告
#define URL_APP_LOAD_AVERT @"http://g1.163.com/madr?app=7A16FBB6&platform=iOS&category=STARTUP&location=1"
//健康资讯地址：引用的是网易健康资讯
#define URL_HEALTHY_NEWS @"http://c.3g.163.com/nc/article/list/T1414389941036/%d-20.html"
//健康资讯详情
#define URL_HEALTHY_NEWS_DETAIL @"http://c.m.163.com/nc/article/%@/full.html"
//个人主页的天气城市及提醒信息请求
#define URL_MAIN_HOME_PERSON_DEADER @"http://hi.huofar.com/iA/board?v=2.8.1&client=iPod%20touch%2C8.1&uuid=70BDF4A7-8C7B-4B4A-AF84-A8A37D94BE5D&sign=04C06B709F067BC3103115B1D75094D8&parameters=dWlkPTI5MTE0NjM0JnByb3ZpbmNlbmFtZT3lub%2FkuJwmcmlkPS0xJmdlbmRlcj0w%0D%0AJmRpc2Vhc2U9MCZiaXJ0aGRheT0wJnRpemhpPU4mY291bnRyeW5hbWU9JmhvdXI9%0D%0AMTAmY2l0eW5hbWU95bm%2F5bee&app_key=b2f59baec2a0c69f7d10442305b80e"

//健康小提醒请求地址
#define URL_MAIN_HOME_HEALTHYRECOMMEND_1 @"http://hi.huofar.com/iA/sceneList?uid=29114634&county=%E5%A4%A9%E6%B2%B3%E5%8C%BA&city=%E5%B9%BF%E5%B7%9E&name=%E6%88%91%E8%87%AA%E5%B7%B1&diseases%5B%5D=0&v=2.8.1&latitude="
#define URL_MAIN_HOME_HEALTHYRECOMMEND_2 @"&province=%E5%B9%BF%E4%B8%9C&tizhi=N&longitude="
#define URL_MAIN_HOME_HEALTHYRECOMMEND_3 @"&time="
#define URL_MAIN_HOME_HEALTHYRECOMMEND_4 @"%2F10-0"
//健康素菜推荐
#define URL_HEALTHY_FOOD_RECOMMEND_VEGETABLE @"http://hi.huofar.com/iA/scene/show?parameters=bnVtPTgmcGFydD04OCZkaXNlYXNlPSZjaXR5PeW5v%2BW3niZ0aXpoaT1I&app_key=b2f59baec2a0c69f7d10442305b80e&sign=62B26626A1D1AFC521DCD46F95969C54&client=iPod%20touch%2C8.1&city=%E5%B9%BF%E5%B7%9E&v=2.8.1&date=20141108&province=%E5%B9%BF%E4%B8%9C&uuid=70BDF4A7-8C7B-4B4A-AF84-A8A37D94BE5D"
#define URL_HEALTHY_FOOD_RECOMMEND_VEGETABLE_1 @"http://hi.huofar.com/iA/scene/show?parameters=bnVtPTgmcGFydD04OCZkaXNlYXNlPSZjaXR5PeW5v%2BW3niZ0aXpoaT1I&app_key=b2f59baec2a0c69f7d10442305b80e&sign=62B26626A1D1AFC521DCD46F95969C54&client=iPod touch%2C8.1&city="
#define URL_HEALTHY_FOOD_RECOMMEND_VEGETABLE_2 @"&v=2.8.1&date="
#define URL_HEALTHY_FOOD_RECOMMEND_VEGETABLE_3 @"&province="
#define URL_HEALTHY_FOOD_RECOMMEND_VEGETABLE_4 @"&uuid=70BDF4A7-8C7B-4B4A-AF84-A8A37D94BE5D"
//健康肉食推荐
#define URL_HEALTHY_FOOD_RECOMMEND_MEET @"http://hi.huofar.com/iA/scene/show?parameters=bnVtPTgmcGFydD04NyZkaXNlYXNlPSZjaXR5PeW5v%2BW3niZ0aXpoaT1I&app_key=b2f59baec2a0c69f7d10442305b80e&sign=B6F145C232215A5C6CDFBE87EF3D0F96&client=iPod%20touch%2C8.1&city=%E5%B9%BF%E5%B7%9E&v=2.8.1&date=20141108&province=%E5%B9%BF%E4%B8%9C&uuid=70BDF4A7-8C7B-4B4A-AF84-A8A37D94BE5D"
#define URL_HEALTHY_FOOD_RECOMMEND_MEET_1 @"http://hi.huofar.com/iA/scene/show?parameters=bnVtPTgmcGFydD04NyZkaXNlYXNlPSZjaXR5PeW5v%2BW3niZ0aXpoaT1I&app_key=b2f59baec2a0c69f7d10442305b80e&sign=B6F145C232215A5C6CDFBE87EF3D0F96&client=iPod touch%2C8.1&city="
#define URL_HEALTHY_FOOD_RECOMMEND_MEET_2 @"&v=2.8.1&date="
#define URL_HEALTHY_FOOD_RECOMMEND_MEET_3 @"&province="
#define URL_HEALTHY_FOOD_RECOMMEND_MEET_4 @"&uuid=70BDF4A7-8C7B-4B4A-AF84-A8A37D94BE5D"
//节气推荐
#define URL_HEALTHY_FOOD_JIEQI_RECOMMEND @"http://hi.huofar.com/iA/scene/show?parameters=a2V5d29yZD0mZGlzZWFzZT0mc2NlbmVJZD0xMDQ0JnRpemhpPUg%3D&app_key=b2f59baec2a0c69f7d10442305b80e&sign=041B4E1158AEC89FF528D84DA927F244&client=iPod%20touch%2C8.1&city=%E5%B9%BF%E5%B7%9E&v=2.8.1&date=20141108&province=%E5%B9%BF%E4%B8%9C&uuid=70BDF4A7-8C7B-4B4A-AF84-A8A37D94BE5D"
#define URL_HEALTHY_FOOD_JIEQI_RECOMMEND_1 @"http://hi.huofar.com/iA/scene/show?parameters=a2V5d29yZD0mZGlzZWFzZT0mc2NlbmVJZD0xMDQ0JnRpemhpPUg%3D&app_key=b2f59baec2a0c69f7d10442305b80e&sign=041B4E1158AEC89FF528D84DA927F244&client=iPod touch%2C8.1&city="
#define URL_HEALTHY_FOOD_JIEQI_RECOMMEND_2 @"&v=2.8.1&date="
#define URL_HEALTHY_FOOD_JIEQI_RECOMMEND_3 @"&province="
#define URL_HEALTHY_FOOD_JIEQI_RECOMMEND_4 @"&uuid=70BDF4A7-8C7B-4B4A-AF84-A8A37D94BE5D"

//健康视屏
#define URL_HEALTHY_NEWS_MEDIA @"http://c.m.163.com/nc/video/list/00850FRB/n/%d-10.html"
//健康书城
#define URL_MALL_MAIN_LIST_1 @"http://api.s.m.taobao.com/search.json?propertyMenu=on&sort=_coefp&q="
#define URL_MALL_MAIN_LIST_2 @"&vm=nw&search_wap_mall=false&utd_id=VFWhTaQG3nIDABmPGj7TW%2BfU&ttid=201200%40taobao_iphone_5.1.0&itemfields=commentCount&info=WIFI&latitude=23.178398&from=input&longitude=113.335197&style=list&page="
#define URL_MALL_MAIN_LIST_3 @"&showspu=true&sputips=on&new_shopstar=true&forbidPic=0&filterEmpty=true&n=10&filterUnused=true&setting_on=imgBanners%2Cuserdoc&_input_charset=utf-8&"

//******************************************
//      本地文件保存
//******************************************
#define ARCHIVE_PATH_SELFvCARD [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),@"iKeep/vCard"]
#define ARCHIVE_PATH_SELFvCARD_FILENAME @"selfvCardData.data"
#define ARCHIVE_PATH_ADVERT_IMAGE [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),@"iKeep/advert"]
#define ARCHIVE_PATH_ADVERT_IMAGE_FILENAME @"advertImage.data"
#define ARCHIVE_PATH_MAIN_HOME_HEADER [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),@"iKeep/mainHome/headerNews"]
#define ARCHIVE_PATH_MAIN_HOME_HEADER_FILENAME @"header.data"

#endif
