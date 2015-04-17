//
//  plist_info_Header.h
//  iKeep
//
//  Created by mac on 14-10-16.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#ifndef iKeep_plist_info_Header_h
#define iKeep_plist_info_Header_h

/*----------plist文件相关key----------*/
#define PIST_FILE_TYPE @"plist"
#define PLIST_GUIDE_INFO @"guide_info"


/*----------guide_info_plist文件相关key----------*/
#define PLIST_KEY_GUIDE_IMAGES_ARRAY @"guide_image_array"
#define PLIST_KEY_TOPIC_VIEW_ARRAY @"home_page_tab_view"

/*----------tabbar信息使用的key----------*/
#define TABBAR_DICTIONARY_KEY_CLASS @"class"
#define TABBAR_DICTIONARY_KEY_IMAGE @"image"
#define TABBAR_DICTIONARY_KEY_IMAGE_SELECTED @"image_selected"
#define TABBAR_DICTIONARY_KEY_TITLE @"title"

/*----------用户使用本应用的NSUserDefault数据----------*/
#define USER_BASIX_INFO__ROOT_DICTIONARY @"iKeep_user_basic_info"
#define USER_BASIX_INFO__ISFIRSRUSE @"isFirstUse"
#define USER_BASIX_INFO__ISFIRSRUSE_INFO @"NO"

/*----------请求相关的key数据----------*/
#define REQUEST_KEY_ADVERT_ARRAY @"ads"
#define REQUEST_KEY_ADVERT_TIME @"show_time"
#define REQUES_KEY_AVERT_IMAGESARRAY @"res_url"

//个人主页的基本信息关键字
#define REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_CITY @"city"
#define REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_TODAY @"today"
#define REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_WEATHER_TITLE @"weatherTitle"
#define REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_WEATHER_LOWTEM @"lowTemp"
#define REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_WEATHER_HIGHTEM @"highTemp"
#define REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_TOMORROW @"tomorrow"
#define REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_YIJI @"yiji"
#define REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_YI @"1"
#define REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_JI @"2"
#define REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_YIJI_TITLE @"title"
#define REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_TODAY_YI @"today_yi"
#define REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_TODAY_JI @"today_ji"

//个人主页的健康推荐数据关键字
#define REQUEST_KEY_MAINHOME_HEALTHYRECOMMEND_TOPIC @"sceneList"
#define REQUEST_KEY_MAINHOME_HEALTHYRECOMMEND_TOPIC_ARRAY @"sections"
#define REQUEST_KEY_MAINHOME_HEALTHYRECOMMEND_TOPIC_TITLE @"sectionTitle"
#define REQUEST_KEY_MAINHOME_HEALTHYRECOMMEND_TOPIC_ROWS @"rows"
#define REQUEST_KEY_MAINHOME_HEALTHYRECOMMEND_SCENES @"scenes"
#define REQUEST_KEY_MAINHOME_HEALTHYRECOMMEND_SCENEID @"sceneId"
#define REQUEST_KEY_MAINHOME_HEALTHYRECOMMEND_SCENE_ABOVEIMAGEURL @"sceneTitleImage"
#define REQUEST_KEY_MAINHOME_HEALTHYRECOMMEND_SCENE_BGIMAGEURL @"sceneBackgroundImage"

//温度的格式
#define TEMP_STRING_FORMAT @"%@℃ / %@℃"

/*----------日期格式化使用的key----------*/
#define DATE_FORMATTER_NORMAL @"yyyy年mm月dd日"
#define DATE_FORMATTER_NOYEAR @"mm月dd日"



#endif
