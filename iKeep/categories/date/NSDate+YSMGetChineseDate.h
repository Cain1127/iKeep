//
//  NSDate+YSMGetChineseDate.h
//  XMPPFrameworkUseDemo
//
//  Created by ysmeng on 14/10/29.
//  Copyright (c) 2014年 zhang jian. All rights reserved.
//

#import <Foundation/Foundation.h>

//********************************
//  定义农历日期返回的字关键字
//********************************
#define YSMCHINESEDATE_KEY_YEAR @"year"
#define YSMCHINESEDATE_KEY_MONTH @"month"
#define YSMCHINESEDATE_KEY_DATE @"date"
#define YSMCHINESEDATE_KEY_JIEQI @"jieqi"
#define YSMCHINESEDATE_KEY_FESTIVAL @"festival"

@interface NSDate (YSMGetChineseDate)

//*************************************
//      取当前日期的农历信息
//*************************************
+ (NSString *)getChineseYear;
+ (NSString *)getChineseMonth;
+ (NSString *)getChineseDate;
+ (NSString *)getChineseJieqi;
+ (NSString *)getChineseFestivals;
+ (NSDictionary *)getChineseCalenderInfo;
+ (NSDate *)getCurrentDate;
+ (NSString *)getCurrentDateString;
+ (NSDate *)getCurrentDateTime;
+ (NSString *)getCurrentDateTimeString;

//*************************************
//      取给定新历日期的农历信息
//*************************************
+ (NSString *)getChineseYear:(NSDate *)date;
+ (NSString *)getChineseMonth:(NSDate *)date;
+ (NSString *)getChineseDate:(NSDate *)date;
+ (NSString *)getChineseJieqi:(NSDate *)date;
+ (NSString *)getChineseFestivals:(NSDate *)date;
+ (NSDictionary *)getChineseCalenderInfo:(NSDate *)date;

@end
