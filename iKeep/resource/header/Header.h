//
//  Header.h
//  iKeep
//
//  Created by mac on 14-10-16.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#ifndef iKeep_Header_h
#define iKeep_Header_h

//获取屏幕高度
#define DEVICE_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

//应用的名字
#define APP_NAME @"iKeep"

//判断是否568的高
#define IS_PHONE568 (((DEVICE_HEIGHT) > 480.0f) ? YES : NO)

//plist_info_header.h
#import "plist_info_Header.h"

#import "block_Header.h"

#import "color_Header.h"

#import "NSLog_Header.h"

#import "struct_Header.h"

#import "enum_Header.h"

#import "buttonTitle/button_title_Header.h"

#import "url_Header.h"

#import "image_Header.h"

#import "tag/tag_Header.h"

#import "location/location_Header.h"

#endif
